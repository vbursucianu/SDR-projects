#include "LiquidAdapter.h"
#include <iostream>
#include <unistd.h>

void LiquidAdapter::InitLiquidDSP(int flags){
    liquid_is_prime(13);
    std::cout << "Calling LiquidDSP..." << std::endl;
    usleep(3e6);
}