#include <complex>
#include <liquid/liquid.h>

#include <SoapySDR/Device.hpp>
#include <SoapySDR/Types.hpp>
#include <SoapySDR/Formats.hpp>
#include <SoapySDR/Errors.hpp>

#include <cstring>
#include <string>
#include <vector>
#include <map>

#include <iostream>

using namespace std;

int main(int argc, char* argv[])
{
  SoapySDR::KwargsList results = SoapySDR::Device::enumerate();
  SoapySDR::Kwargs args = results[0];
  SoapySDR::Device* sdr = SoapySDR::Device::make(args);

  if (sdr == nullptr) {
    cerr << "SoapySDR::Device::make failed" << endl;
    return EXIT_FAILURE;
  }

  auto freqs = sdr->getFrequencyRange(SOAPY_SDR_TX, 0);
  cout << "Frequency range:" << endl;
  for (auto freq : freqs) {
    cout << "  " << freq.minimum()/1e6 << " MHz to " << freq.maximum()/1e6 << " MHz, step " << freq.step()/1e6 << " MHz" << endl;
  }

  auto srs = sdr->getSampleRateRange(SOAPY_SDR_TX, 0);
  cout << "Sample rate range:" << endl;
  for (auto sr : srs) {
    cout << "  " << sr.minimum()/1e6 << " MHz to " << sr.maximum()/1e6 << " MHz, step " << sr.step()/1e6 << " MHz" << endl;
  }

  auto bws = sdr->getBandwidthRange(SOAPY_SDR_TX, 0);
  cout << "Bandwidth range:" << endl;
  for (auto bw : bws) {
    cout << "  " << bw.minimum()/1e6 << " MHz to " << bw.maximum()/1e6 << " MHz, step " << bw.step()/1e6 << " MHz" << endl;
  }

  auto gain = sdr->getGainRange(SOAPY_SDR_TX, 0);
  cout << "Gain range:" << endl;
  cout << "  " << gain.minimum() << " dB to " << gain.maximum() << " dB, step " << gain.step() << " dB" << endl;

  SoapySDR::Device::unmake(sdr);

  return EXIT_SUCCESS;
}
