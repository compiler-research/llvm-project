//===--- IncrementalExecutor.cpp - Incremental Execution --------*- C++ -*-===//
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

#include "IncrementalExecutor.h"

#include "llvm/ExecutionEngine/ExecutionEngine.h"
#include "llvm/ExecutionEngine/Orc/CompileUtils.h"
#include "llvm/ExecutionEngine/Orc/ExecutionUtils.h"
#include "llvm/ExecutionEngine/Orc/IRCompileLayer.h"
#include "llvm/ExecutionEngine/Orc/LLJIT.h"
#include "llvm/ExecutionEngine/Orc/RTDyldObjectLinkingLayer.h"
#include "llvm/ExecutionEngine/SectionMemoryManager.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/ManagedStatic.h"
#include "llvm/Support/TargetSelect.h"

namespace clang {

IncrementalExecutor::IncrementalExecutor(llvm::Error &Err) {
  using namespace llvm::orc;
  llvm::ErrorAsOutParameter EAO(&Err);
  auto JitOrErr = LLJITBuilder().create();
  if (auto Err2 = JitOrErr.takeError()) {
    Err = std::move(Err2);
    return;
  }

  // Discover symbols from the process as a fallback.
  const llvm::DataLayout &DL = (*JitOrErr)->getDataLayout();
  auto ProcessSymbolsGenerator =
    DynamicLibrarySearchGenerator::GetForCurrentProcess(DL.getGlobalPrefix());

  if (!ProcessSymbolsGenerator) {
    Err = ProcessSymbolsGenerator.takeError();
    return;
  }

  Jit = std::move(*JitOrErr);

  llvm::sys::DynamicLibrary::LoadLibraryPermanently(nullptr);
  JITDylib &MainJD = Jit->getMainJITDylib();
  MainJD.addGenerator(std::move(*ProcessSymbolsGenerator));
}

IncrementalExecutor::~IncrementalExecutor() { }

llvm::Error IncrementalExecutor::addModule(std::unique_ptr<llvm::Module> M) {
  llvm::orc::ThreadSafeContext TSCtx(std::make_unique<llvm::LLVMContext>());
  return Jit->addIRModule(llvm::orc::ThreadSafeModule(std::move(M), TSCtx));
}

  /*Expected<JITTargetAddress>
IncrementalExecutor::getSymbolAddress(llvm::StringRef Name) const {
  return Jit->getSymbolAddress(Name);
  }*/

llvm::Error
IncrementalExecutor::runCtors() const {
  return Jit->initialize(Jit->getMainJITDylib());
}

} // end namespace clang
