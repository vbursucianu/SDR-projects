#include "gtest/gtest.h"
#include "LiquidAdapter.h"
#include "SignalProcessingService.h"
#include "ILiquidAdapter.mock.h"

using namespace testing;

class SignalProcessingServiceSpecs : public ::Test {
protected:
    MockLiquidAdapter mockLiquidAdapter;
};

TEST_F(SignalProcessingServiceSpecs, SignalProcessingService_Calls_InitLiquidDSP_From_LiquidDSP) {
    LiquidAdapter liquidAdapter;
    SignalProcessingService service(&liquidAdapter);

    int flags = 102;

    service.Initialize(flags);
}

/*TEST_F(SignalProcessingServiceSpecs, SignalProcessingService_Calls_InitLiquidDSP_From_LiquidDSP_With_Mock) {
    SignalProcessingService service(&mockLiquidAdapter);

    int flags = 102;

    EXPECT_CALL(mockLiquidAdapter, InitLiquidDSP(flags))
        .Times(1);

    service.Initialize(flags);
}*/
