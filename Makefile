CXX = g++
RM = rm $1
MKDIR = mkdir -p $1

OBJ_DIR := obj
BUILD_DIR := bin
SRC_DIR := src

TEST_DIR := $(SRC_DIR)/test
TX_DIR := $(SRC_DIR)/tx
RX_DIR := $(SRC_DIR)/rx
SISO_DIR := $(SRC_DIR)/siso
MIMO_DIR := $(SRC_DIR)/mimo

OPEN_BIN := open
TX_BIN := tx
RX_BIN := rx
SISO_BIN := siso
MIMO_BIN := mimo

ALL_BIN := $(BUILD_DIR)/$(OPEN_BIN) $(BUILD_DIR)/$(RX_BIN) $(BUILD_DIR)/$(TX_BIN) $(BUILD_DIR)/$(SISO_BIN) $(BUILD_DIR)/$(MIMO_BIN)

CXXFLAGS := -g -I$(SRC_DIR)
LDFLAGS := -lpthread -lliquid -lboost_thread -lSoapySDR

OPEN_SRC = $(TEST_DIR)/open.cpp
RX_SRC = $(RX_DIR)/rx.cpp
TX_SRC = $(TX_DIR)/tx.cpp
SISO_SRC = $(SISO_DIR)/siso.cpp
MIMO_SRC = $(MIMO_DIR)/mimo.cpp

OPEN_OBJ = $(patsubst %.cpp,%.o,$(OPEN_SRC:$(SRC_DIR)/test/%=$(OBJ_DIR)/test/%))
RX_OBJ = $(patsubst %.cpp,%.o,$(RX_SRC:$(SRC_DIR)/rx/%=$(OBJ_DIR)/rx/%))
TX_OBJ = $(patsubst %.cpp,%.o,$(TX_SRC:$(SRC_DIR)/tx/%=$(OBJ_DIR)/tx/%))
SISO_OBJ = $(patsubst %.cpp,%.o,$(SISO_SRC:$(SRC_DIR)/siso/%=$(OBJ_DIR)/siso/%))
MIMO_OBJ = $(patsubst %.cpp,%.o,$(MIMO_SRC:$(SRC_DIR)/mimo/%=$(OBJ_DIR)/mimo/%))

ALL_OBJ := $(OPEN_OBJ) $(RX_OBJ) $(TX_OBJ) $(SISO_OBJ) $(MIMO_OBJ)

OBJDIRS := $(sort $(dir $(ALL_OBJ)))

default: all

help: $(info $(CXX) $(CXXFLAGS) -o $(OPEN_OBJ) -c $(OPEN_SRC))
	$(info $(CXX) $(CXXFLAGS) -o $(OPEN_OBJ) -c $(OPEN_SRC))
all: build_dirs build_open build_rx build_tx build_siso build_mimo

open: build_dirs build_open
rx: build_dirs build_rx
tx: build_dirs build_tx
siso: build_dirs build_siso
mimo: build_dirs build_mimo

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
	$(call RM, $(ALL_BIN) $(ALL_OBJ))
