#==============================================================================
# Makefile template for small / medium sized C projects.
# Author: Raphael CAUSSE
#==============================================================================

### Version
MK_VERSION_MAJOR := 2
MK_VERSION_MINOR := 0
MK_VERSION_PATCH := 0

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
CFLAGS := $(CSTD) -Wall -Wextra

### Extra flags to give to the C preprocessor (e.g. -I)
CPPFLAGS := 

### Extra flags to give to compiler when it invokes the linker (e.g. -L)
LDFLAGS := 

### Library names given to compiler when it invokes the linker (e.g. -l)
LDLIBS := 

### Build mode specific flags
DEBUG_FLAGS   := -O0 -g3
RELEASE_FLAGS := -O2 -g0


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
EXECUTABLE := $(DIR_BIN)/$(EXECUTABLE_NAME)

### Source files
SOURCE_FILES := $(filter-out \,$(ALL_SOURCES))

### Object files 
OBJECT_FILES := $(subst $(DIR_SRC),$(DIR_BUILD),$(addsuffix .o,$(basename $(filter-out \,$(ALL_SOURCES)))))


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
	echo '#-------------------------------------------------' >> $1; \
	echo '# MakefileList.mk v$(MK_VERSION_MAJOR).$(MK_VERSION_MINOR).$(MK_VERSION_PATCH)' >> $1; \
	echo '#-------------------------------------------------' >> $1; \
	echo >> $1; \
	echo '# Define project name' >> $1; \
	echo 'PROJECT_NAME := ' >> $1; \
	echo >> $1; \
	echo '# Define executable name' >> $1; \
	echo 'EXECUTABLE_NAME := ' >> $1; \
	echo >> $1; \
	echo '# Define build mode (debug or release)' >> $1; \
	echo 'BUILD_MODE := ' >> $1; \
	echo >> $1; \
	echo '# Define all source files to compile' >> $1; \
	echo 'ALL_SOURCES := ' >> $1; \
	echo >> $1;
endef


#==============================================================================
# RULES
#==============================================================================

default: build

#-------------------------------------------------
# Initialize project
#-------------------------------------------------
.PHONY: init
init:
	@echo 'Initialize project directory'

	@if [ ! -d "$(DIR_SRC)" ]; then \
		echo '-- Creating directory $(DIR_SRC)/'; \
		$(MKDIR) $(DIR_SRC); \
	else \
		echo '-- Directory $(DIR_SRC)/ already exists'; \
	fi

	@if [ ! -f "$(CONFIG_FILE)" ]; then \
		echo '-- Creating configuration file $(CONFIG_FILE)'; \
		$(call CREATE_CONFIG_FILE,$(CONFIG_FILE)) \
	else \
		echo '-- Configuration file $(CONFIG_FILE) already exists'; \
	fi

	@echo 'Initialize done'


#-------------------------------------------------
# (Internal rule) Check directories
#-------------------------------------------------
.PHONY: __checkdirs
__checkdirs:
	@if [ ! -d "$(DIR_BIN)" ]; then \
		$(MKDIR) $(DIR_BIN); \
	fi
	@if [ ! -d "$(DIR_BUILD)" ]; then \
		$(MKDIR) $(DIR_BUILD); \
	fi


#-------------------------------------------------
# (Internal rule) Pre build operations
#-------------------------------------------------
.PHONY: __prebuild
__prebuild: __checkdirs
    ifeq ($(filter $(CONFIG_FILE),$(wildcard *.mk)),)
	    $(error Configuration file '$(CONFIG_FILE)' not found. Please run "make init")
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

    ifeq ($(ALL_SOURCES),)
	    $(error $(CONFIG_FILE): ALL_SOURCES is required. Must provide all source files to compile)
    endif

	@echo 'Build Project: $(PROJECT_NAME) ($(BUILD_MODE))'

    ifeq ($(BUILD_MODE),debug)
	    $(eval CFLAGS += $(DEBUG_FLAGS))
    else ifeq ($(BUILD_MODE),release)
	    $(eval CFLAGS += $(RELEASE_FLAGS))
    endif


#-------------------------------------------------
# Build operations
#-------------------------------------------------
.PHONY: build
build: __prebuild $(EXECUTABLE)
	@echo 'Build done'


#-------------------------------------------------
# Link object files into target executable
#-------------------------------------------------
$(EXECUTABLE): $(OBJECT_FILES)
	@echo '-- Linking executable $@'
	@$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)


#-------------------------------------------------
# Compile C source files
#-------------------------------------------------
$(DIR_BUILD)/%.o: $(DIR_SRC)/%.c
	@echo '-- Compiling $<
	@$(MKDIR) $(dir $@)
	@$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@ 


#-------------------------------------------------
# Run executable
#-------------------------------------------------
.PHONY: run
run: $(EXECUTABLE)
	@./$(EXECUTABLE)


#-------------------------------------------------
# Clean generated files
#-------------------------------------------------
.PHONY: clean
clean:
	@echo 'Clean generated files'
	@echo '-- Deleting executable $(EXECUTABLE)'
	@$(RM) $(EXECUTABLE)
	@echo '-- Deleting objects $(OBJECT_FILES)'
	@$(RM) $(OBJECT_FILES)
	@echo 'Clean done'


#-------------------------------------------------
# Clean entire project
#-------------------------------------------------
.PHONY: cleanall
cleanall:
	@echo 'Clean entire project'
	@echo '-- Deleting directory $(DIR_BIN)/'
	@$(RM) $(DIR_BIN)
	@echo '-- Deleting directory $(DIR_BUILD)/'
	@$(RM) $(DIR_BUILD)
	@echo 'Clean done'


#-------------------------------------------------
# Project information
#-------------------------------------------------
.PHONY: info
info:
	@echo 'Build configurations ($(BUILD_MODE))'
	@echo '-- CC: $(CC)'
	@echo '-- CFLAGS: $(CFLAGS)'
	@echo '-- CPPFLAGS: $(CPPFLAGS)'
	@echo '-- LDFLAGS: $(LDFLAGS)'
	@echo '-- LDLIBS: $(LDLIBS)'
	@echo 'Files'
	@echo '-- EXECUTABLE: $(EXECUTABLE)'
	@echo '-- SOURCE_FILES: $(SOURCE_FILES)'
	@echo '-- OBJECT_FILES: $(OBJECT_FILES)'


#-------------------------------------------------
# Version information
#-------------------------------------------------
.PHONY: version
version:
	@echo Makefile v$(MK_VERSION_MAJOR).$(MK_VERSION_MINOR).$(MK_VERSION_PATCH) for $(ENV_SYST)-$(ENV_ARCH)
	@echo
