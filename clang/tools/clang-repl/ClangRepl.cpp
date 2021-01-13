//===--- tools/clang-repl/ClangRepl.cpp - clang-repl - the Clang REPL -----===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
//  This file implements a REPL tool on top of clang.
//
//===----------------------------------------------------------------------===//

#include "clang/Interpreter/Interpreter.h"

#include "llvm/LineEditor/LineEditor.h"
#include "llvm/Support/ManagedStatic.h" // llvm_shutdown
#include "llvm/Support/TargetSelect.h"  // llvm::Initialize*
#include "llvm/Support/CommandLine.h"

static llvm::cl::list<std::string>
    ClangArgs("Xcc", llvm::cl::ZeroOrMore,
              llvm::cl::desc("Argument to pass to the CompilerInvocation"),
              llvm::cl::CommaSeparated);

int main(int argc, const char **argv) {
  llvm::cl::ParseCommandLineOptions(argc, argv);

  // Initialize targets first, so that --version shows registered targets.
  llvm::InitializeAllTargets();
  llvm::InitializeAllTargetMCs();
  llvm::InitializeAllAsmPrinters();
  llvm::InitializeAllAsmParsers();

  if (ClangArgs.empty()) {
    ClangArgs.push_back("-Xclang");
    ClangArgs.push_back("-emit-llvm-only");
  }
  std::vector<const char *> ClangArgv(ClangArgs.size());
  std::transform(ClangArgs.begin(), ClangArgs.end(), ClangArgv.begin(),
                 [](const std::string &s) -> const char * { return s.data(); });

  clang::Interpreter Interp(ClangArgv);
  llvm::LineEditor LE("clang-repl");
  // FIXME: Add LE.setListCompleter
  while (llvm::Optional<std::string> Line = LE.readLine()) {
    if (*Line == "quit")
      break;
    auto ErrOrTransaction = Interp.Process(*Line);
    if (auto Err = ErrOrTransaction.takeError())
      llvm::logAllUnhandledErrors(std::move(Err), llvm::errs(), "error: ");
  }

  llvm::llvm_shutdown();

  return 0;
}
