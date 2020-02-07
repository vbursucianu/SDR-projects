#include "SignalProcessingService.h"

SignalProcessingService::SignalProcessingService(ILiquidAdapter* liquidAdapter)
: m_liquidAdapter(liquidAdapter) {
}

SignalProcessingService::~SignalProcessingService(){
}

void SignalProcessingService::Initialize(int flags){
    m_liquidAdapter->InitLiquidDSP(flags);
}