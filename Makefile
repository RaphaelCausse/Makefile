############################################################
# Makefile template for C/C++ projects.
# Please follow recommended project layout in README.
# Author : Raphael CAUSSE
# Date : 08/2022
############################################################

# Target executable name
TARGET_NAME := prog

ifeq ($(OS),Windows_NT)
TARGET_NAME := $(addsuffix .exe,$(TARGET_NAME))
endif


########################## PATHS ###########################

# Directories path set up.
DIR_BIN        := bin
DIR_BUILD      := build
DIR_SRC        := src


# Sources list file, where all source files to compile should be declared, without the "src/" path prefix.
SOURCES_FILE_MK     := $(DIR_SRC)/sources.mk


# Include directories, indicate where to search for included header files. It should contain the space-separated list of directories where header files can be found.
INCLUDE_DIRS            := src
# OS specific includes. Might defer depending your system configuration.
INCLUDE_DIRS_LINUX      :=
INCLUDE_DIRS_WINDOWS    :=

ifeq ($(OS),Windows_NT)
INCLUDE_DIRS += $(INCLUDE_DIRS_WINDOWS)
else
INCLUDE_DIRS += $(INCLUDE_DIRS_LINUX)
endif


# Libraries directories, specify the linker where to search for the libraries. It should contain the space-separated list of directories where libraries can be found.
LIBS_DIRS           := 
# OS specific libraries directories
LIBS_DIRS_LINUX     :=
LIBS_DIRS_WINDOWS   :=

ifeq ($(OS),Windows_NT)
LIBS_DIRS += $(LIBS_DIRS_WINDOWS)
else
LIBS_DIRS += $(LIBS_DIRS_LINUX)
endif


# Libraries to link, given by their name without the "lib" prefix (libm => m). It should contain the space-separated list of libraries that are used by your programs.
LIBS            	:= 
# OS specific libraries
LIBS_LINUX      	:=
LIBS_WINDOWS    	:=

ifeq ($(OS),Windows_NT)
LIBS += $(LIBS_WINDOWS)
else
LIBS += $(LIBS_LINUX)
endif


######################### COMPILER #########################

# Compiler and linker for both C and C++.
CC      			:= gcc
CXX     			:= g++

# /!\ Comment this line if you are using only C or only C++. Un-comment this line if you are using both C and C++.
# CC 		= $(CXX)

# Compiler options, applies to both C and C++ compiling as well as LD.
CFLAGS          	:= -Wall -Wextra -Wpedantic

# C Preprocessor options, to include directories.
CPPFLAGS        	:= $(addprefix -I,$(INCLUDE_DIRS))

# Linker options, to indicate where to search for linked libraries.
LDFLAGS         	:= $(addprefix -L,$(LIBS_DIRS)) $(addprefix -l,$(LIBS))


# Shortcuts for compiler and linker
COMPILE.c       	:= $(CC) $(CFLAGS) $(CPPFLAGS) -c
COMPILE.cxx     	:= $(CXX) $(CXXFLAGS) $(CPPFLAGS) -c
LINK.c          	:= $(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS)
LINK.cxx        	:= $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)


# Source files and object files set up.
-include $(SOURCES_FILE_MK)
SRC_FILES.c     	:= $(filter %.c,$(addprefix $(DIR_SRC)/,$(filter-out \,$(SOURCES))))
SRC_FILES.cxx   	:= $(filter %.cpp,$(addprefix $(DIR_SRC)/,$(filter-out \,$(SOURCES))))
OBJ_FILES       	:= $(addsuffix .o,$(basename $(filter-out \,$(SOURCES))))


# Release build set up. 
DIR_BIN_RELEASE     := $(DIR_BIN)/release
DIR_BUILD_RELEASE   := $(DIR_BUILD)/release
RELEASE_TARGET      := $(DIR_BIN_RELEASE)/$(TARGET_NAME)
RELEASE_FLAGS       := -O2
RELEASE_OBJS        := $(addprefix $(DIR_BUILD_RELEASE)/,$(OBJ_FILES))

# Debug build set up.
DIR_BIN_DEBUG       := $(DIR_BIN)/debug
DIR_BUILD_DEBUG     := $(DIR_BUILD)/debug
DEBUG_TARGET        := $(DIR_BIN_DEBUG)/$(TARGET_NAME)
DEBUG_FLAGS         := -O0 -g3
DEBUG_OBJS          := $(addprefix $(DIR_BUILD_DEBUG)/,$(OBJ_FILES))


########################## SHELL ###########################

ifeq ($(OS),Windows_NT)
MKDIR   			:= mkdir
RM_RF   			:= rmdir /S/Q
else
MKDIR   			:= mkdir -p
RM_RF   			:= rm -rf
endif


########################## RULES ###########################

# Default build, Debug mode.
default: debug


# Initialize project layout
.PHONY: init
init:
	@echo ======================== INITIALIZE ========================
	@echo Initializing project layout...
ifeq ($(filter $(DIR_SRC),$(wildcard *)),)
ifeq ($(OS),Windows_NT)
	@echo :: Creating directory "$(DIR_SRC)"
	@$(MKDIR) $(subst /,\,$(DIR_SRC))
else
	@echo ":: Creating directory '$(DIR_SRC)'"
	@$(MKDIR) $(DIR_SRC)
endif
endif
ifeq ($(filter $(SOURCES_FILE_MK),$(wildcard $(DIR_SRC)/*.mk)),)
ifeq ($(OS),Windows_NT)
	@echo :: Creating file "$(subst /,\,$(SOURCES_FILE_MK))"
	@echo # Declare all source files in the SOURCES variable, with "src" as the relative root.> $(subst /,\,$(SOURCES_FILE_MK))
	@echo # Write source files names on one line, or on multiple lines by adding a backslash at the end and going on a new line (no other characters after the backslash).>> $(subst /,\,$(SOURCES_FILE_MK))
	@echo SOURCES := \>> $(subst /,\,$(SOURCES_FILE_MK))
else
	@echo ":: Creating file '$(SOURCES_FILE_MK)'"
	@echo "# Declare all source files in the SOURCES variable, with 'src' as the relative root." > $(SOURCES_FILE_MK)
	@echo "# Write source files names on one line, or on multiple lines by adding a backslash at the end and going on a new line (no other characters after the backslash)." >> $(SOURCES_FILE_MK)
	@echo "SOURCES := \" >> $(SOURCES_FILE_MK)
endif
endif
	@echo Completed !
	@echo.
ifeq ($(OS),Windows_NT)
	@echo Declare all source files paths in "$(subst /,\,$(SOURCES_FILE_MK))".
else
	@echo "Declare all source files paths in '$(SOURCES_FILE_MK)'."
endif
	@echo ============================================================
	@echo.


# Check existing project directories for Release mode
.PHONY: check_dirs_release
check_dirs_release:
	@echo ======================== DIRECTORIES =======================
	@echo Checking project directories...
ifeq ($(filter $(DIR_BUILD_RELEASE),$(wildcard $(DIR_BUILD)/*)),)
ifeq ($(OS),Windows_NT)
	@echo :: Creating directory "$(DIR_BUILD_RELEASE)"
	@$(MKDIR) $(subst /,\,$(DIR_BUILD_RELEASE))
else
	@echo ":: Creating directory '$(DIR_BUILD_RELEASE)'"
	@$(MKDIR) $(DIR_BUILD_RELEASE)
endif
endif
ifeq ($(filter $(DIR_BIN_RELEASE),$(wildcard $(DIR_BIN)/*)),)
ifeq ($(OS),Windows_NT)
	@echo :: Creating directory "$(DIR_BIN_RELEASE)"
	@$(MKDIR) $(subst /,\,$(DIR_BIN_RELEASE))
else
	@echo ":: Creating directory '$(DIR_BIN_RELEASE)'"
	@$(MKDIR) $(DIR_BIN_RELEASE)
endif
endif
	@echo Completed !
	@echo ============================================================
	@echo.


# Check existing project directories for Debug mode
.PHONY: check_dirs_debug
check_dirs_debug:
	@echo ======================== DIRECTORIES =======================
	@echo Checking project directories...
ifeq ($(filter $(DIR_BUILD_DEBUG),$(wildcard $(DIR_BUILD)/*)),)
ifeq ($(OS),Windows_NT)
	@echo :: Creating directory "$(DIR_BUILD_DEBUG)"
	@$(MKDIR) $(subst /,\,$(DIR_BUILD_DEBUG))
else
	@echo ":: Creating directory '$(DIR_BUILD_DEBUG)'"
	@$(MKDIR) $(DIR_BUILD_DEBUG)
endif
endif
ifeq ($(filter $(DIR_BIN_DEBUG),$(wildcard $(DIR_BIN)/*)),)
ifeq ($(OS),Windows_NT)
	@echo :: Creating directory "$(DIR_BIN_DEBUG)"
	@$(MKDIR) $(subst /,\,$(DIR_BIN_DEBUG))
else
	@echo ":: Creating directory '$(DIR_BIN_DEBUG)'"
	@$(MKDIR) $(DIR_BIN_DEBUG)
endif
endif
	@echo Completed !
	@echo ============================================================
	@echo.


# Release pre-build
.PHONY: pre_release release
pre_release:
	@echo ======================= BUILD RELEASE ======================
ifeq ($(filter-out \,$(SOURCES)),)
ifeq ($(OS),Windows_NT)
	$(error No source files declared in "$(subst /,\,$(SOURCES_FILE_MK))")
else
	$(error No source files declared in '$(SOURCES_FILE_MK)'.)
endif
else
ifeq ($(OS),Windows_NT)
	@echo Configurations...
	@echo * OS :        $(OS)
ifeq ($(SRC_FILES.cxx),)
	@echo * Compiler :  $(CC)
else
	@echo * Compiler :  $(CXX)
endif
	@echo * CFLAGS :    $(CFLAGS) $(RELEASE_FLAGS)
	@echo * CPPFLAGS :  $(CPPFLAGS)
	@echo * LDFLAGS :   $(LDFLAGS)
	@echo.
	@echo Building "$(TARGET_NAME)" in Release mode...
else
	@echo "Configurations..."
	@echo "* OS :        $(shell uname)"
ifeq ($(SRC_FILES.cxx),)
	@echo "* Compiler :  $(CC)"
else
	@echo "* Compiler :  $(CXX)"
endif
	@echo "* CFLAGS :    $(CFLAGS) $(RELEASE_FLAGS)"
	@echo "* CPPFLAGS :  $(CPPFLAGS)"
	@echo "* LDFLAGS :   $(LDFLAGS)"
	@echo.
	@echo "Building '$(TARGET_NAME)' in Release mode..."
endif
endif

# Release build
release: check_dirs_release pre_release $(RELEASE_TARGET)
	@echo Completed !
	@echo ============================================================
	@echo.

# Link object files for Release target.
$(RELEASE_TARGET): $(RELEASE_OBJS)
ifeq ($(OS),Windows_NT)
	@echo :: Linking release objects into "$(RELEASE_TARGET)"
else
	@echo ":: Linking release objects into '$(RELEASE_TARGET)'"
endif
ifeq ($(SRC_FILES.cxx),)
	@$(LINK.c) $(RELEASE_FLAGS) $^ -o $@
else
	@$(LINK.cxx) $(RELEASE_FLAGS) $^ -o $@
endif

# Compile C source files for Release build.
$(DIR_BUILD_RELEASE)/%.o: $(DIR_SRC)/%.c
ifeq ($(OS),Windows_NT)
	@if not exist "$(dir $@)" (\
		echo :: Creating directory "$(dir $@)" && $(MKDIR) "$(subst /,\,$(dir $@))" \
	)
	@echo :: Compiling "$<"
else
	@echo ":: Creating directory '$(dir $@)'"
	@$(MKDIR) $(dir $@)
	@echo ":: Compiling '$<'"
endif
	@$(COMPILE.c) $(RELEASE_FLAGS) $< -o $@

# Compile C++ source files for Release build.
$(DIR_BUILD_RELEASE)/%.o: $(DIR_SRC)/%.cpp
ifeq ($(OS),Windows_NT)
	@if not exist "$(dir $@)" (\
		echo :: Creating directory "$(dir $@)" && $(MKDIR) "$(subst /,\,$(dir $@))" \
	)
	@echo :: Compiling "$<"
else
	@echo ":: Creating directory '$(dir $@)'"
	@$(MKDIR) $(dir $@)
	@echo ":: Compiling '$<'"
endif
	@$(COMPILE.cxx) $(RELEASE_FLAGS) $< -o $@


# Debug pre-build
.PHONY: pre_debug debug
pre_debug:
	@echo ======================== BUILD DEBUG =======================
ifeq ($(filter-out \,$(SOURCES)),)
ifeq ($(OS),Windows_NT)
	$(error No source files declared in "$(subst /,\,$(SOURCES_FILE_MK))")
else
	$(error No source files declared in '$(SOURCES_FILE_MK)'.)
endif
else
ifeq ($(OS),Windows_NT)
	@echo Configurations...
	@echo * OS :        $(OS)
ifeq ($(SRC_FILES.cxx),)
	@echo * Compiler :  $(CC)
else
	@echo * Compiler :  $(CXX)
endif
	@echo * CFLAGS :    $(CFLAGS) $(DEBUG_FLAGS) 
	@echo * CPPFLAGS :  $(CPPFLAGS)
	@echo * LDFLAGS :   $(LDFLAGS)
	@echo.
	@echo Building "$(TARGET_NAME)" in Debug mode...
else
	@echo "Configurations..."
	@echo "* OS :        $(shell uname)"
ifeq ($(SRC_FILES.cxx),)
	@echo "* Compiler :  $(CC)"
else
	@echo "* Compiler :  $(CXX)"
endif
	@echo "* CFLAGS :    $(CFLAGS) $(DEBUG_FLAGS)"
	@echo "* CPPFLAGS :  $(CPPFLAGS)"
	@echo "* LDFLAGS :   $(LDFLAGS)"
	@echo.
	@echo "Building '$(TARGET_NAME)' in Debug mode..."
endif
endif

# Debug build
debug: check_dirs_debug pre_debug $(DEBUG_TARGET)
	@echo Completed !
	@echo ============================================================
	@echo.

# Link objects files for Debug target.
$(DEBUG_TARGET): $(DEBUG_OBJS)
ifeq ($(OS),Windows_NT)
	@echo :: Linking Debug objects into "$(DEBUG_TARGET)"
else
	@echo ":: Linking Debug objects into '$(DEBUG_TARGET)'"
endif
ifeq ($(SRC_FILES.cxx),)
	@$(LINK.c) $(DEBUG_FLAGS) $^ -o $@
else
	@$(LINK.cxx) $(DEBUG_FLAGS) $^ -o $@
endif

# Compile C source files for Debug build.
$(DIR_BUILD_DEBUG)/%.o: $(DIR_SRC)/%.c
ifeq ($(OS),Windows_NT)
	@if not exist "$(dir $@)" (\
		echo :: Creating directory "$(dir $@)" && $(MKDIR) "$(subst /,\,$(dir $@))" \
	)
	@echo :: Compiling "$<"
else
	@echo ":: Creating directory '$(dir $@)'"
	@$(MKDIR) $(dir $@)
	@echo ":: Compiling '$<'"
endif
	@$(COMPILE.c) $(DEBUG_FLAGS) $< -o $@

# Compile C++ source files for Debug build.
$(DIR_BUILD_DEBUG)/%.o: $(DIR_SRC)/%.cpp
ifeq ($(OS),Windows_NT)
	@if not exist "$(dir $@)" (\
		echo :: Creating directory "$(dir $@)" && $(MKDIR) "$(subst /,\,$(dir $@))" \
	)
	@echo :: Compiling "$<"
else
	@echo ":: Creating directory '$(dir $@)'"
	@$(MKDIR) $(dir $@)
	@echo ":: Compiling '$<'"
endif
	@$(COMPILE.cxx) $(DEBUG_FLAGS) $< -o $@


# Clean project, removing bin and build directories
.PHONY: clean
clean:
	@echo ====================== CLEAN PROJECT =======================
	@echo Cleaning project...
ifeq ($(filter $(DIR_BUILD),$(wildcard *)),$(DIR_BUILD))
ifeq ($(OS),Windows_NT)
	@echo :: Deleting directory "$(DIR_BUILD)"
else
	@echo ":: Deleting directory '$(DIR_BUILD)'"
endif
	@$(RM_RF) $(DIR_BUILD)
endif
ifeq ($(filter $(DIR_BIN),$(wildcard *)),$(DIR_BIN))
ifeq ($(OS),Windows_NT)
	@echo :: Deleting directory "$(DIR_BIN)"
else
	@echo ":: Deleting directory '$(DIR_BIN)'"
endif
	@$(RM_RF) $(DIR_BIN)
endif
	@echo Completed !
	@echo ============================================================
	@echo.

# Clean objects, removing build directories
.PHONY: cleanobj
cleanobj:
	@echo ====================== CLEAN OBJECTS =======================
	@echo Cleaning objects files...
ifeq ($(filter $(DIR_BUILD),$(wildcard *)),$(DIR_BUILD))
ifeq ($(OS),Windows_NT)
	@echo :: Deleting directory "$(DIR_BUILD)"
else
	@echo ":: Deleting directory '$(DIR_BUILD)'"
endif
	@$(RM_RF) $(DIR_BUILD)
endif
	@echo Completed !
	@echo ============================================================
	@echo.


# Run the release target
.PHONY: run
run: 
ifneq ($(filter $(RELEASE_TARGET),$(wildcard $(DIR_BIN_RELEASE)/*)),)
	-@$(RELEASE_TARGET) $(ARGS)
else
ifeq ($(OS),Windows_NT)
	$(warning Try to compile using the command "make release".)
	$(error No executable "$(subst /,\,$(RELEASE_TARGET))" found.)
else
	$(warning Try to compile using the command "make release".)
	$(error No executable "$(RELEASE_TARGET)" found.)
endif
endif

# Run the debug target
.PHONY: run_debug
run_debug: 
ifneq ($(filter $(DEBUG_TARGET),$(wildcard $(DIR_BIN_DEBUG)/*)),)
	-@$(DEBUG_TARGET) $(ARGS)
else
ifeq ($(OS),Windows_NT)
	$(warning Try to compile using the command "make release".)
	$(error No executable "$(subst /,\,$(DEBUG_TARGET))" found.)
else
	$(warning Try to compile using the command "make release".)
	$(error No executable "$(DEBUG_TARGET)" found.)
endif
endif


# Display source and object files.
.PHONY: info
info:
	@echo ======================= PROJECT INFO =======================
ifeq ($(OS),Windows_NT)
	@echo Configurations...
	@echo * OS :        $(OS)
ifeq ($(SRC_FILES.cxx),)
	@echo * Compiler :  $(CC)
else
	@echo * Compiler :  $(CXX)
endif
	@echo * CFLAGS :    $(CFLAGS)
	@echo * CPPFLAGS :  $(CPPFLAGS)
	@echo * LDFLAGS :   $(LDFLAGS)
else
	@echo "Configurations..."
	@echo "* OS :        $(shell uname)"
ifeq ($(SRC_FILES.cxx),)
	@echo "* Compiler :  $(CC)"
else
	@echo "* Compiler :  $(CXX)"
endif
	@echo "* CFLAGS :    $(CFLAGS)"
	@echo "* CPPFLAGS :  $(CPPFLAGS)"
	@echo "* LDFLAGS :   $(LDFLAGS)"
endif
	@echo.
	@echo ============================================================
ifeq ($(OS),Windows_NT)
	@echo C source files (.c) :
	@echo : $(SRC_FILES.c)
	@echo ------------------------------------------------------------
	@echo C++ source files (.cpp) :
	@echo : $(SRC_FILES.cxx)
	@echo ------------------------------------------------------------
	@echo Object files, Release build :
	@echo : $(RELEASE_OBJS)
	@echo ------------------------------------------------------------
	@echo Object files, Debug build :
	@echo : $(DEBUG_OBJS)
else
	@echo "C source files (.c) :"
	@echo ": $(SRC_FILES.c)"
	@echo ------------------------------------------------------------
	@echo "C++ source files (.cpp) :"
	@echo ": $(SRC_FILES.cxx)"
	@echo ------------------------------------------------------------
	@echo Object files, Release build :
	@echo ": $(RELEASE_OBJS)"
	@echo ------------------------------------------------------------
	@echo Object files, Debug build :
	@echo ": $(DEBUG_OBJS)"
endif
	@echo ============================================================
	@echo.


# Display usage help.
.PHONY: help
help:
	@echo =========================== HELP ===========================
ifeq ($(OS),Windows_NT)
	@echo Usage:
	@echo     make                Build project, in default mode (Debug).
	@echo     make release        Build project, in Release mode.
	@echo     make debug          Build project, in Debug mode.
	@echo     make clean          Clean project, remove directories "$(DIR_BIN)" and "$(DIR_BUILD)".
	@echo     make cleanobj       Clean object files, remove directory "$(DIR_BUILD)".
	@echo     make run            Run release target "$(RELEASE_TARGET)".
	@echo     make run_debug      Run debug target "$(DEBUG_TARGET)".
	@echo     make info           Display info about project.
	@echo     make version        Display compilers version.
	@echo     make help           Display this help message.
else
	@echo "Usage:"
	@echo "    make                Build project, in default mode (Debug)."
	@echo "    make release        Build project, in Release mode."
	@echo "    make debug          Build project, in Debug mode."
	@echo "    make clean          Clean project, remove directories '$(DIR_BIN)' and '$(DIR_BUILD)'."
	@echo "    make cleanobj       Clean object files, remove directory '$(DIR_BUILD)'."
	@echo "    make run            Run release target '$(RELEASE_TARGET)'."
	@echo "    make run_debug      Run debug target '$(DEBUG_TARGET)'."
	@echo "    make info           Display info about project."
	@echo "    make version        Display compiler version."
	@echo "    make help           Display this help message."
endif
	@echo ============================================================
	@echo.


## Version info
.PHONY: version
version:
	@echo ========================== VERSION =========================
	@$(CC) --version
	@$(CXX) --version
	@echo ============================================================
	@echo.
