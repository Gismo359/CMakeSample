#define require REQUIRE

#include <catch.hpp>

#include "ExampleLib.hpp"

TEST_CASE("group1/test1", "Test something")
{
    require(Something() == 42);
}

TEST_CASE("group1/test2", "Test something")
{
    require(Something() == 24);
}