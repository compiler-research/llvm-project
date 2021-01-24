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
using namespace llvm;
using namespace llvm::orc;
class SimpleJIT {
private:
  ExecutionSession ES;
  std::unique_ptr<TargetMachine> TM;
  const DataLayout DL;
  MangleAndInterner Mangle{ES, DL};
  JITDylib &MainJD{ES.createBareJITDylib("<main>")};
  RTDyldObjectLinkingLayer ObjectLayer{ES, createMemMgr};
  IRCompileLayer CompileLayer{ES, ObjectLayer,
                              std::make_unique<SimpleCompiler>(*TM)};

  static std::unique_ptr<SectionMemoryManager> createMemMgr() {
    return std::make_unique<SectionMemoryManager>();
  }

  SimpleJIT(
      std::unique_ptr<TargetMachine> TM, DataLayout DL,
      std::unique_ptr<DynamicLibrarySearchGenerator> ProcessSymbolsGenerator)
      : TM(std::move(TM)), DL(std::move(DL)) {
    llvm::sys::DynamicLibrary::LoadLibraryPermanently(nullptr);
    MainJD.addGenerator(std::move(ProcessSymbolsGenerator));
  }

public:
  ~SimpleJIT() {
    if (auto Err = ES.endSession())
      ES.reportError(std::move(Err));
  }

  static Expected<std::unique_ptr<SimpleJIT>> Create() {
    auto JTMB = JITTargetMachineBuilder::detectHost();
    if (!JTMB)
      return JTMB.takeError();

    auto TM = JTMB->createTargetMachine();
    if (!TM)
      return TM.takeError();

    auto DL = (*TM)->createDataLayout();

    auto ProcessSymbolsGenerator =
        DynamicLibrarySearchGenerator::GetForCurrentProcess(
            DL.getGlobalPrefix());

    if (!ProcessSymbolsGenerator)
      return ProcessSymbolsGenerator.takeError();

    return std::unique_ptr<SimpleJIT>(new SimpleJIT(
        std::move(*TM), std::move(DL), std::move(*ProcessSymbolsGenerator)));
  }

  const TargetMachine &getTargetMachine() const { return *TM; }

  Error addModule(ThreadSafeModule M) {
    return CompileLayer.add(MainJD, std::move(M));
  }

  Expected<JITEvaluatedSymbol> findSymbol(const StringRef &Name) {
    return ES.lookup({&MainJD}, Mangle(Name));
  }

  Expected<JITTargetAddress> getSymbolAddress(const StringRef &Name) {
    auto Sym = findSymbol(Name);
    if (!Sym)
      return Sym.takeError();
    return Sym->getAddress();
  }

  Error runCtorDtor(iterator_range<CtorDtorIterator> Tors) {
    CtorDtorRunner R(MainJD);
    R.add(Tors);
    return R.run();
  }
};

IncrementalExecutor::IncrementalExecutor(llvm::Error &Err) {
  auto JitOrErr = LLJITBuilder().create();
  if (!JitOrErr) {
    Err = std::move(JitOrErr.takeError());
    return;
  }

  // Discover symbols from the process as a fallback.
  const DataLayout &DL = (*JitOrErr)->getDataLayout();
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

Error IncrementalExecutor::addModule(std::unique_ptr<llvm::Module> M) {
  ThreadSafeContext TSCtx(std::make_unique<LLVMContext>());
  return Jit->addIRModule(llvm::orc::ThreadSafeModule(std::move(M), TSCtx));
}

  /*Expected<JITTargetAddress>
IncrementalExecutor::getSymbolAddress(llvm::StringRef Name) const {
  return Jit->getSymbolAddress(Name);
  }*/

llvm::Error
IncrementalExecutor::runCtors(iterator_range<CtorDtorIterator> &Ctors) const {
  return Jit->initialize(Jit->getMainJITDylib());
}

} // end namespace clang
