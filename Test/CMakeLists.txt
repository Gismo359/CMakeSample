cmake_minimum_required(VERSION 3.15)
cmake_policy(SET CMP0091 NEW)

project(Test)

include(settings)

make_executable(Test)

find_package(Catch2 CONFIG REQUIRED)
target_link_libraries(Test ExampleLib Catch2::Catch2)
