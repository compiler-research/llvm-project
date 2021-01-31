//===------ Interpreter.cpp - Incremental Compilation and Execution -------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the component which performs incremental code
// compilation and execution.
//
//===----------------------------------------------------------------------===//

#include "clang/Interpreter/Interpreter.h"

#include "clang/CodeGen/ModuleBuilder.h"
#include "clang/Frontend/CompilerInstance.h"

#include "llvm/IR/Module.h"

#include "IncrementalParser.h"
#include "IncrementalExecutor.h"

//
#include "clang/Basic/TargetInfo.h"

#include "clang/CodeGen/ObjectFilePCHContainerOperations.h"

#include "clang/Driver/Compilation.h"
#include "clang/Driver/Driver.h"
#include "clang/Driver/Job.h"
#include "clang/Driver/Options.h"
#include "clang/Driver/Tool.h"
#include "clang/Frontend/TextDiagnosticBuffer.h"


#include "clang/Frontend/TextDiagnosticPrinter.h"
#include "clang/Frontend/VerifyDiagnosticConsumer.h"
#include "clang/Lex/PreprocessorOptions.h"

#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/Host.h"
//

using namespace clang;

// FIXME: Figure out how to unify with namespace init_convenience from
//        tools/clang-import-test/clang-import-test.cpp and
//        examples/clang-interpreter/main.cpp
namespace {
/// Retrieves the clang CC1 specific flags out of the compilation's jobs.
/// \returns NULL on error.
static llvm::Expected<const llvm::opt::ArgStringList*>
GetCC1Arguments(DiagnosticsEngine *Diagnostics,
                driver::Compilation *Compilation) {
  // We expect to get back exactly one Command job, if we didn't something
  // failed. Extract that job from the Compilation.
  const driver::JobList &Jobs = Compilation->getJobs();
  if (!Jobs.size() || !isa<driver::Command>(*Jobs.begin()))
    return llvm::createStringError(std::errc::state_not_recoverable,
                                   "Driver initialization failed: "
                                   "Unable to create a driver job");

  // The one job we find should be to invoke clang again.
  const driver::Command *Cmd = cast<driver::Command>(&(*Jobs.begin()));
  if (llvm::StringRef(Cmd->getCreator().getName()) != "clang")
    return llvm::createStringError(std::errc::state_not_recoverable,
                                   "Driver initialization failed");

  return &Cmd->getArguments();
}


static llvm::Expected<std::unique_ptr<CompilerInstance>>
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
    return llvm::createStringError(std::errc::state_not_recoverable,
                                   "Initialization failed: "
                                   "Unable to create diagnostics engine");

  DiagsBuffer->FlushDiagnostics(Clang->getDiagnostics());
  if (!Success)
    return llvm::createStringError(std::errc::state_not_recoverable,
                                   "Initialization failed: "
                                   "Unable to flush diagnostics");

  // FIXME: Merge with CompilerInstance::ExecuteAction.
  llvm::MemoryBuffer *MB = llvm::MemoryBuffer::getMemBuffer("").release();
  Clang->getPreprocessorOpts().addRemappedFile("<<< inputs >>>", MB);

  Clang->setTarget(TargetInfo::CreateTargetInfo(
      Clang->getDiagnostics(), Clang->getInvocation().TargetOpts));
  if (!Clang->hasTarget())
    return llvm::createStringError(std::errc::state_not_recoverable,
                                   "Initialization failed: "
                                   "Target is missing");

  Clang->getTarget().adjust(Clang->getLangOpts());

  return std::move(Clang);
}


} // anonymous namespace

llvm::Expected<std::unique_ptr<CompilerInstance>>
IncrementalCompilerBuilder::create(std::vector<const char *> &ClangArgv) {

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

  auto ErrOrCC1Args = GetCC1Arguments(&Diags, Compilation.get());
  if (auto Err = ErrOrCC1Args.takeError())
    return Err;

  return CreateCI(**ErrOrCC1Args);
}

Interpreter::Interpreter(std::unique_ptr<CompilerInstance> CI,
                         llvm::Error &Err) {
  llvm::ErrorAsOutParameter EAO(&Err);
  IncrParser = std::make_unique<IncrementalParser>(std::move(CI));
}

Interpreter::~Interpreter() {}

llvm::Expected<std::unique_ptr<Interpreter>>
Interpreter::create(std::unique_ptr<CompilerInstance> CI) {
  llvm::Error Err = llvm::Error::success();
  auto Interp =
    std::unique_ptr<Interpreter>(new Interpreter(std::move(CI), Err));
  if (Err)
    return Err;
  return std::move(Interp);
}

const CompilerInstance *Interpreter::getCompilerInstance() const {
  return IncrParser->getCI();
}

llvm::Expected<Transaction&> Interpreter::Parse(llvm::StringRef Code) {
  Transactions.emplace_back(Transaction());
  Transaction &LastTransaction = Transactions.back();

  auto ErrOrTransaction = IncrParser->Parse(Code);
  if (auto Err = ErrOrTransaction.takeError())
    return Err;

  LastTransaction.Decls = *ErrOrTransaction;
  if (CodeGenerator *CG = IncrParser->getCodeGen()) {
    std::unique_ptr<llvm::Module> M(CG->ReleaseModule());
    CG->StartModule("incr_module_" + std::to_string(Transactions.size()),
                    M->getContext());

    LastTransaction.TheModule = std::move(M);
  }

  return LastTransaction;
}

llvm::Error Interpreter::Execute(Transaction &T) {
  assert(T.TheModule);
  if (!IncrExecutor) {
    llvm::Error Err = llvm::Error::success();
    IncrExecutor = std::make_unique<IncrementalExecutor>(Err);
    if (Err)
      return Err;
  }
  // FIXME: Add a callback to retain the llvm::Module once the JIT is done.
  if (auto Err = IncrExecutor->addModule(std::move(T.TheModule)))
    return Err;

  if (auto Err = IncrExecutor->runCtors())
    return Err;

  return llvm::Error::success();
}
