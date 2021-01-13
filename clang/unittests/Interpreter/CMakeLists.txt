set(LLVM_LINK_COMPONENTS
  )

add_clang_unittest(ClangReplInterpreterTests
  InterpreterTest.cpp
  )
target_link_libraries(ClangReplInterpreterTests PUBLIC
  clangInterpreter
  clangFrontend
  )
