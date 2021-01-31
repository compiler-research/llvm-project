set( LLVM_LINK_COMPONENTS
#  ${LLVM_TARGETS_TO_BUILD}
#  Option
  Support
  )

add_clang_tool(clang-repl
  ClangRepl.cpp
  )

target_link_libraries(clang-repl PUBLIC
  clangInterpreter
  clangTooling
  LLVMLineEditor
  )

install(TARGETS clang-repl
  RUNTIME DESTINATION bin)
