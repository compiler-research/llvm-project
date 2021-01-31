//===--- IncrementalParser.h - Incremental Compilation ----------*- C++ -*-===//
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

#ifndef LLVM_CLANG_INTERPRETER_INCREMENTALPARSER_H
#define LLVM_CLANG_INTERPRETER_INCREMENTALPARSER_H

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/Error.h"

#include <memory>
#include <vector>

namespace clang {
class ASTConsumer;
class CompilerInstance;
class CodeGenerator;
class DeclGroupRef;
class FrontendAction;
class Parser;

/// Provides support for incremental compilation. Keeps track of the state
/// changes between the subsequent incremental input.
///
class IncrementalParser {
  /// Long-lived, incremental parsing action.
  std::unique_ptr<FrontendAction> Act;

  /// Compiler instance performing the incremental compilation.
  std::unique_ptr<CompilerInstance> CI;

  /// Parser.
  std::unique_ptr<Parser> P;

  /// Consumer to process the produced top level decls. Owned by Act.
  ASTConsumer *Consumer = nullptr;

  /// Incremental input counter.
  unsigned InputCount = 0;

  /// List containing every parsed top level decl.
  std::vector<DeclGroupRef> TopLevelDecls;

public:
  IncrementalParser(std::unique_ptr<CompilerInstance> Instance);
  ~IncrementalParser();

  const CompilerInstance *getCI() const { return CI.get(); }
  CodeGenerator *getCodeGen() const;
  llvm::Expected<llvm::ArrayRef<DeclGroupRef>> Parse(llvm::StringRef Input);

private:
  bool ParseOrWrapTopLevelDecl();
};
} // end namespace clang

#endif // LLVM_CLANG_INTERPRETER_INCREMENTALPARSER_H
