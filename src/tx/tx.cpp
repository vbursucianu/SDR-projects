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
  int written = -1;  //Write Status to SDR

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

  sdr->setAntenna(SOAPY_SDR_TX, 0, "BAND1");
	sdr->setGain(SOAPY_SDR_TX, 0, 60.0);
	sdr->setSampleRate(SOAPY_SDR_TX, 0, 1e6);
	sdr->setBandwidth(SOAPY_SDR_TX, 0, 5e6);
	sdr->setFrequency(SOAPY_SDR_TX, 0, "RF", 32e6);
	sdr->setFrequency(SOAPY_SDR_TX, 0, "BB", -(32e6 - 27.145e6));

	SoapySDR::Stream* txStream = sdr->setupStream(SOAPY_SDR_TX, SOAPY_SDR_CF32);

	if (txStream == nullptr) {
		cerr << "Failed to setup stream" << endl;
		SoapySDR::Device::unmake(sdr);
		return EXIT_FAILURE;
	}

	sdr->activateStream(txStream, 0, 0, 0);
	sdr->setGain(SOAPY_SDR_TX, 0, 60.0);

  // Do some DSP here //

  // Transmit Buffer
	//written = sdr->writeStream(txStream, buffs, 4000, flags);
	//if (written <= 0) {
	//	cerr << SoapySDR::errToStr(written) << endl;
	//}

	sdr->deactivateStream(txStream);
	sdr->closeStream(txStream);

  SoapySDR::Device::unmake(sdr);

  return EXIT_SUCCESS;
}
