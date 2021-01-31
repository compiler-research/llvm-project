//===- unittests/Interpreter/InterpreterTest.cpp --- Interpreter tests ----===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Unit tests for our Interpreter library.
//
//===----------------------------------------------------------------------===//

#include "clang/Frontend/CompilerInstance.h"
#include "clang/Interpreter/Interpreter.h"

#include "clang/AST/Decl.h"
#include "clang/AST/DeclGroup.h"

#include "llvm/ADT/ArrayRef.h"

#include "gtest/gtest.h"

using namespace clang;

namespace {

static std::unique_ptr<Interpreter> createInterpreter() {
  std::vector<const char *> ClangArgs = {"-Xclang", "-emit-llvm-only"};
  auto CI = cantFail(clang::IncrementalCompilerBuilder::create(ClangArgs));
  return std::move(cantFail(clang::Interpreter::create(std::move(CI))));
}

TEST(InterpreterTest, Sanity) {
  std::unique_ptr<Interpreter> Interp = createInterpreter();
  Transaction &R1(cantFail(Interp->Parse("void g(); void g() {}")));
  EXPECT_EQ(2U, R1.Decls.size());

  Transaction &R2(cantFail(Interp->Parse("int i;")));
  EXPECT_EQ(1U, R2.Decls.size());
}

static std::string DeclToString(DeclGroupRef DGR) {
  return llvm::cast<NamedDecl>(DGR.getSingleDecl())->getQualifiedNameAsString();
}

TEST(InterpreterTest, IncrementalInputTopLevelDecls) {
  std::unique_ptr<Interpreter> Interp = createInterpreter();
  auto R1OrErr = Interp->Parse("int var1 = 42; int f() { return var1; }");
  // gtest doesn't expand into explicit bool conversions.
  EXPECT_TRUE(!!R1OrErr);
  auto R1 = R1OrErr->Decls;
  EXPECT_EQ(2U, R1.size());
  EXPECT_EQ("var1", DeclToString(R1[0]));
  EXPECT_EQ("f", DeclToString(R1[1]));

  auto R2OrErr = Interp->Parse("int var2 = f();");
  EXPECT_TRUE(!!R2OrErr);
  auto R2 = R2OrErr->Decls;
  EXPECT_EQ(1U, R2.size());
  EXPECT_EQ("var2", DeclToString(R2[0]));
}


TEST(InterpreterTest, Errors) {
  std::unique_ptr<Interpreter> Interp = createInterpreter();
  auto Err = Interp->Parse("intentional_error var1 = 42; }").takeError();
  EXPECT_EQ("Parsing failed.", llvm::toString(std::move(Err)));

  auto R2 = Interp->Parse("int var1 = 42;");
  EXPECT_TRUE(!!R2);
}

// Here we test whether the user can mix declarations and statements. The
// interpreter should be smart enough to recognize the declarations from the
// statements and wrap the latter into a declaration, producing valid code.
TEST(InterpreterTest, DeclsAndStatements) {
  std::unique_ptr<Interpreter> Interp = createInterpreter();
  auto R1OrErr = Interp->Parse(
      "int var1 = 42; extern \"C\" int printf(const char*, ...);");
  // gtest doesn't expand into explicit bool conversions.
  EXPECT_TRUE(!!R1OrErr);

  auto R1 = R1OrErr->Decls;
  EXPECT_EQ(2U, R1.size());

  // FIXME: Add support for wrapping and running statements.
  auto R2OrErr =
    Interp->Parse("var1++; printf(\"var1 value is %d\\n\", var1);");
  EXPECT_FALSE(!!R2OrErr);
  auto Err = R2OrErr.takeError();
  EXPECT_EQ("Parsing failed.", llvm::toString(std::move(Err)));
}

} // end anonymous namespace
