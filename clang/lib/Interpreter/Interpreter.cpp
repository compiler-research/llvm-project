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

using namespace clang;

Interpreter::Interpreter(llvm::Error& Err) {
  std::vector<const char *> v = {"-Xclang", "-emit-llvm-only"};
  llvm::ExitOnError(Initialize(v));
}

Interpreter::Interpreter(std::vector<const char *> &ClangArgs,
                         llvm::Error& Err) {
  llvm::ExitOnError(Initialize(ClangArgs));
}

Interpreter::~Interpreter() {}

llvm::Error Interpreter::Initialize(std::vector<const char *> &ClangArgs) {
  IncrParser = std::make_unique<IncrementalParser>(ClangArgs);
  llvm::Error Err = llvm::Error::success();
  IncrExecutor = std::make_unique<IncrementalExecutor>(Err);
  return Err;
}

const CompilerInstance *Interpreter::getCompilerInstance() const {
  return IncrParser->getCI();
}

llvm::Expected<Transaction&> Interpreter::Process(llvm::StringRef Code) {
  Transactions.emplace_back(Transaction());
  Transaction &LastTransaction = Transactions.back();

  auto ErrOrTransaction = IncrParser->Parse(Code);
  if (auto Err = ErrOrTransaction.takeError())
    return Err;

  LastTransaction.Decls = *ErrOrTransaction;
  CodeGenerator &CG = IncrParser->getCodeGen();
  std::unique_ptr<llvm::Module> M(CG.ReleaseModule());
  CG.StartModule("incr_module_" + std::to_string(Transactions.size()),
                 M->getContext());

  // FIXME: Add a callback to retain the llvm::Module once the JIT is done.
  LastTransaction.TheModule = std::move(M);
  if (auto Err = IncrExecutor->addModule(std::move(LastTransaction.TheModule)))
    return Err;

  if (auto Err = IncrExecutor->runCtors(Ctors))
    return Err;

  return LastTransaction;
}
