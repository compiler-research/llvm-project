//===--- Interpreter.h - Incremental Compilation and Execution---*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the  the component which performs incremental code
// compilation and execution.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_CLANG_INTERPRETER_INTERPRETER_H
#define LLVM_CLANG_INTERPRETER_INTERPRETER_H

#include "llvm/ADT/ArrayRef.h"
#include "llvm/Support/Error.h"

#include <list>
#include <memory>
#include <vector>

namespace llvm {
class Module;
}

namespace clang {

class CompilerInstance;
class DeclGroupRef;
class IncrementalExecutor;
class IncrementalParser;
struct Transaction {
  llvm::ArrayRef<clang::DeclGroupRef> Decls;
  std::unique_ptr<llvm::Module> TheModule;
};

/// Create a pre-configured \c CompilerInstance for incremental processing.
class IncrementalCompilerBuilder {
public:
  static llvm::Expected<std::unique_ptr<CompilerInstance>>
  create(std::vector<const char *> &ClangArgv);
};

/// Provides top-level interfaces for incremental compilation and execution.
class Interpreter {
  std::unique_ptr<IncrementalParser> IncrParser;
  std::unique_ptr<IncrementalExecutor> IncrExecutor;
  std::list<Transaction> Transactions;

  Interpreter(std::unique_ptr<CompilerInstance> CI, llvm::Error &Err);
public:
  ~Interpreter();
  static llvm::Expected<std::unique_ptr<Interpreter>>
  create(std::unique_ptr<CompilerInstance> CI);
  const CompilerInstance *getCompilerInstance() const;
  llvm::Expected<Transaction&> Parse(llvm::StringRef Code);
  llvm::Error Execute(Transaction &T);
  llvm::Error ParseAndExecute(llvm::StringRef Code) {
    auto ErrOrTransaction = Parse(Code);
    if (auto Err = ErrOrTransaction.takeError())
      return Err;
    return Execute(*ErrOrTransaction);
  }
};
}

#endif // LLVM_CLANG_INTERPRETER_INTERPRETER_H
