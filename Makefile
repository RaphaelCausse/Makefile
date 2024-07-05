#==============================================================================
# Makefile template for small/medium sized C projects.
# Follow recommended project layout in README.
# 
# Author: Raphael CAUSSE
#==============================================================================

### Version
MK_VERSION_MAJOR := 2
MK_VERSION_MINOR := 0

### Environment
ENV_SYST := $(shell uname -s)
ENV_ARCH := $(shell uname -p)


#==============================================================================
# COMPILER AND LINKER
#==============================================================================

### C Compiler
CC := gcc

### C standard
CSTD := -std=c99

### Extra flags to give to the C compiler
CFLAGS := $(CSTD) -Wall -Werror -pedantic

### Extra flags to give to the C preprocessor
CPPFLAGS := 

### Extra flags to give to compiler when it invokes the linker
LDFLAGS := 

### Library names given to compiler when it invokes the linker
LDLIBS := 

### Build
BUILD_MODE ?= debug

### Debug mode
DEBUG_FLAGS := -O0 -g3

### Release mode
RELEASE_FLAGS := -02 -g0


#==============================================================================
# DIRECTORIES AND FILES
#==============================================================================

### Predefined directories
DIR_BIN   := bin
DIR_BUILD := build
DIR_SRC   := src

### Build configuration file
CONFIG_FILE := MakefileList.mk
-include $(CONFIG_FILE)

### Source files
SOURCE_FILES := $(addprefix $(DIR_SRC)/,$(filter-out \,$(SOURCES)))

### Object files 
OBJECT_FILES = $(addprefix $(DIR_BUILD)/,$(addsuffix .o,$(basename $(filter-out \,$(SOURCE_FILES)))))


#==============================================================================
# SHELL
#==============================================================================

### Shell
OLD_SHELL := $(SHELL)
SHELL     := /bin/bash

### Commands
MKDIR := mkdir -p
RM    := rm -rf
CP    := cp -rf
MV    := mv


#==============================================================================
# DEFINES
#==============================================================================

#-------------------------------------------------
# Create the configuration file
#-------------------------------------------------
define CREATE_CONFIG_FILE
	touch $1; \
	echo "# Define project name" >> $1; \
	echo "PROJECT_NAME := " >> $1; \
	echo >> $1; \
	echo "# Define executable name" >> $1; \
	echo "EXECUTABLE_NAME := " >> $1; \
	echo >> $1; \
	echo "# Define source files from directory '$(DIR_SRC)' to compile" >> $1; \
	echo "SOURCE_FILES := " >> $1; \
	echo >> $1;
endef


#==============================================================================
# RULES
#==============================================================================

#-------------------------------------------------
# Initialize project
#-------------------------------------------------
.PHONY: init
init:
	@echo ">-------- Initialize project --------<"

	@if [ ! -d "$(DIR_SRC)" ]; then \
		echo "[1/2] Creating directory '$(DIR_SRC)'"; \
		$(MKDIR) $(DIR_SRC); \
	else \
		echo "[1/2] Directory '$(DIR_SRC)' already exists"; \
	fi

	@if [ ! -f "$(CONFIG_FILE)" ]; then \
		echo "[2/2] Creating config file '$(CONFIG_FILE)'"; \
		$(call CREATE_CONFIG_FILE,$(CONFIG_FILE)) \
	else \
		echo "[2/2] File '$(CONFIG_FILE)' already exists"; \
	fi

	@echo


#-------------------------------------------------
# Pre build operations
#-------------------------------------------------
.PHONY: prebuild
prebuild:
# @if [ -z "$(PROJECT_NAME)" ]; then \
#     $(error PROJECT_NAME is required in '$(CONFIG_FILE)'); \
# else \
#     $(info PROJECT_NAME := $(PROJECT_NAME)); \
# fi

# @if [ -z "$(EXECUTABLE_NAME)" ]; then \
#     $(error EXECUTABLE_NAME is required in '$(CONFIG_FILE)'); \
# else \
#     $(info EXECUTABLE_NAME := $(EXECUTABLE_NAME)); \
# fi

# @if [ -z "$(SOURCE_FILES)" ]; then \
#     $(error SOURCE_FILES is required in '$(CONFIG_FILE)'); \
# else \
#     $(info SOURCE_FILES := $(SOURCE_FILES)); \
	fi

	@echo ">-------- Build Project: $(PROJECT_NAME), Configuration: $(BUILD_MODE) --------<"

	@echo $(SOURCE_FILES)
	@echo $(OBJECT_FILES)

#-------------------------------------------------
# Build operations
#-------------------------------------------------
.PHONY: build
build: prebuild 



#-------------------------------------------------
# Post build operations
#-------------------------------------------------
.PHONY: postbuild
postbuild:



#-------------------------------------------------
# Clean project
#-------------------------------------------------
.PHONY: clean
clean:
	@echo ">-------- Clean --------<"

	@echo "[1/2] Deleting directory '$(DIR_BIN)'"
	@$(RM) $(DIR_BIN)

	@echo "[2/2] Deleting directory '$(DIR_BUILD)'"
	@$(RM) $(DIR_BUILD)

	@echo


#-------------------------------------------------
# Version information
#-------------------------------------------------
.PHONY: version
version:
	@echo Makefile v$(MK_VERSION_MAJOR).$(MK_VERSION_MINOR) for $(ENV_SYST)-$(ENV_ARCH)
	@echo
