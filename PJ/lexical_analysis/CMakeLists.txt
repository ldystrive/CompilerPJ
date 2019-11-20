include_directories(include)
include_directories(../syntax_analysis/include)
set(FlexOutput ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)
# set(LEX_EXECUTABLE ${CMAKE_SOURCE_DIR}/bin)

add_custom_command(
    OUTPUT ${FlexOutput}
    COMMAND ${FLEX_EXECUTABLE}
            --outfile=${FlexOutput}
            ${CMAKE_CURRENT_SOURCE_DIR}/src/lexer.l
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/src/lexer.l
    COMMENT "Generating lexer.c"
)

add_custom_target(
  flexSrc
  DEPENDS ${FlexOutput}
)

message(${FlexOutput})

add_library(lexAnalyzerLib STATIC
    ${CMAKE_CURRENT_SOURCE_DIR}/src/lexAnalyzer.cpp
    ${FlexOutput}
)


add_dependencies(lexAnalyzerLib flexSrc)
