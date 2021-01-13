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

#include <memory>
#include <vector>

namespace clang {

class CompilerInstance;
class DeclGroupRef;
class IncrementalParser;

/// Provides top-level interfaces for incremental compilation and execution.
class Interpreter {
  std::unique_ptr<IncrementalParser> IncrParser;
public:
  Interpreter();
  Interpreter(std::vector<const char *> &ClangArgs);
  ~Interpreter();

  const CompilerInstance *getCompilerInstance() const;
  llvm::Expected<llvm::ArrayRef<DeclGroupRef>> Process(llvm::StringRef Code);
protected:
  llvm::Error Initialize(std::vector<const char *> &ClangArgs);
};
}

#endif // LLVM_CLANG_INTERPRETER_INTERPRETER_H
