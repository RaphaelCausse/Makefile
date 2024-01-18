###########################################
# Generic Makefile for C/C++ projects.
# Please follow recommended project layout in README.
# Author	: Raphael CAUSSE
# Date   	: 08/2022
###########################################

TARGET_NAME := prog

ifeq ($(OS),Windows_NT)
	TARGET_NAME := $(addsuffix .exe,$(TARGET_NAME))
else
	TARGET_NAME := $(addsuffix .out,$(TARGET_NAME))
endif


################## PATHS ##################

# Directories path set up.
DIR_BIN 	:= bin
DIR_BUILD 	:= build
DIR_SRC 	:= src

# Includes (directories)
INCLUDES 	:=  src \
                C:/MinGW/include \
                C:/MinGW/lib/gcc/mingw32/6.3.0/include \
                C:/MinGW/mingw32/include \
                C:/MinGW/mingw32/lib

# Libraries
LIBS 		:=

################ COMPILER ################

# Compiler and linker.
CC 	:= gcc
CXX := g++

# Extra Compiler options, applies to both C and C++ compiling as well as LD.
EXTRA_CFLAGS 	= 
# C Preprocessor options 
CPPFLAGS 		= -Wall -Wextra $(addprefix -I,$(INCLUDES))
# Extra Linker options
EXTRA_LDFLAGS 	= $(addprefix -l,$(LIBS))

# Shortcuts for compiler and linker
COMPILE.c 	= $(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(CPPFLAGS) -c
COMPILE.cxx = $(CXX) $(CXXFLAGS) $(EXTRA_CFLAGS) $(CPPFLAGS) -c
LINK.c 		= $(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(CPPFLAGS) $(LDFLAGS)
LINK.cxx 	= $(CXX) $(CXXFLAGS) $(EXTRA_CFLAGS) $(CPPFLAGS) $(LDFLAGS)


# Sources and object files set up.
include $(DIR_SRC)/sources.mk
SRC_FILES.c := $(filter %.c,$(addprefix $(DIR_SRC)/,$(filter-out \,$(SOURCES))))
SRC_FILES.cxx := $(filter %.cpp,$(addprefix $(DIR_SRC)/,$(filter-out \,$(SOURCES))))
OBJ_FILES := $(addsuffix .o,$(basename $(filter-out \,$(SOURCES))))

# Release build set up. 
DIR_BIN_REL 	:= $(DIR_BIN)/release
DIR_BUILD_REL 	:= $(DIR_BUILD)/release
REL_TARGET 		:= $(DIR_BIN_REL)/$(TARGET_NAME)
REL_FLAGS 		:= -O2
REL_OBJS 		:= $(addprefix $(DIR_BUILD_REL)/,$(OBJ_FILES))

# Debug build set up.
DIR_BIN_DBG 	:= $(DIR_BIN)/debug
DIR_BUILD_DBG 	:= $(DIR_BUILD)/debug
DBG_TARGET 		:= $(DIR_BIN_DBG)/$(TARGET_NAME)
DBG_FLAGS 		:= -O0 -g3
DBG_OBJS 		:= $(addprefix $(DIR_BUILD_DBG)/,$(OBJ_FILES))


################## SHELL ##################

ifeq ($(OS),Windows_NT)
	MKDIR_P := mkdir
	RM_RF 	:= rmdir /S/Q
else
	MKDIR_P := mkdir -p
	RM_RF 	:= rm -rf
endif


################## RULES ##################

# Default build, Release mode.
default: release


# Check existing project directories
.PHONY: check_directories
check_directories:
	@echo ------------------------- Makefile -------------------------
	@echo [+] Checking project directories...
ifeq ($(filter $(DIR_BUILD_REL),$(wildcard $(DIR_BUILD)/*)),)
	@echo [.]   Creating directory "$(DIR_BUILD_REL)".
ifeq ($(OS),Windows_NT)
	@$(MKDIR_P) $(subst /,\,$(DIR_BUILD_REL))
else
	@$(MKDIR_P) $(DIR_BUILD_REL)
endif
endif
ifeq ($(filter $(DIR_BUILD_DBG),$(wildcard $(DIR_BUILD)/*)),)
	@echo [.]   Creating directory "$(DIR_BUILD_DBG)".
ifeq ($(OS),Windows_NT)
	@$(MKDIR_P) $(subst /,\,$(DIR_BUILD_DBG))
else
	@$(MKDIR_P) $(DIR_BUILD_DBG)
endif
endif
ifeq ($(filter $(DIR_BIN_REL),$(wildcard $(DIR_BIN)/*)),)
	@echo [.]   Creating directory "$(DIR_BIN_REL)".
ifeq ($(OS),Windows_NT)
	@$(MKDIR_P) $(subst /,\,$(DIR_BIN_REL))
else
	@$(MKDIR_P) $(DIR_BIN_REL)
endif
endif
ifeq ($(filter $(DIR_BIN_DBG),$(wildcard $(DIR_BIN)/*)),)
	@echo [.]   Creating directory "$(DIR_BIN_DBG)".
ifeq ($(OS),Windows_NT)
	@$(MKDIR_P) $(subst /,\,$(DIR_BIN_DBG))
else
	@$(MKDIR_P) $(DIR_BIN_DBG)
endif
endif
	@echo [+] OK
	@echo ------------------------------------------------------------


# Release build
.PHONY: release_info release
release_info:
	@echo [+] Building project in Release mode "$(REL_TARGET)"...

release: check_directories release_info $(REL_TARGET)
	@echo [+] OK
	@echo ------------------------------------------------------------
ifeq ($(OS),Windows_NT)
	@echo [?] Type .$(subst /,\,\$(REL_TARGET)) to exectue the program.
else
    @echo [?] Type ./$(REL_TARGET) to exectue the program.
endif
	@echo ------------------------------------------------------------

# Link for Release target.
$(REL_TARGET): $(REL_OBJS)
	@echo [.]   Linking Release objects
ifeq ($(SRC_FILES.cxx),)
	@$(LINK.c) $^ $(EXTRA_LDFLAGS) $(REL_FLAGS) -o $@
else
	@$(LINK.cxx) $^ $(EXTRA_LDFLAGS) $(REL_FLAGS) -o $@
endif

# Compile C source files for Release mode.
$(DIR_BUILD_REL)/%.o: $(DIR_SRC)/%.c
ifeq ($(OS),Windows_NT)
	@if not exist "$(dir $@)" \
	(\
		echo [.]   Creating directory "$(dir $@)" && $(MKDIR_P) "$(subst /,\,$(dir $@))" \
	)
else
	@echo [.]   Creating directory "$(dir $@)"
	@$(MKDIR_P) $(dir $@)
endif
	@echo [.]   Compiling "$<"
	@$(COMPILE.c) $< $(REL_FLAGS) -o $@

# Compile C++ source files for Release mode.
$(DIR_BUILD_REL)/%.o: $(DIR_SRC)/%.cpp
ifeq ($(OS),Windows_NT)
	@if not exist "$(dir $@)" \
	(\
		echo [.]   Creating directory "$(dir $@)" && $(MKDIR_P) "$(subst /,\,$(dir $@))" \
	)
else
	@echo [.]   Creating directory "$(dir $@)"
	@$(MKDIR_P) $(dir $@)
endif
	@echo [.]   Compiling "$<"
	@$(COMPILE.cxx) $< $(REL_FLAGS) -o $@


# Debug mode build
.PHONY: debug_info debug
debug_info:
	@echo [+] Building project in Debug mode "$(DBG_TARGET)"...

debug: check_directories debug_info $(DBG_TARGET)
	@echo [+] OK
	@echo ------------------------------------------------------------

# Link for Debug mode.
$(DBG_TARGET): $(DBG_OBJS)
	@echo [.]   Linking Release objects
ifeq ($(SRC_FILES.cxx),)
	@$(LINK.c) $^ $(EXTRA_LDFLAGS) $(DBG_FLAGS) -o $@
else
	@$(LINK.cxx) $^ $(EXTRA_LDFLAGS) $(DBG_FLAGS) -o $@
endif

# Compile C source files for Debug mode.
$(DIR_BUILD_DBG)/%.o: $(DIR_SRC)/%.c
ifeq ($(OS),Windows_NT)
	@if not exist "$(dir $@)" \
	(\
		echo [.]   Creating directory "$(dir $@)" && $(MKDIR_P) "$(subst /,\,$(dir $@))" \
	)
else
	@echo [.]   Creating directory "$(dir $@)"
	@$(MKDIR_P) $(dir $@)
endif
	@echo [.]   Compiling "$<"
	@$(COMPILE.c) $< $(DBG_FLAGS) -o $@

# Compile C++ source files for Debug mode.
$(DIR_BUILD_DBG)/%.o: $(DIR_SRC)/%.cpp
ifeq ($(OS),Windows_NT)
	@if not exist "$(dir $@)" \
	(\
		echo [.]   Creating directory "$(dir $@)" && $(MKDIR_P) "$(subst /,\,$(dir $@))" \
	)
else
	@echo [.]   Creating directory "$(dir $@)"
	@$(MKDIR_P) $(dir $@)
endif
	@echo [.]   Compiling "$<"
	@$(COMPILE.cxx) $< $(DBG_FLAGS) -o $@


# Clean project, removing bin and build directories
clean:
	@echo ---------------------- Clean project -----------------------
	@echo [+] Cleaning project...
ifeq ($(filter $(DIR_BUILD),$(wildcard *)),$(DIR_BUILD))
	@echo [.]   Deleting directory "$(DIR_BUILD)"
	@$(RM_RF) $(DIR_BUILD)
endif
ifeq ($(filter $(DIR_BIN),$(wildcard *)),$(DIR_BIN))
	@echo [.]   Deleting directory "$(DIR_BIN)"
	@$(RM_RF) $(DIR_BIN)
endif
	@echo [+] OK
	@echo ------------------------------------------------------------


# Display source and object files.
info:
	@echo ---------------------- Project files -----------------------
	@echo [?] OS : $(OS)
	@echo ------------------------------------------------------------
	@echo [+] Release target :
	@echo [.]   $(REL_TARGET)
	@echo ------------------------------------------------------------
	@echo [+] Debug target :
	@echo [.]   $(DBG_TARGET)
	@echo ------------------------------------------------------------
	@echo [+] C source files :
	@echo [.]   $(SRC_FILES.c)
	@echo ------------------------------------------------------------
	@echo [+] C++ source files :
	@echo [.]   $(SRC_FILES.cxx)
	@echo ------------------------------------------------------------
	@echo [+] Release Object files :
	@echo [.]   $(REL_OBJS)
	@echo ------------------------------------------------------------
	@echo [+] Debug Object files :
	@echo [.]   $(DBG_OBJS)
	@echo ------------------------------------------------------------


# Display usage help.
help:
	@echo "USAGE:"
	@echo -e "\tmake \t\t\tBuild project, in Release mode by default."
	@echo -e "\tmake release \t\t\tBuild project, in Release mode."
	@echo -e "\tmake debug \t\tBuild project, in Debug mode."
	@echo -e "\tmake clean \t\tClean project directory."
	@echo -e "\tmake info \t\tDisplay info about files in project directory."
	@echo -e "\tmake version \t\tDisplay compiler version."
	@echo -e "\tmake help \t\tDisplay this help message."


## Version info
.PHONY: version
version:
	@$(CC) -v
