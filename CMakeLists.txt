cmake_minimum_required (VERSION 3.15)
cmake_policy(SET CMP0091 NEW)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

project(Everything)

add_subdirectory(ExampleLib)
add_subdirectory(Benchmark)
add_subdirectory(Test)
