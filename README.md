# SDR-projects
A collections of experimental SDR projects that i've worked on. 

# Software Dependencies
- [Liquid DSP](https://github.com/jgaeddert/liquid-dsp) version 1.3.2 
- [Soapy SDR](https://github.com/pothosware/SoapySDR) version 0.7.1

# SDR Compatibility 
All the projects in this repo are using SoapySDR as an Abstraction Layer. This makes compatible with most Open-Source SDR:
- BladeRF, LimeSDR, HackRF, SDRplay, Airspy, RTL-SDR, Miri-SDR, USRP, RedPitaya, Pluto SDR

Note: Each radio has a different frequency range, maximum sample rate and number of channels. Depending on the radio, it may not be able to run all the projects in this repository. Since i do not own evey single Software Defined Radio, i cannot garantee it will run flawlessly on all of them. However, all the projects here were tested on the bladeRF-micro 2.0.

# Build instruction
Simply call `make` inside the root directory. The compiled binary can be found inside the `/bin` folder.
