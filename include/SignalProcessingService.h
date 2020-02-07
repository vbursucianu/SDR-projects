#pragma once

#include "ILiquidAdapter.h"

class SignalProcessingService {
public:
    SignalProcessingService(ILiquidAdapter* liquidAdapter);
    ~SignalProcessingService();

    void Initialize(int flags);

protected:
    ILiquidAdapter* m_liquidAdapter;

private:
    SignalProcessingService();
};