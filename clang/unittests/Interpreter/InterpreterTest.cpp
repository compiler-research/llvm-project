//===- unittests/Interpreter/InterpreterTest.cpp --- Interpreter tests ----===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Unit tests for our Interpreter library.
//
//===----------------------------------------------------------------------===//

#include "clang/Interpreter/Interpreter.h"

#include "clang/AST/Decl.h"
#include "clang/AST/DeclGroup.h"

#include "llvm/ADT/ArrayRef.h"

#include "gtest/gtest.h"

using namespace clang;

namespace {

TEST(InterpreterTest, Sanity) {
  llvm::ExitOnError ExitOnErr;

  Interpreter Interp;
  if (auto DeclsOrErr = Interp.process("void g(); void g() {}")) {
    llvm::ArrayRef<DeclGroupRef> R1 = *DeclsOrErr;
    EXPECT_EQ(2U, R1.size());
  }
  if (auto DeclsOrErr = Interp.process("int i;")) {
    llvm::ArrayRef<DeclGroupRef> R2 = *DeclsOrErr;
    EXPECT_EQ(1U, R2.size());
  }
}

static std::string DeclToString(DeclGroupRef DGR) {
  return llvm::cast<NamedDecl>(DGR.getSingleDecl())->getQualifiedNameAsString();
}

TEST(InterpreterTest, IncrementalInputTopLevelDecls) {
  Interpreter Interp;
  auto R1OrErr = Interp.process("int var1 = 42; int f() { return var1; }");
  // gtest doesn't expand into explicit bool conversions.
  EXPECT_TRUE(!!R1OrErr);
  auto R1 = R1OrErr.get();
  EXPECT_EQ(2U, R1.size());
  EXPECT_EQ("var1", DeclToString(R1[0]));
  EXPECT_EQ("f", DeclToString(R1[1]));

  auto R2OrErr = Interp.process("int var2 = f();");
  EXPECT_TRUE(!!R2OrErr);
  auto R2 = R2OrErr.get();
  EXPECT_EQ(1U, R2.size());
  EXPECT_EQ("var2", DeclToString(R2[0]));
}

// Here we test whether the user can mix declarations and statements. The
// interpreter should be smart enough to recognize the declarations from the
// statements and wrap the latter into a declaration, producing valid code.
TEST(InterpreterTest, DeclsAndStatements) {
  Interpreter Interp;
  auto R1OrErr = Interp.process(
      "int var1 = 42; extern \"C\" int printf(const char*, ...);");
  // gtest doesn't expand into explicit bool conversions.
  EXPECT_TRUE(!!R1OrErr);

  auto R1 = R1OrErr.get();
  EXPECT_EQ(2U, R1.size());

  // FIXME: Add support for wrapping and running statements.
  auto R2OrErr =
      Interp.process("var1++; printf(\"var1 value is %d\\n\", var1);");
  EXPECT_FALSE(!!R2OrErr);
  auto Err = R2OrErr.takeError();
  EXPECT_EQ("Parsing failed.", llvm::toString(std::move(Err)));
}

} // end anonymous namespace
