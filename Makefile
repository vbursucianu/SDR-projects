CXX = g++
RM = rm $1
MKDIR = mkdir -p $1

SRC_DIR := src
OBJ_DIR := obj
BUILD_DIR := bin

MAIN_BIN := main
OPEN_BIN := open
TX_BIN := tx
RX_BIN := rx
SISO_BIN := siso
MIMO_BIN := mimo

ALL_BIN := $(BUILD_DIR)/$(OPEN_BIN) $(BUILD_DIR)/$(RX_BIN) $(BUILD_DIR)/$(TX_BIN) $(BUILD_DIR)/$(SISO_BIN) $(BUILD_DIR)/$(MIMO_BIN)

CXXFLAGS := -g -I$(SRC_DIR)
LDFLAGS := -lpthread -lliquid -lboost_thread -lSoapySDR

MAIN_SRC = src/main.cpp
OPEN_SRC = src/open.cpp
RX_SRC = src/rx.cpp
TX_SRC = src/tx.cpp
SISO_SRC = src/siso.cpp
MIMO_SRC = src/mimo.cpp

MAIN_OBJ = $(patsubst %.cpp,%.o,$(MAIN_SRC:$(SRC_DIR)/%=$(OBJ_DIR)/%))
OPEN_OBJ = $(patsubst %.cpp,%.o,$(OPEN_SRC:$(SRC_DIR)/%=$(OBJ_DIR)/%))
RX_OBJ = $(patsubst %.cpp,%.o,$(RX_SRC:$(SRC_DIR)/%=$(OBJ_DIR)/%))
TX_OBJ = $(patsubst %.cpp,%.o,$(TX_SRC:$(SRC_DIR)/%=$(OBJ_DIR)/%))
SISO_OBJ = $(patsubst %.cpp,%.o,$(SISO_SRC:$(SRC_DIR)/%=$(OBJ_DIR)/%))
MIMO_OBJ = $(patsubst %.cpp,%.o,$(MIMO_SRC:$(SRC_DIR)/%=$(OBJ_DIR)/%))

ALL_OBJ := $(OPEN_OBJ) $(RX_OBJ) $(TX_OBJ) $(SISO_OBJ) $(MIMO_OBJ)

OBJDIRS := $(sort $(dir $(ALL_OBJ)))

default: all

#help: $(info ************  HELP  ************)

all: build_dirs build_open build_rx build_tx build_siso build_mimo

open: build_dirs build_open
rx: build_dirs build_rx
tx: build_dirs build_tx
siso: build_dirs build_siso
mimo: build_dirs build_mimo

build_open: $(OPEN_OBJ)
	$(CXX) -o $(BUILD_DIR)/$(OPEN_BIN) $^ $(LDFLAGS)

build_rx: $(RX_OBJ)
	$(CXX) -o $(BUILD_DIR)/$(RX_BIN) $^ $(LDFLAGS)

build_tx: $(TX_OBJ)
	$(CXX) -o $(BUILD_DIR)/$(TX_BIN) $^ $(LDFLAGS)

build_siso: $(SISO_OBJ)
	$(CXX) -o $(BUILD_DIR)/$(SISO_BIN) $^ $(LDFLAGS)

build_mimo: $(MIMO_OBJ)
	$(CXX) -o $(BUILD_DIR)/$(MIMO_BIN) $^ $(LDFLAGS)

build_dirs: $(OBJDIRS)
	$(call MKDIR, $(BUILD_DIR))

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -o $@ -c $<

$(OBJDIRS):
	$(call MKDIR, $(@D))

.PHONY: clean
clean:
	$(call RM, $(ALL_BIN) $(ALL_OBJ))
