/* 
* MIT License
*
* Copyright (c) 2020 Victor Bursucianu
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE. 
*/

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

#include <getopt.h>

#include "SignalProcessingService.h"
#include "LiquidAdapter.h"

#define CENTER_FREQUENCY  915e6
#define BANDWIDTH         5e6
#define SAMPLE_RATE       1e6
#define TX_GAIN           60.0
#define TX_CHANNEL_1      "BAND1"

using namespace std;

// print usage/help message
void usage()
{
    cout << "modem_example [options]" << endl;
    cout << "  h     : print help" << endl;
    cout << "  v/q   : verbose/quiet" << endl;
    cout << "  m     : modulation scheme (qam16 default)" << endl;
    liquid_print_modulation_schemes();
}

int main(int argc, char* argv[])
{
  // create liquid dsp adapter
  LiquidAdapter liquidAdapter;
  SignalProcessingService service(&liquidAdapter);
  service.Initialize(102);

  // create mod/demod objects
  modulation_scheme ms = LIQUID_MODEM_QAM16;

  // get user parameters
  int dopt;
  int verbose = 1;
  while ((dopt = getopt(argc,argv,"hvqm:")) != EOF) {
    switch (dopt) {
      case 'h':   usage();        return 0;
      case 'v':   verbose = 1;    break;
      case 'q':   verbose = 0;    break;
      case 'm':
          ms = liquid_getopt_str2mod(optarg); // Get Modulation Scheme
          if (ms == LIQUID_MODEM_UNKNOWN) {
              fprintf(stderr,"error: %s, unknown/unsupported modulation scheme '%s'\n", argv[0], optarg);
              return 1;
          }
          break;
      default:
        exit(1);
    }
  }

  // create the modem objects
  modem mod   = modem_create(ms);
  modem_print(mod);

  // ensure bits/symbol matches modem description (only
  // applicable to certain specific modems)
  unsigned int bps = modem_get_bps(mod);
  unsigned int i; // modulated symbol
  unsigned int num_symbols = 1<<bps;
  liquid_float_complex iq;
  cout << "Sizeof(liquid_float_complex) = " << sizeof(liquid_float_complex) << endl;

  // Modulate IQ Symbols
  void * txbuff[1];
  liquid_float_complex * buffer;
  buffer = new liquid_float_complex [num_symbols];
  for (i=0; i< num_symbols; i++) {
    modem_modulate(mod, i, &iq);
    buffer[i] = iq;
    cout << i << ":" << buffer[i] << endl;
  }
  txbuff[0] = buffer;

  // Destroy the modem objects
  modem_destroy(mod);

  // Create transmit buffer
  void* buffs[1];

  // SoapySDR magic
  SoapySDR::KwargsList results = SoapySDR::Device::enumerate();
  SoapySDR::Kwargs args = results[0];
  SoapySDR::Device* sdr = SoapySDR::Device::make(args);
  if (sdr == nullptr) {
    cerr << "SoapySDR::Device::make failed" << endl;
    return EXIT_FAILURE;
  }
  // Get frequency range
  auto freqs = sdr->getFrequencyRange(SOAPY_SDR_TX, 0);
  cout << "Frequency range:" << endl;
  for (auto freq : freqs) {
    cout << "  " << freq.minimum()/1e6 << " MHz to " << freq.maximum()/1e6 << " MHz, step " << freq.step()/1e6 << " MHz" << endl;
  }
  // Get sample rate range
  auto srs = sdr->getSampleRateRange(SOAPY_SDR_TX, 0);
  cout << "Sample rate range:" << endl;
  for (auto sr : srs) {
    cout << "  " << sr.minimum()/1e6 << " MHz to " << sr.maximum()/1e6 << " MHz, step " << sr.step()/1e6 << " MHz" << endl;
  }
  // Get bandwidth range
  auto bws = sdr->getBandwidthRange(SOAPY_SDR_TX, 0);
  cout << "Bandwidth range:" << endl;
  for (auto bw : bws) {
    cout << "  " << bw.minimum()/1e6 << " MHz to " << bw.maximum()/1e6 << " MHz, step " << bw.step()/1e6 << " MHz" << endl;
  }
  // Get TX gain range
  auto gain = sdr->getGainRange(SOAPY_SDR_TX, 0);
  cout << "Gain range:" << endl;
  cout << "  " << gain.minimum() << " dB to " << gain.maximum() << " dB, step " << gain.step() << " dB" << endl;

  // Set SDR Parameters before transmission
  sdr->setAntenna(SOAPY_SDR_TX, 0, TX_CHANNEL_1);
	sdr->setGain(SOAPY_SDR_TX, 0, TX_GAIN);
	sdr->setSampleRate(SOAPY_SDR_TX, 0, SAMPLE_RATE);
	sdr->setBandwidth(SOAPY_SDR_TX, 0, BANDWIDTH);
	sdr->setFrequency(SOAPY_SDR_TX, 0, "RF", CENTER_FREQUENCY);

  // Setup IQ Stream for TX
	SoapySDR::Stream* txStream = sdr->setupStream(SOAPY_SDR_TX, SOAPY_SDR_CF32);
	if (txStream == nullptr) {
		cerr << "Failed to setup stream" << endl;
		SoapySDR::Device::unmake(sdr);
		return EXIT_FAILURE;
	}

  // Activate IQ Stream for TX
	sdr->activateStream(txStream, 0, 0, 0);

  //Transmit Symbols
  for (i=0; i< num_symbols; i++) {
    int written = -1;
    
    while (written < 0) {
      int flags = 0;
      written = sdr->writeStream(txStream, txbuff, num_symbols, flags);
      if (written <= 0) {
        cerr << SoapySDR::errToStr(written) << endl;
      }
      if (flags != 0) {
        cerr << flags << endl;
      }
    }
  }

	sdr->deactivateStream(txStream);
	sdr->closeStream(txStream);

  SoapySDR::Device::unmake(sdr);

  return EXIT_SUCCESS;
}