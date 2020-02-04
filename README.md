![build](https://github.com/vbursucianu/SDR-projects/workflows/build/badge.svg)
[![Dependency Status](https://david-dm.org/boennemann/badges.svg)](https://david-dm.org/boennemann/badges)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://choosealicense.com/licenses/mit/)

# SDR-projects
This repository contains a collection of C++ project for Software Defined Radios.  

# Software Dependencies
To build this project, make sure to install those dependencies:
- [Liquid DSP](https://github.com/jgaeddert/liquid-dsp) version 1.3.2
```
sudo apt-get install automake autoconf
git clone git://github.com/jgaeddert/liquid-dsp.git
cd liquid-dsp
git checkout -b v1.3.2
./bootstrap.sh
./configure     
make
sudo make install  
```

- [Soapy SDR](https://github.com/pothosware/SoapySDR) version 0.7.2
```
sudo apt-get install libboost-all-dev
git clone https://github.com/pothosware/SoapySDR.git
cd SoapySDR && git checkout -b soapy-sdr-0.7.2    
cd SoapySDR && mkdir build && cd build
cmake ..
make
sudo make install
```

# SDR Compatibility 
All the projects in this repo are using SoapySDR as an Abstraction Layer. This makes compatible with most Open-Source SDR:
- BladeRF, LimeSDR, HackRF, SDRplay, Airspy, RTL-SDR, Miri-SDR, USRP, RedPitaya, Pluto SDR

Note: Each radio has a different frequency range, maximum sample rate and number of channels. Depending on the radio, it may not be able to run all the projects in this repository. Since i do not own evey single Software Defined Radio, i cannot garantee it will run flawlessly on all of them. However, all the projects here were tested on the bladeRF-micro 2.0.

# Build instruction
Simply call `make` inside the root directory. The compiled binary can be found inside the generated `/bin` folder.
