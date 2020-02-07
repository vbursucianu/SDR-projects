#pragma once
#include "ILiquidAdapter.h"
#include "gmock/gmock.h"

class MockLiquidAdapter : public ILiquidAdapter {
public:
    MOCK_METHOD(void, InitLiquidDSP, (int), (override));
};