#include <benchmark/benchmark.h>

#include "ExampleLib.hpp"

static void Benchmark(benchmark::State & state) {
    int i;
    for (auto _ : state)
    {
        i = Something();
    }
    benchmark::DoNotOptimize(i);
}
BENCHMARK(Benchmark)->MinTime(10);