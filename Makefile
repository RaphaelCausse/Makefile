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
CFLAGS := $(CSTD) -Wall -Werror -Wextra

### Extra flags to give to the C preprocessor (e.g. -I)
CPPFLAGS := 

### Extra flags to give to compiler when it invokes the linker (e.g. -L)
LDFLAGS := 

### Library names given to compiler when it invokes the linker (e.g. -l)
LDLIBS := 

### Build mode dependant flags
DEBUG_FLAGS   := -O0 -g3
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

### Include configuration file
ifeq ($(filter $(CONFIG_FILE),$(wildcard *.mk)),$(CONFIG_FILE))
    include $(CONFIG_FILE)
endif

### Target executable
TARGET_EXE := $(DIR_BIN)/$(EXECUTABLE_NAME)

### Source files
SOURCE_FILES := $(addprefix $(DIR_SRC)/,$(filter-out \,$(SOURCES)))

### Object files 
OBJECT_FILES := $(addprefix $(DIR_BUILD)/,$(addsuffix .o,$(basename $(filter-out \,$(SOURCES)))))



#==============================================================================
# SHELL
#==============================================================================

### Commands
MKDIR := mkdir -p
RM    := rm -rf
CP    := cp -rf
MV    := mv


#==============================================================================
# DEFINES
#==============================================================================

#-------------------------------------------------
# Create the configuration file and its content
#-------------------------------------------------
define CREATE_CONFIG_FILE
	touch $1; \
	echo "# Define project name" >> $1; \
	echo "PROJECT_NAME := " >> $1; \
	echo >> $1; \
	echo "# Define executable name" >> $1; \
	echo "EXECUTABLE_NAME := " >> $1; \
	echo >> $1; \
	echo "# Define build mode (debug or release)" >> $1; \
	echo "BUILD_MODE := " >> $1; \
	echo >> $1; \
	echo "# Define source files from '$(DIR_SRC)/' directory to compile" >> $1; \
	echo "SOURCES := " >> $1; \
	echo >> $1;
endef


#==============================================================================
# RULES
#==============================================================================

all: build

#-------------------------------------------------
# Initialize project
#-------------------------------------------------
.PHONY: init
init:
	@echo ">-------- Initialize project --------<"

	@if [ ! -d "$(DIR_SRC)" ]; then \
		echo "[1/2] Creating directory $(DIR_SRC)/"; \
		$(MKDIR) $(DIR_SRC); \
	else \
		echo "[1/2] Directory $(DIR_SRC)/ already exists"; \
	fi

	@if [ ! -f "$(CONFIG_FILE)" ]; then \
		echo "[2/2] Creating config file $(CONFIG_FILE)"; \
		$(call CREATE_CONFIG_FILE,$(CONFIG_FILE)) \
	else \
		echo "[2/2] File $(CONFIG_FILE) already exists"; \
	fi

	@echo


#-------------------------------------------------
# (Internal rule) Check directories
#-------------------------------------------------
.PHONY: __checkdirs
__checkdirs:
	@if [ ! -d "$(DIR_BUILD)" ]; then \
		$(MKDIR) $(DIR_BUILD); \
	fi
	@if [ ! -d "$(DIR_BIN)" ]; then \
		$(MKDIR) $(DIR_BIN); \
	fi


#-------------------------------------------------
# (Internal rule) Pre build operations
#-------------------------------------------------
.PHONY: __prebuild
__prebuild: __checkdirs
    ifeq ($(filter $(CONFIG_FILE),$(wildcard *.mk)),)
	    $(error Configuration file $(CONFIG_FILE) not detected. Run 'make init' to create it)
    endif

    ifeq ($(PROJECT_NAME),)
	    $(error $(CONFIG_FILE): PROJECT_NAME is required. Must provide a project name)
    endif

    ifeq ($(EXECUTABLE_NAME),)
	    $(error $(CONFIG_FILE): EXECUTABLE_NAME is required. Must provide an executable name)
    endif

    ifeq ($(filter $(BUILD_MODE),debug release),)
	    $(error $(CONFIG_FILE): BUILD_MODE is invalid. Must provide a valid mode (debug or release))
    endif

    ifeq ($(SOURCES),)
	    $(error $(CONFIG_FILE): SOURCES is required. Must provide source files)
    endif

	@echo ">-------- Build Project: $(PROJECT_NAME) ($(BUILD_MODE)) --------<"

    ifeq ($(BUILD_MODE),debug)
	    $(eval CFLAGS += $(DEBUG_FLAGS))
    else ifeq ($(BUILD_MODE),release)
	    $(eval CFLAGS += $(RELEASE_FLAGS))
    endif


#-------------------------------------------------
# Build operations
#-------------------------------------------------
.PHONY: build
build: __prebuild $(TARGET_EXE)
	@echo

#-------------------------------------------------
# Link object files into target executable
#-------------------------------------------------
$(TARGET_EXE): $(OBJECT_FILES)
	@echo "[2/2] Linking executable $@"
	@$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)


#-------------------------------------------------
# Compile C source files
#-------------------------------------------------
$(DIR_BUILD)/%.o: $(DIR_SRC)/%.c
	@echo "[1/2] Compiling $^"
	@$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@ 


#-------------------------------------------------
# Run executable
#-------------------------------------------------
.PHONY: run
run: $(TARGET_EXE)
	@./$(TARGET_EXE)


#-------------------------------------------------
# Clean project (simple) 
#-------------------------------------------------
.PHONY: clean
clean:
	@echo ">-------- Clean project --------<"
	@echo "[1/2] Deleting executable $(TARGET_EXE)"
	@$(RM) $(TARGET_EXE)
	@echo "[2/2] Deleting objects $(OBJECT_FILES)"
	@$(RM) $(OBJECT_FILES)
	@echo


#-------------------------------------------------
# Clean project (light) 
#-------------------------------------------------
.PHONY: cleanall
cleanall:
	@echo ">-------- Clean project --------<"
	@echo "[1/2] Deleting directory $(DIR_BUILD)/"
	@$(RM) $(DIR_BUILD)
	@echo "[2/2] Deleting directory $(DIR_BIN)/"
	@$(RM) $(DIR_BIN)
	@echo


#-------------------------------------------------
# Version information
#-------------------------------------------------
.PHONY: version
version:
	@echo Makefile v$(MK_VERSION_MAJOR).$(MK_VERSION_MINOR) for $(ENV_SYST)-$(ENV_ARCH)
	@echo
