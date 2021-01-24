//===--------- IncrementalParser.cpp - Incremental Compilation  -----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the class which performs incremental code compilation.
//
//===----------------------------------------------------------------------===//

#include "IncrementalParser.h"

#include "clang/Basic/TargetInfo.h"
#include "clang/CodeGen/BackendUtil.h"
#include "clang/CodeGen/CodeGenAction.h"
#include "clang/CodeGen/ModuleBuilder.h"
#include "clang/CodeGen/ObjectFilePCHContainerOperations.h"
#include "clang/Driver/Compilation.h"
#include "clang/Driver/Driver.h"
#include "clang/Driver/Job.h"
#include "clang/Driver/Options.h"
#include "clang/Driver/Tool.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/FrontendAction.h"
#include "clang/Frontend/FrontendDiagnostic.h"
#include "clang/Frontend/TextDiagnosticBuffer.h"
#include "clang/Frontend/TextDiagnosticPrinter.h"
#include "clang/Frontend/VerifyDiagnosticConsumer.h"
#include "clang/FrontendTool/Utils.h"
#include "clang/Lex/PreprocessorOptions.h"
#include "clang/Parse/Parser.h"
#include "clang/Sema/Sema.h"

#include "llvm/Option/ArgList.h"
#include "llvm/Support/CrashRecoveryContext.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/Host.h"
#include "llvm/Support/Signals.h"
#include "llvm/Support/Timer.h"

#include <sstream>

using namespace clang;

// FIXME: Figure out how to unify with namespace init_convenience from
//        tools/clang-import-test/clang-import-test.cpp and
//        examples/clang-interpreter/main.cpp
namespace {
/// Retrieves the clang CC1 specific flags out of the compilation's jobs.
/// \returns NULL on error.
static const llvm::opt::ArgStringList *
GetCC1Arguments(DiagnosticsEngine *Diagnostics,
                driver::Compilation *Compilation) {
  // We expect to get back exactly one Command job, if we didn't something
  // failed. Extract that job from the Compilation.
  const driver::JobList &Jobs = Compilation->getJobs();
  if (!Jobs.size() || !isa<driver::Command>(*Jobs.begin())) {
    // FIXME: diagnose this...
    return nullptr;
  }

  // The one job we find should be to invoke clang again.
  const driver::Command *Cmd = cast<driver::Command>(&(*Jobs.begin()));
  if (llvm::StringRef(Cmd->getCreator().getName()) != "clang") {
    // FIXME: diagnose this...
    return nullptr;
  }

  return &Cmd->getArguments();
}

static void LLVMErrorHandler(void *UserData, const std::string &Message,
                             bool GenCrashDiag) {
  DiagnosticsEngine &Diags = *static_cast<DiagnosticsEngine *>(UserData);

  Diags.Report(diag::err_fe_error_backend) << Message;

  // Run the interrupt handlers to make sure any special cleanups get done, in
  // particular that we remove files registered with RemoveFileOnSignal.
  llvm::sys::RunInterruptHandlers();

  // We cannot recover from llvm errors.  When reporting a fatal error, exit
  // with status 70 to generate crash diagnostics.  For BSD systems this is
  // defined as an internal software error.  Otherwise, exit with status 1.
  exit(GenCrashDiag ? 70 : 1);
}

static std::unique_ptr<CompilerInstance>
CreateCI(const llvm::opt::ArgStringList &Argv) {
  std::unique_ptr<CompilerInstance> Clang(new CompilerInstance());
  IntrusiveRefCntPtr<DiagnosticIDs> DiagID(new DiagnosticIDs());

  // Register the support for object-file-wrapped Clang modules.
  auto PCHOps = Clang->getPCHContainerOperations();
  PCHOps->registerWriter(std::make_unique<ObjectFilePCHContainerWriter>());
  PCHOps->registerReader(std::make_unique<ObjectFilePCHContainerReader>());

  // Buffer diagnostics from argument parsing so that we can output them using
  // a well formed diagnostic object.
  IntrusiveRefCntPtr<DiagnosticOptions> DiagOpts = new DiagnosticOptions();
  TextDiagnosticBuffer *DiagsBuffer = new TextDiagnosticBuffer;
  DiagnosticsEngine Diags(DiagID, &*DiagOpts, DiagsBuffer);
  bool Success = CompilerInvocation::CreateFromArgs(
  Clang->getInvocation(), llvm::makeArrayRef(Argv.begin(), Argv.size()), Diags);

  // Infer the builtin include path if unspecified.
  if (Clang->getHeaderSearchOpts().UseBuiltinIncludes &&
      Clang->getHeaderSearchOpts().ResourceDir.empty())
    Clang->getHeaderSearchOpts().ResourceDir =
        CompilerInvocation::GetResourcesPath(Argv[0], nullptr);

  // Create the actual diagnostics engine.
  Clang->createDiagnostics();
  if (!Clang->hasDiagnostics())
    return nullptr;

  // Set an error handler, so that any LLVM backend diagnostics go through our
  // error handler.
  llvm::install_fatal_error_handler(
      LLVMErrorHandler, static_cast<void *>(&Clang->getDiagnostics()));

  DiagsBuffer->FlushDiagnostics(Clang->getDiagnostics());
  if (!Success)
    return nullptr;

  // FIXME: Merge with CompilerInstance::ExecuteAction.
  llvm::MemoryBuffer *MB = llvm::MemoryBuffer::getMemBuffer("").release();
  Clang->getPreprocessorOpts().addRemappedFile("<<< inputs >>>", MB);

  Clang->setTarget(TargetInfo::CreateTargetInfo(
      Clang->getDiagnostics(), Clang->getInvocation().TargetOpts));
  if (!Clang->hasTarget())
    return 0;

  Clang->getTarget().adjust(Clang->getLangOpts());

  return Clang;
}

static std::unique_ptr<CompilerInstance>
CreateCI(std::vector<const char *> &ClangArgv) {

  // If we don't know ClangArgv0 or the address of main() at this point, try
  // to guess it anyway (it's possible on some platforms).
  std::string MainExecutableName =
      llvm::sys::fs::getMainExecutable(nullptr, nullptr);

  ClangArgv.insert(ClangArgv.begin(), MainExecutableName.c_str());

  if (std::find(ClangArgv.begin(), ClangArgv.end(), " -x") == ClangArgv.end()) {
    // We do C++ by default; append right after argv[0] if no "-x" given
    ClangArgv.push_back("-x");
    ClangArgv.push_back("c++");
  }
  // By adding -c, we force the driver to treat compilation as the last phase.
  // It will then issue warnings via Diagnostics about un-used options that
  // would have been used for linking. If the user provided a compiler name as
  // the original argv[0], this will be treated as a linker input thanks to
  // insertng a new argv[0] above. All un-used options get collected by
  // UnusedInputdiagConsumer and get stripped out later.
  ClangArgv.push_back("-c");

  // Put a dummy C++ file on to ensure there's at least one compile job for the
  // driver to construct. If the user specified some other argument that
  // prevents compilation, e.g. -E or something like -version, we may still end
  // up with no jobs but then this is the user's fault.
  ClangArgv.push_back("<<< inputs >>>");

  CompilerInvocation Invocation;
  // Buffer diagnostics from argument parsing so that we can output them using a
  // well formed diagnostic object.
  IntrusiveRefCntPtr<DiagnosticIDs> DiagID(new DiagnosticIDs());
  IntrusiveRefCntPtr<DiagnosticOptions> DiagOpts = new DiagnosticOptions();
  TextDiagnosticBuffer *DiagsBuffer = new TextDiagnosticBuffer;
  DiagnosticsEngine Diags(DiagID, &*DiagOpts, DiagsBuffer);
  unsigned MissingArgIndex, MissingArgCount;
  const llvm::opt::OptTable &Opts = driver::getDriverOptTable();
  llvm::opt::InputArgList ParsedArgs
    = Opts.ParseArgs(ArrayRef<const char *>(ClangArgv).slice(1),
                     MissingArgIndex, MissingArgCount);
  ParseDiagnosticArgs(*DiagOpts, ParsedArgs, &Diags);

  driver::Driver Driver(/*MainBinaryName*/ ClangArgv[0],
                        llvm::sys::getDefaultTargetTriple(), Diags);
  Driver.setCheckInputsExist(false); // the input comes from mem buffers
  llvm::ArrayRef<const char *> RF = llvm::makeArrayRef(ClangArgv);
  std::unique_ptr<driver::Compilation> Compilation(Driver.BuildCompilation(RF));

  if (Compilation->getArgs().hasArg(driver::options::OPT_v))
    Compilation->getJobs().Print(llvm::errs(), "\n", /*Quote*/ false);

  const llvm::opt::ArgStringList *CC1Args =
      GetCC1Arguments(&Diags, Compilation.get());
  if (!CC1Args)
    return 0;

  return CreateCI(*CC1Args);
}

} // anonymous namespace

/// A custom action enabling the incremental processing functionality.
///
/// The usual \p FrontendAction expects one call to ExecuteAction and once it
/// sees a call to \p EndSourceFile it deletes some of the important objects
/// such as \p Preprocessor and \p Sema assuming no further input will come.
///
/// \p IncrementalAction ensures it keep its underlying action's objects alive
/// as long as the \p IncrementalParser needs them.
///
class IncrementalAction : public WrapperFrontendAction {
private:
  bool IsTerminating = false;

public:
  IncrementalAction(CompilerInstance &CI)
    : WrapperFrontendAction(CreateFrontendAction(CI)) {}
  FrontendAction *getWrapped() const { return WrappedAction.get(); }
  void ExecuteAction() override {
    CompilerInstance &CI = getCompilerInstance();
    assert(CI.hasPreprocessor() && "No PP!");

    // FIXME: Move the truncation aspect of this into Sema, we delayed this till
    // here so the source manager would be initialized.
    if (hasCodeCompletionSupport() &&
        !CI.getFrontendOpts().CodeCompletionAt.FileName.empty())
      CI.createCodeCompletionConsumer();

    // Use a code completion consumer?
    CodeCompleteConsumer *CompletionConsumer = nullptr;
    if (CI.hasCodeCompletionConsumer())
      CompletionConsumer = &CI.getCodeCompletionConsumer();

    if (!CI.hasSema())
      CI.createSema(getTranslationUnitKind(), CompletionConsumer);

    Preprocessor &PP = CI.getPreprocessor();
    PP.enableIncrementalProcessing();
    PP.EnterMainSourceFile();
  }

  void EndSourceFile() override {
    if (IsTerminating) {
      WrapperFrontendAction::EndSourceFile();
    }
  }

  void FinalizeAction() {
    assert(!IsTerminating && "Already finalized!");
    IsTerminating = true;
    EndSourceFile();
  }
};

IncrementalParser::IncrementalParser(std::vector<const char *> &ClangArgv) {
  // FIXME: Investigate if we could use runToolOnCodeWithArgs from tooling. It
  // can replace the boilerplate code for creation of the compiler instance.
  CI = CreateCI(ClangArgv);

  Act = std::make_unique<IncrementalAction>(*CI);
  CI->ExecuteAction(*Act);
  Consumer = &CI->getASTConsumer();
  P.reset(
      new Parser(CI->getPreprocessor(), CI->getSema(), /*SkipBodies*/ false));
  P->Initialize();
}

IncrementalParser::~IncrementalParser() {
  ((IncrementalAction *)Act.get())->FinalizeAction();
  // Our error handler depends on the Diagnostics object, which we're
  // potentially about to delete. Uninstall the handler now so that any
  // later errors use the default handling behavior instead.
  llvm::remove_fatal_error_handler();
}

bool IncrementalParser::ParseOrWrapTopLevelDecl() {
  // Recover resources if we crash before exiting this method.
  Sema &S = CI->getSema();
  llvm::CrashRecoveryContextCleanupRegistrar<Sema> CleanupSema(&S);
  Sema::GlobalEagerInstantiationScope SavedPendingInstantiations(
      S, /*Enabled*/ true);

  // Skip previous eof due to last incremental input.
  if (P->getCurToken().is(tok::eof))
    P->ConsumeToken();

  auto MaybeWrap = [](Parser *P, Preprocessor &PP){
    if (P->isDeclarationStatement())
      return;
    // void __wrapper_N() { ... }
    auto Tok = std::make_unique<Token[]>(5);
    Tok[0].startToken();
    Tok[0].setKind(tok::identifier);
    PP.CreateString("void", Tok[0]);
    Tok[1].startToken();
    Tok[1].setKind(tok::identifier);
    PP.CreateString("__wrapper", Tok[1]);
    Tok[2].startToken();
    Tok[2].setKind(tok::l_paren);
    Tok[2].setLength(0);
    Tok[3].startToken();
    Tok[3].setKind(tok::r_paren);
    Tok[3].setLength(0);
    Tok[4].startToken();
    Tok[4].setKind(tok::l_brace);
    Tok[4].setLength(0);
    PP.EnterTokenStream(std::move(Tok), /*NumToks=*/5,
                        /*DisableMacroExpansion=*/true,
                        /*IsReinject=*/false);
  };

  auto ProcessDecl = [this](Parser::DeclGroupPtrTy ADecl) {
    // If we got a null return and something *was* parsed, ignore it.  This
    // is due to a top-level semicolon, an action override, or a parse error
    // skipping something.
    if (ADecl) {
      if (!Consumer->HandleTopLevelDecl(ADecl.get()))
        return true;
      TopLevelDecls.push_back(ADecl.get());
    }
    return false;
  };

  Parser::DeclGroupPtrTy ADecl;
  //MaybeWrap(P.get(), S.getPreprocessor());
  if (P->ParseFirstTopLevelDecl(ADecl) || ProcessDecl(ADecl))
    return true;

  bool AtEOF = false;
  while(!AtEOF) {
    //MaybeWrap(P.get(), S.getPreprocessor());
    AtEOF = P->ParseTopLevelDecl(ADecl);
    if (ProcessDecl(ADecl))
      return true;
  }

  // Process any TopLevelDecls generated by #pragma weak.
  for (Decl *D : S.WeakTopLevelDecls()) {
    DeclGroupRef DGR(D);
    TopLevelDecls.push_back(DGR);
    Consumer->HandleTopLevelDecl(DGR);
  }

  Consumer->HandleTranslationUnit(S.getASTContext());

  return CI->getDiagnostics().hasErrorOccurred();
}

CodeGenerator &IncrementalParser::getCodeGen() const {
  IncrementalAction *IncrAct = static_cast<IncrementalAction*>(Act.get());
  FrontendAction *WrappedAct = IncrAct->getWrapped();
  return *static_cast<CodeGenAction*>(WrappedAct)->getCodeGenerator();
}

llvm::Expected<llvm::ArrayRef<DeclGroupRef>>
IncrementalParser::Parse(llvm::StringRef input) {
  Preprocessor &PP = CI->getPreprocessor();
  assert(PP.isIncrementalProcessingEnabled() && "Not in incremental mode!?");

  std::ostringstream SourceName;
  SourceName << "input_line_" << InputCount++;

  // Create an uninitialized memory buffer, copy code in and append "\n"
  size_t InputSize = input.size(); // don't include trailing 0
  // MemBuffer size should *not* include terminating zero
  std::unique_ptr<llvm::MemoryBuffer> MB(
      llvm::WritableMemoryBuffer::getNewUninitMemBuffer(InputSize + 1,
                                                        SourceName.str()));
  char *MBStart = const_cast<char *>(MB->getBufferStart());
  memcpy(MBStart, input.data(), InputSize);
  memcpy(MBStart + InputSize, "\n", 2);

  SourceManager &SM = CI->getSourceManager();

  // Create SourceLocation, which will allow clang to order the overload
  // candidates for example
  SourceLocation NewLoc = SM.getLocForStartOfFile(SM.getMainFileID())
                              .getLocWithOffset(InputCount + 2);

  // Create FileID for the current buffer.
  FileID FID = SM.createFileID(std::move(MB), SrcMgr::C_User, /*LoadedID*/ 0,
                               /*LoadedOffset*/ 0, NewLoc);

  // NewLoc only used for diags.
  PP.EnterSourceFile(FID, /*DirLookup*/ 0, NewLoc);

  unsigned lastTransaction = TopLevelDecls.size();
  if (ParseOrWrapTopLevelDecl())
    return llvm::make_error<llvm::StringError>("Parsing failed.",
                                               std::error_code());

#ifdef LLVM_ON_WIN32
  // Microsoft-specific:
  // Late parsed templates can leave unswallowed "macro"-like tokens.
  // They will seriously confuse the Parser when entering the next
  // source file. So lex until we are EOF.
  Token Tok;
  do {
    PP.Lex(Tok);
  } while (Tok.isNot(tok::eof));
#endif

#ifndef NDEBUG
  Token AssertTok;
  PP.Lex(AssertTok);
  assert(AssertTok.is(tok::eof) &&
         "Lexer must be EOF when starting incremental parse!");
#endif

  return llvm::makeArrayRef(&TopLevelDecls[lastTransaction],
                            TopLevelDecls.size() - lastTransaction);
}
