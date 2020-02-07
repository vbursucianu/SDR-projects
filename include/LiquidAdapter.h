#pragma once

#include "liquid/liquid.h"
#include "ILiquidAdapter.h"

class LiquidAdapter : public ILiquidAdapter {
public:
    void InitLiquidDSP(int flag) override;
};
