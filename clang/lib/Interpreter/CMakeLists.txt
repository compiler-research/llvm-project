set(LLVM_LINK_COMPONENTS
   native
   Target
   core
  )

add_clang_library(clangInterpreter
  IncrementalParser.cpp
  Interpreter.cpp

  LINK_LIBS
  clangAST
  clangAnalysis
  clangBasic
  clangEdit
  clangLex
  clangSema
  clangCodeGen
  clangFrontendTool
  )
