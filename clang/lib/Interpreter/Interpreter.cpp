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

#include "IncrementalParser.h"

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
}

const CompilerInstance *Interpreter::getCompilerInstance() const {
  return IncrParser->getCI();
}

llvm::Expected<llvm::ArrayRef<DeclGroupRef>>
Interpreter::Process(llvm::StringRef Code) {
  return IncrParser->Parse(Code);
}
