############################################################
# Makefile template for small/meduim C projects.
# Please follow recommended project layout in README.
# Author : Raphael CAUSSE
############################################################


## Target executable name
TARGET_EXE := prog

ifeq ($(OS),Windows_NT) # For Windows
TARGET_EXE := $(addsuffix .exe,$(TARGET_EXE))
endif


########################## PATHS ###########################

## Directories path set up.
DIR_BIN     := bin
DIR_BUILD   := build
DIR_SRC     := src


## Sources list file, where all source files to compile should be declared, within the "src/" directory.
SOURCES_FILE_MK        := sources.mk


## Include directories, indicate where to search for included header files. It should contain the space-separated list of directories where header files can be found.
INCLUDES_DIRS          := 
## OS specific includes directories.
INCLUDES_DIRS_LINUX    :=
INCLUDES_DIRS_WINDOWS  :=

ifeq ($(OS),Windows_NT) # For Windows
INCLUDES_DIRS += $(INCLUDES_DIRS_WINDOWS)
else # For Linux
INCLUDES_DIRS += $(subst /,\,$(INCLUDES_DIRS_LINUX))
endif


## Libraries to link, given by their name without the "lib" prefix (libm => m). It should contain the space-separated list of libraries that are used by your programs.
LIBRAIRIES          := 
## OS specific libraries.
LIBRAIRIES_LINUX    :=
LIBRAIRIES_WINDOWS  :=

ifeq ($(OS),Windows_NT) # For Windows
LIBRAIRIES += $(LIBRAIRIES_WINDOWS)
else # For Linux
LIBRAIRIES += $(LIBRAIRIES_LINUX)
endif


## Libraries directories, specify the linker where to search for the libraries. It should contain the space-separated list of directories where libraries can be found.
LIBRARIES_DIRS          := 
## OS specific libraries directories.
LIBRARIES_DIRS_LINUX    :=
LIBRARIES_DIRS_WINDOWS  :=

ifeq ($(OS),Windows_NT) # For Windows
LIBRARIES_DIRS += $(LIBRARIES_DIRS_WINDOWS)
else # For Linux
LIBRARIES_DIRS += $(subst /,\,$(LIBRARIES_DIRS_LINUX))
endif


######################### COMPILER #########################

## Compiler and linker.
CC        := gcc

## Compiler options.
CFLAGS    := -pedantic -Wall -Wpedantic

## Preprocessor options.
CPPFLAGS  := $(addprefix -I,$(INCLUDES_DIRS))

## Linker options.
LDFLAGS   := $(addprefix -l,$(LIBRAIRIES)) $(addprefix -L,$(LIBRARIES_DIRS))


## Source files and object files set up.
-include $(SOURCES_FILE_MK)
SRC_FILES.c     := $(filter %.c,$(addprefix $(DIR_SRC)/,$(filter-out \,$(SOURCES))))
OBJ_FILES       := $(addsuffix .o,$(basename $(filter-out \,$(SOURCES))))


## Release build set up. 
DIR_BIN_RELEASE     := $(DIR_BIN)/release
DIR_BUILD_RELEASE   := $(DIR_BUILD)/release
RELEASE_TARGET      := $(DIR_BIN_RELEASE)/$(TARGET_EXE)
RELEASE_FLAGS       := -O2
RELEASE_OBJS        := $(addprefix $(DIR_BUILD_RELEASE)/,$(OBJ_FILES))


## Debug build set up.
DIR_BIN_DEBUG       := $(DIR_BIN)/debug
DIR_BUILD_DEBUG     := $(DIR_BUILD)/debug
DEBUG_TARGET        := $(DIR_BIN_DEBUG)/$(TARGET_EXE)
DEBUG_FLAGS         := -O0 -g3
DEBUG_OBJS          := $(addprefix $(DIR_BUILD_DEBUG)/,$(OBJ_FILES))


########################## SHELL ###########################

ifeq ($(OS),Windows_NT) # For Windows
MKDIR  := mkdir
RM     := del /f/q
RM_RF  := rmdir /S/Q
CP     := copy /y
else # For Linux
MKDIR  := mkdir -p
RM     := rm -f
RM_RF  := rm -rf
CP     := cp
endif


########################## RULES ###########################

#### Default build.
default: debug


#### Initialize project layout
.PHONY: init
init:
	@echo ================================== Initialize ==================================
	@echo Initializing project layout...

ifeq ($(filter $(DIR_SRC),$(wildcard *)),)
ifeq ($(OS),Windows_NT) # For Windows
	@echo     Create directory "$(DIR_SRC)"
	@$(MKDIR) $(subst /,\,$(DIR_SRC))
else # For Linux
	@echo "    Create directory '$(DIR_SRC)'"
	@$(MKDIR) $(DIR_SRC)
endif
endif

ifeq ($(filter $(SOURCES_FILE_MK),$(wildcard $(SOURCES_FILE_MK))),)
ifeq ($(OS),Windows_NT) # For Windows
	@echo     Create file "$(subst /,\,$(SOURCES_FILE_MK))"
	@echo # Declare all sources files in the SOURCES variable, within the "src/" directory.> $(subst /,\,$(SOURCES_FILE_MK))
	@echo # Write source files names on one line separated by a space, or on multiple lines by adding a backslash at the end and going on a new line (no other characters after the backslash).>> $(subst /,\,$(SOURCES_FILE_MK))
	@echo SOURCES := \>> $(subst /,\,$(SOURCES_FILE_MK))
else # For Linux
	@echo "    Create file '$(SOURCES_FILE_MK)'"
	@echo "# Declare all sources files in the SOURCES variable, within the 'src/' directory." > $(SOURCES_FILE_MK)
	@echo "# Write sources files names on one line separated by a space, or on multiple lines by adding a backslash at the end and going on a new line (no other characters after the backslash).">> $(SOURCES_FILE_MK)
	@echo "SOURCES := \">> $(SOURCES_FILE_MK)
endif
endif
	@echo Completed.
ifeq ($(OS),Windows_NT) # For Windows
	@echo.
else # For Linux
	@echo
endif

ifeq ($(OS),Windows_NT) # For Windows
	@echo Declare all sources files in "$(subst /,\,$(SOURCES_FILE_MK))".
else # For Linux
	@echo "Declare all sources files in '$(SOURCES_FILE_MK)'."
endif
	@echo ================================================================================
ifeq ($(OS),Windows_NT) # For Windows
	@echo.
else # For Linux
	@echo
endif


#### Check existing project directories and create missing directories
.PHONY: check_directories
check_directories:
	@echo ================================= Directories ==================================
	@echo Checking project directories...

ifeq ($(filter $(DIR_BUILD_RELEASE),$(wildcard $(DIR_BUILD)/*)),)
ifeq ($(OS),Windows_NT) # For Windows
	@echo     Create directory "$(DIR_BUILD_RELEASE)"
	@$(MKDIR) $(subst /,\,$(DIR_BUILD_RELEASE))
else # For Linux
	@echo "    Create directory '$(DIR_BUILD_RELEASE)'"
	@$(MKDIR) $(DIR_BUILD_RELEASE)
endif
endif

ifeq ($(filter $(DIR_BIN_RELEASE),$(wildcard $(DIR_BIN)/*)),)
ifeq ($(OS),Windows_NT) # For Windows
	@echo     Create directory "$(DIR_BIN_RELEASE)"
	@$(MKDIR) $(subst /,\,$(DIR_BIN_RELEASE))
else # For Linux
	@echo "    Create directory '$(DIR_BIN_RELEASE)'"
	@$(MKDIR) $(DIR_BIN_RELEASE)
endif
endif

ifeq ($(filter $(DIR_BUILD_DEBUG),$(wildcard $(DIR_BUILD)/*)),)
ifeq ($(OS),Windows_NT) # For Windows
	@echo     Create directory "$(DIR_BUILD_DEBUG)"
	@$(MKDIR) $(subst /,\,$(DIR_BUILD_DEBUG))
else # For Linux
	@echo "    Create directory '$(DIR_BUILD_DEBUG)'"
	@$(MKDIR) $(DIR_BUILD_DEBUG)
endif
endif

ifeq ($(filter $(DIR_BIN_DEBUG),$(wildcard $(DIR_BIN)/*)),)
ifeq ($(OS),Windows_NT) # For Windows
	@echo     Create directory "$(DIR_BIN_DEBUG)"
	@$(MKDIR) $(subst /,\,$(DIR_BIN_DEBUG))
else # For Linux
	@echo "    Create directory '$(DIR_BIN_DEBUG)'"
	@$(MKDIR) $(DIR_BIN_DEBUG)
endif
endif
	@echo Completed.
	@echo ================================================================================
ifeq ($(OS),Windows_NT) # For Windows
	@echo.
else # For Linux
	@echo
endif


#### Release pre-build
.PHONY: pre_release release
pre_release:
	@echo ================================ Build Release =================================

ifeq ($(filter-out \,$(SOURCES)),)
ifeq ($(OS),Windows_NT) # For Windows
	$(error No source files declared in "$(subst /,\,$(SOURCES_FILE_MK))")
else # For Linux
	$(error No source files declared in '$(SOURCES_FILE_MK)'.)
endif
else
ifeq ($(OS),Windows_NT) # For Windows
	@echo Build configurations...
	@echo     OS:         $(OS)
	@echo     Compiler:   $(CC)
	@echo     CFLAGS:     $(CFLAGS) $(RELEASE_FLAGS)
	@echo     CPPFLAGS:   $(CPPFLAGS)
	@echo     LDFLAGS:    $(LDFLAGS)
	@echo.
	@echo Building target "$(RELEASE_TARGET)"...
else # For Linux
	@echo "Build configurations..."
	@echo "    OS:         $(shell uname)"
	@echo "    Compiler:   $(CC)"
	@echo "    CFLAGS:     $(CFLAGS) $(RELEASE_FLAGS)"
	@echo "    CPPFLAGS:   $(CPPFLAGS)"
	@echo "    LDFLAGS:    $(LDFLAGS)"
	@echo
	@echo "Building target '$(RELEASE_TARGET)'..."
endif
endif


#### Release build
release: check_directories pre_release $(RELEASE_TARGET)
	@echo Completed.
ifeq ($(OS),Windows_NT) # For Windows
	@echo.
	@echo ***** Build success *****
else # For Linux
	@echo
	@echo "***** Build success *****"
endif
	@echo ================================================================================
ifeq ($(OS),Windows_NT) # For Windows
	@echo.
else # For Linux
	@echo
endif


#### Link object files for Release target.
$(RELEASE_TARGET): $(RELEASE_OBJS)
ifeq ($(OS),Windows_NT) # For Windows
	@echo     Link $(words $^) objects into "$(RELEASE_TARGET)"
else # For Linux
	@echo "    Link $(words $^) objects into '$(RELEASE_TARGET)'"
endif
	@$(CC) -o $@ $^ $(LDFLAGS)


#### Compile C source files for Release build.
$(DIR_BUILD_RELEASE)/%.o: $(DIR_SRC)/%.c
ifeq ($(OS),Windows_NT) # For Windows
	@if not exist "$(dir $@)" (\
		$(MKDIR) "$(subst /,\,$(dir $@))" \
	)
	@echo     Compile "$<" into "$@"
else # For Linux
	@$(MKDIR) $(dir $@)
	@echo "    Compile '$<' into '$@'"
endif
	@$(CC) $(CFLAGS) $(CPPFLAGS) $(RELEASE_FLAGS) -o $@ -c $<


#### Debug pre-build
.PHONY: pre_debug debug
pre_debug:
	@echo ================================= Build Debug ==================================
ifeq ($(filter-out \,$(SOURCES)),)
ifeq ($(OS),Windows_NT) # For Windows
	$(error No source files declared in "$(subst /,\,$(SOURCES_FILE_MK))")
else
	$(error No source files declared in '$(SOURCES_FILE_MK)'.)
endif
else
ifeq ($(OS),Windows_NT) # For Windows
	@echo Build configurations...
	@echo     OS:         $(OS)
	@echo     Compiler:   $(CC)
	@echo     CFLAGS:     $(CFLAGS) $(DEBUG_FLAGS) 
	@echo     CPPFLAGS:   $(CPPFLAGS)
	@echo     LDFLAGS:    $(LDFLAGS)
	@echo.
	@echo Building target "$(DEBUG_TARGET)"...
else # For Linux
	@echo "Build configurations..."
	@echo "    OS:         $(shell uname)"
	@echo "    Compiler:   $(CC)"
	@echo "    CFLAGS:     $(CFLAGS) $(DEBUG_FLAGS)"
	@echo "    CPPFLAGS:   $(CPPFLAGS)"
	@echo "    LDFLAGS:    $(LDFLAGS)"
	@echo
	@echo "Building target '$(DEBUG_TARGET)'..."
endif
endif


#### Debug build
debug: check_directories pre_debug $(DEBUG_TARGET)
	@echo Completed.
ifeq ($(OS),Windows_NT) # For Windows
	@echo.
	@echo ***** Build success *****
else # For Linux
	@echo
	@echo "***** Build success *****"
endif
	@echo ================================================================================
ifeq ($(OS),Windows_NT) # For Windows
	@echo.
else # For Linux
	@echo
endif


#### Link objects files for Debug target.
$(DEBUG_TARGET): $(DEBUG_OBJS)
ifeq ($(OS),Windows_NT) # For Windows
	@echo     Link $(words $^) objects into "$(DEBUG_TARGET)"
else # For Linux
	@echo "    Link $(words $^) objects into '$(DEBUG_TARGET)'"
endif
	@$(CC) -o $@ $^ $(LDFLAGS)


#### Compile C source files for Debug build.
$(DIR_BUILD_DEBUG)/%.o: $(DIR_SRC)/%.c
ifeq ($(OS),Windows_NT) # For Windows
	@if not exist "$(dir $@)" (\
		$(MKDIR) "$(subst /,\,$(dir $@))" \
	)
	@echo     Compile "$<" into "$@"
else # For Linux
	@$(MKDIR) $(dir $@)
	@echo "    Compile '$<' into '$@'"
endif
	@$(CC) $(CFLAGS) $(CPPFLAGS) $(DEBUG_FLAGS) -o $@ -c $<


#### Clean generated files, remove objects and targets.
.PHONY: clean
clean:
	@echo ==================================== Clean =====================================
	@echo Cleaning objects...

ifneq ($(wildcard $(DIR_BUILD_RELEASE)/*),)
ifeq ($(OS),Windows_NT) # For Windows
	@echo     Delete objects in "$(DIR_BUILD_RELEASE)" directory
	@$(RM_RF) $(subst /,\,$(DIR_BUILD_RELEASE))
	@$(MKDIR) $(subst /,\,$(DIR_BUILD_RELEASE))
else # For Linux
	@echo "    Delete objects in '$(DIR_BUILD_RELEASE)' directory"
	@$(RM_RF) $(DIR_BUILD_RELEASE)
	@$(MKDIR) $(DIR_BUILD_RELEASE)
endif
endif

ifneq ($(wildcard $(DIR_BUILD_DEBUG)/*),)
ifeq ($(OS),Windows_NT) # For Windows
	@echo     Delete objects in "$(DIR_BUILD_DEBUG)" directory
	@$(RM_RF) $(subst /,\,$(DIR_BUILD_DEBUG))
	@$(MKDIR) $(subst /,\,$(DIR_BUILD_DEBUG))
else # For Linux
	@echo "    Delete objects in '$(DIR_BUILD_DEBUG)' directory"
	@$(RM_RF) $(DIR_BUILD_DEBUG)
	@$(MKDIR) $(DIR_BUILD_DEBUG)
endif
endif
	@echo Completed.
ifeq ($(OS),Windows_NT) # For Windows
	@echo.
else # For Linux
	@echo
endif

	@echo Cleaning targets...
ifneq ($(filter $(RELEASE_TARGET),$(wildcard $(DIR_BIN_RELEASE)/*)),)
ifeq ($(OS),Windows_NT) # For Windows
	@echo     Delete target "$(RELEASE_TARGET)"
	@$(RM) $(subst /,\,$(RELEASE_TARGET))
else # For Linux
	@echo "    Delete target '$(RELEASE_TARGET)'"
	@$(RM) $(RELEASE_TARGET)
endif
endif

ifneq ($(filter $(DEBUG_TARGET),$(wildcard $(DIR_BIN_DEBUG)/*)),)
ifeq ($(OS),Windows_NT) # For Windows
	@echo     Delete target "$(DEBUG_TARGET)"
	@$(RM) $(subst /,\,$(DEBUG_TARGET))
else # For Linux
	@echo "    Delete  target '$(DEBUG_TARGET)'"
	@$(RM) $(DEBUG_TARGET)
endif
endif
	@echo Completed.
	@echo ================================================================================
ifeq ($(OS),Windows_NT) # For Windows
	@echo.
else # For Linux
	@echo
endif


#### Run the release target
.PHONY: run
run:
	@echo ============================== Run Release Target ==============================
ifneq ($(filter $(RELEASE_TARGET),$(wildcard $(DIR_BIN_RELEASE)/*)),)
	-@$(RELEASE_TARGET) $(ARGS)
else
ifeq ($(OS),Windows_NT) # For Windows
	$(warning Try to compile using the command "make release".)
	$(error No executable "$(subst /,\,$(RELEASE_TARGET))" found)
else # For Linux
	$(warning Try to compile using the command "make release".)
	$(error No executable "$(RELEASE_TARGET)" found)
endif
endif


#### Run the debug target
.PHONY: rund
rund: 
	@echo =============================== Run Debug Target ===============================
ifneq ($(filter $(DEBUG_TARGET),$(wildcard $(DIR_BIN_DEBUG)/*)),)
	-@$(DEBUG_TARGET) $(ARGS)
else
ifeq ($(OS),Windows_NT) # For Windows
	$(warning Try to compile using the command "make debug".)
	$(error No executable "$(subst /,\,$(DEBUG_TARGET))" found)
else # For Linux
	$(warning Try to compile using the command "make debug".)
	$(error No executable "$(DEBUG_TARGET)" found)
endif
endif


#### Display project files informations.
.PHONY: info
info:
	@echo ================================ Project Infos =================================
ifeq ($(OS),Windows_NT) # For Windows
	@echo Build configurations...
	@echo     OS:         $(OS)
	@echo     Compiler:   $(CC)
	@echo     CFLAGS:     $(CFLAGS)
	@echo     CPPFLAGS:   $(CPPFLAGS)
	@echo     LDFLAGS:    $(LDFLAGS)
	@echo.
else # For Linux
	@echo "Build configurations..."
	@echo "    OS:         $(shell uname)"
	@echo "    Compiler:   $(CC)"
	@echo "    CFLAGS:     $(CFLAGS)"
	@echo "    CPPFLAGS:   $(CPPFLAGS)"
	@echo "    LDFLAGS:    $(LDFLAGS)"
	@echo
endif

ifeq ($(OS),Windows_NT) # For Windows
	@echo C source files (.c) :
ifneq ($(SRC_FILES.c),)
	@echo     $(subst  /,\,$(SRC_FILES.c))
endif
	@echo.
	@echo Object files (.o) :
ifneq ($(OBJ_FILES),)
	@echo     $(subst  /,\,$(OBJ_FILES))
endif

else # For Linux
	@echo "C source files (.c) :"
ifneq ($(SRC_FILES.c),)
	@echo "    $(SRC_FILES.c)"
endif
	@echo

	@echo Object files (.o) :
ifneq ($(OBJ_FILES),)
	@echo "    $(OBJ_FILES)"
endif

endif
	@echo ================================================================================
ifeq ($(OS),Windows_NT) # For Windows
	@echo.
else # For Linux
	@echo
endif


#### Display usage help.
.PHONY: help
help:
	@echo ===================================== Help =====================================
ifeq ($(OS),Windows_NT) # For Windows
	@echo Usage:
	@echo     make                Build project, in default mode (Debug).
	@echo     make release        Build project, in Release mode.
	@echo     make debug          Build project, in Debug mode.
	@echo     make run            Run release target "$(RELEASE_TARGET)".
	@echo     make rund           Run debug target "$(DEBUG_TARGET)".
	@echo     make clean          Clean generated files, remove objects and targets.
	@echo     make info           Display infos about project.
	@echo     make help           Display this help message.
	@echo     make version        Display compilers version.
else # For Linux
	@echo "Usage:"
	@echo "    make                Build project, in default mode (Debug)."
	@echo "    make release        Build project, in Release mode."
	@echo "    make debug          Build project, in Debug mode."
	@echo "    make run            Run release target '$(RELEASE_TARGET)'."
	@echo "    make rund           Run debug target '$(DEBUG_TARGET)'."
	@echo "    make clean          Clean generated files, remove objects and targets."
	@echo "    make info           Display infos about project."
	@echo "    make help           Display this help message." 
	@echo "    make version        Display compiler version."
endif
	@echo ================================================================================
ifeq ($(OS),Windows_NT) # For Windows
	@echo.
else # For Linux
	@echo
endif


#### Version info
.PHONY: version
version:
	@echo ================================== C Compiler ==================================
	@$(CC) --version
	@$(CC) -v
	@echo ================================================================================
ifeq ($(OS),Windows_NT) # For Windows
	@echo.
else # For Linux
	@echo
endif
