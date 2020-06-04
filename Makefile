# Specific cxx compiler.
# Use command `make CXX=/custom/compiler` to change compiler, for example,
# `make CXX=clang++` will use environment clang++ compiler.
# Note currently gcc does not support c++20 modules, so we use clang++ instead
# here. Maybe we'll shift to g++ after full support.
CXX := clang++
PROJECT := dct

CXXFLAGS := -Wall -std=c++2a -O2 -g -fPIC -fmodules-ts
BUILD_DIR := build

# The build directory is hidden.
ifeq ($(RELEASE_BUILD_DIR),)
	RELEASE_BUILD_DIR := .$(BUILD_DIR)_release
endif
ifeq ($(DEBUG_BUILD_DIR),)
	DEBUG_BUILD_DIR := .$(BUILD_DIR)_debug
endif

# If DEBUG flag is true, the build directory is .build_debug, otherwise it
# will be .build_release (disable DEBUG option in release).
DEBUG ?= 0
ifeq ($(DEBUG), 1)
	BUILD_DIR := $(DEBUG_BUILD_DIR)
	CXXFLAGS += -DNDEBUG
else
	BUILD_DIR := $(RELEASE_BUILD_DIR)
endif

MODULE_SRC_DIR := dct
EXAMPLE_SRC_DIR := example
PCM_DIR := $(BUILD_DIR)/pcm
LIB_DIR := $(BUILD_DIR)/lib
EXAMPLE_DIR := $(BUILD_DIR)/example

# Sources in these directories are selected.
DCT_MODULE_SRCS := $(wildcard $(MODULE_SRC_DIR)/*.cppm)
DCT_PCMS := $(addprefix $(PCM_DIR)/, ${DCT_MODULE_SRCS:.cppm=.pcm})
DCT_PCM_DIRS := $(dir $(DCT_PCMS))

# Example binaries.
EXAMPLE_SRCS := $(wildcard $(EXAMPLE_SRC_DIR)/*.cpp)
EXAMPLE_EXECS := $(addprefix $(BUILD_DIR)/, ${EXAMPLE_SRCS:.cpp=})

.PHONY: all dctmodules libdct example

all: libdct example

$(PCM_DIR):
	@ mkdir -p $(DCT_PCM_DIRS);

$(LIB_DIR):
	@ mkdir -p $@

libdct: dctmodules $(LIB_DIR)

dctmodules: $(PCM_DIR) $(DCT_PCMS)

$(PCM_DIR)/%.pcm:%.cppm
	$(CXX) $< -c -o $@ $(CXXFLAGS) --precompile

example: $(EXAMPLE_DIR) $(EXAMPLE_EXECS)

$(EXAMPLE_DIR):
	@ mkdir -p $@

$(EXAMPLE_DIR)/%: $(EXAMPLE_SRC_DIR)/%.cpp
	$(CXX) $^ -o $@ $(CXXFLAGS) -fprebuilt-module-path=$(DCT_PCM_DIRS)

clean:
	@rm -rf $(BUILD_DIR)

