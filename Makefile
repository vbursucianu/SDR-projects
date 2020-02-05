# SYNOPSIS:
#
#   make [all]  - makes everything.
#   make TARGET - makes the given target.
#   make test  	- makes everything and runs the built sample test.
#   make clean  - removes all files generated by make.

CXX = g++
RM = rm $1
MKDIR = mkdir -p $1

# Object File Directory
OBJ_DIR := obj
# Build Files Directory - Where binary files can be found
BUILD_DIR := bin
# Source File Directory
SRC_DIR := src
# Unit Testing Output Files Directory
SPECS_DIR := specs

# Project Files Directories
TEST_DIR := $(SRC_DIR)/test
TX_DIR := $(SRC_DIR)/tx
RX_DIR := $(SRC_DIR)/rx
SISO_DIR := $(SRC_DIR)/siso
MIMO_DIR := $(SRC_DIR)/mimo

# Project binaries name
OPEN_BIN := open.bin
TX_BIN := tx.bin
RX_BIN := rx.bin
SISO_BIN := siso.bin
MIMO_BIN := mimo.bin

# Unit Test output binary name
SPECS_BIN := specs.bin

ALL_PROJECT_BIN := $(BUILD_DIR)/$(OPEN_BIN) $(BUILD_DIR)/$(RX_BIN) $(BUILD_DIR)/$(TX_BIN) $(BUILD_DIR)/$(SISO_BIN) $(BUILD_DIR)/$(MIMO_BIN)

# Compilation Flags
SPECSFLAGS := --coverage
CXXFLAGS := -g -I$(SRC_DIR)
CPPFLAGS := -g
LDUFLAGS := -lpthread
LDFLAGS := -lpthread -lliquid -lboost_thread -lSoapySDR

# Project Source files
OPEN_SRC = $(TEST_DIR)/open.cpp
RX_SRC = $(RX_DIR)/rx.cpp
TX_SRC = $(TX_DIR)/tx.cpp
SISO_SRC = $(SISO_DIR)/siso.cpp
MIMO_SRC = $(MIMO_DIR)/mimo.cpp

# Unit Testing Source files
SPECS_SRC = $(SPECS_DIR)/main.cpp
TESTS_SRC = $(SPECS_DIR)/tests.cpp
GTEST_LIB = /usr/local/lib/libgtest.a

# Project Objects 
OPEN_OBJ = $(patsubst %.cpp,%.o,$(OPEN_SRC:$(SRC_DIR)/test/%=$(OBJ_DIR)/test/%))
RX_OBJ = $(patsubst %.cpp,%.o,$(RX_SRC:$(SRC_DIR)/rx/%=$(OBJ_DIR)/rx/%))
TX_OBJ = $(patsubst %.cpp,%.o,$(TX_SRC:$(SRC_DIR)/tx/%=$(OBJ_DIR)/tx/%))
SISO_OBJ = $(patsubst %.cpp,%.o,$(SISO_SRC:$(SRC_DIR)/siso/%=$(OBJ_DIR)/siso/%))
MIMO_OBJ = $(patsubst %.cpp,%.o,$(MIMO_SRC:$(SRC_DIR)/mimo/%=$(OBJ_DIR)/mimo/%))

# Unit Testing Objects 
SPECS_OBJ = $(SPECS_DIR)/main.o
TESTS_OBJ = $(SPECS_DIR)/tests.o

ALL_PROJECT_OBJ := $(OPEN_OBJ) $(RX_OBJ) $(TX_OBJ) $(SISO_OBJ) $(MIMO_OBJ) $(SPECS_OBJ) $(TESTS_OBJ)
OBJDIRS := $(sort $(dir $(ALL_PROJECT_OBJ)))

default: all

all: build_dirs build_open build_rx build_tx build_siso build_mimo

open: build_dirs build_open
rx: build_dirs build_rx
tx: build_dirs build_tx
siso: build_dirs build_siso
mimo: build_dirs build_mimo
test: build_specs
help: $(info Sorry no help)

# g++ -o main.o -c main.cpp --coverage
# g++ -o tests.o -c tests.cpp --coverage
# g++ -o main main.o tests.o /usr/local/lib/libgtest.a -lpthread --coverage
# gcov main.cpp
# lcov -c --directory . --output-file lcov.info
build_specs:
	$(CXX) $(CPPFLAGS) -o $(SPECS_OBJ) -c $(SPECS_SRC) $(SPECSFLAGS)
	$(CXX) $(CPPFLAGS) -o $(TESTS_OBJ) -c $(TESTS_SRC) $(SPECSFLAGS)
	$(CXX) -o $(SPECS_DIR)/$(SPECS_BIN) $(SPECS_OBJ) $(GTEST_LIB) $(LDUFLAGS) $(SPECSFLAGS)
	specs/$(SPECS_BIN)
	gcov $(SPECS_SRC)
	mkdir -p specs/coverage
	lcov -c --directory specs/ --output-file specs/coverage/lcov.info

build_open:
	$(CXX) $(CXXFLAGS) -o $(OPEN_OBJ) -c $(OPEN_SRC)
	$(CXX) -o $(BUILD_DIR)/$(OPEN_BIN) $(OPEN_OBJ) $(LDFLAGS)

build_rx: 
	$(CXX) $(CXXFLAGS) -o $(RX_OBJ) -c $(RX_SRC)
	$(CXX) -o $(BUILD_DIR)/$(RX_BIN) $(RX_OBJ) $(LDFLAGS)

build_tx: 
	$(CXX) $(CXXFLAGS) -o $(TX_OBJ) -c $(TX_SRC)
	$(CXX) -o $(BUILD_DIR)/$(TX_BIN) $(TX_OBJ) $(LDFLAGS)

build_siso: 
	$(CXX) $(CXXFLAGS) -o $(SISO_OBJ) -c $(SISO_SRC)
	$(CXX) -o $(BUILD_DIR)/$(SISO_BIN) $(SISO_OBJ) $(LDFLAGS)

build_mimo: 
	$(CXX) $(CXXFLAGS) -o $(MIMO_OBJ) -c $(MIMO_SRC)
	$(CXX) -o $(BUILD_DIR)/$(MIMO_BIN) $(MIMO_OBJ) $(LDFLAGS)

build_dirs: $(OBJDIRS)
	$(call MKDIR, $(BUILD_DIR))

$(OBJ_DIR)/%/%.o: $(SRC_DIR)/%/%.cpp
	$(CXX) $(CXXFLAGS) -o $@ -c $<

$(OBJDIRS):	
	$(call MKDIR, $(@D))

.PHONY: clean
clean:
	$(call RM, $(ALL_PROJECT_BIN) $(ALL_OBJ))
	rm specs/*.gcno specs/*.o specs/$(SPECS_BIN) 
	rm -r specs/coverage
