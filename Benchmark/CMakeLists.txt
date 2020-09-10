cmake_minimum_required(VERSION 3.15)
cmake_policy(SET CMP0091 NEW)

project(Benchmark)

include(settings)

make_executable(Benchmark)

find_package(benchmark CONFIG REQUIRED)
target_link_libraries(Benchmark ExampleLib benchmark::benchmark benchmark::benchmark_main)