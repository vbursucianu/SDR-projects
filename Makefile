CXX = g++
RM = rm $1
MKDIR = mkdir -p $1

SRC_DIR := src
OBJ_DIR := obj
BUILD_DIR := bin

DSP_BIN := dsp

CXXFLAGS := -g -I$(SRC_DIR)
LDFLAGS := -lpthread -lliquid -lboost_thread -lSoapySDR

DSP_MAIN_SRC = src/main.cpp
DSP_SRC = $(wildcard src/JD/*.cpp)

DSP_MAIN_OBJ = $(patsubst %.cpp,%.o,$(DSP_MAIN_SRC:$(SRC_DIR)/%=$(OBJ_DIR)/%))
DSP_OBJ = $(patsubst %.cpp,%.o,$(DSP_SRC:$(SRC_DIR)/%=$(OBJ_DIR)/%))

OBJDIRS := $(sort $(dir $(DSP_MAIN_OBJ) $(DSP_OBJ)))

default: dsp

dsp: build_dirs build_dsp

build_dsp: $(DSP_MAIN_OBJ) $(DSP_OBJ)
	$(CXX) -o $(BUILD_DIR)/$(DSP_BIN) $^ $(LDFLAGS)

build_dirs: $(OBJDIRS)
	$(call MKDIR, $(BUILD_DIR))

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -o $@ -c $<

$(OBJDIRS):
	$(call MKDIR, $(@D))

.PHONY: clean
clean:
	$(call RM, $(BUILD_DIR)/$(DSP_BIN) $(DSP_MAIN_OBJ) $(DSP_OBJ))

