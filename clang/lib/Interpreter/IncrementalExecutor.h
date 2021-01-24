//===--- IncrementalExecutor.h - Incremental Execution ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the class which performs incremental code execution.
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/StringRef.h"
#include "llvm/ExecutionEngine/JITSymbol.h"
#include "llvm/ExecutionEngine/Orc/ExecutionUtils.h"

#include <memory>

namespace llvm {
class Error;
class Module;
namespace orc {
  class LLJIT;
}
}

namespace clang {
class IncrementalExecutor {
  using CtorDtorIterator = llvm::orc::CtorDtorIterator;
  std::unique_ptr<llvm::orc::LLJIT> Jit;

public:
  IncrementalExecutor(llvm::Error &Err);
  ~IncrementalExecutor();

  llvm::Error addModule(std::unique_ptr<llvm::Module> M);
  /*llvm::Expected<llvm::JITTargetAddress>
    getSymbolAddress(llvm::StringRef Name) const;*/
  llvm::Error runCtors(llvm::iterator_range<CtorDtorIterator> &Ctors) const;
};

} // end namespace clang
