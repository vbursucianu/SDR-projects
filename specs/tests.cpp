#include "gtest/gtest.h"

using namespace testing;

class unittestx : public ::Test
{

};

TEST_F(unittestx, FirstUnitTest)
{
  SUCCEED();
}