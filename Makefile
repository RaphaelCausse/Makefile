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

# Include directories
INCLUDES 	:= src

# OS specific includes
INCLUDES_LINUX 	 := 
INCLUDES_WINDOWS := C:/MinGW/include \
					C:/MinGW/mingw32/lib \
					C:/MinGW/mingw32/include \
					C:/MinGW/lib/gcc/mingw32/6.3.0/include

ifeq ($(OS),Windows_NT)
INCLUDES += $(INCLUDES_WINDOWS)
else
INCLUDES += $(INCLUDES_LINUX)
endif

# Link libraries
LIBS 		:=

# OS specific libraries
LIBS_LINUX 	 := 
LIBS_WINDOWS := ws2_32

ifeq ($(OS),Windows_NT)
LIBS += $(LIBS_WINDOWS)
else
LIBS += $(LIBS_LINUX)
endif


################ COMPILER ################

# Compiler and linker.
CC 		:= gcc
CXX 	:= g++

# Comment this line if you are using only C or only C++.
# Un-comment this line if you are using both C and C++.
# CC 		= $(CXX)

# Extra Compiler options, applies to both C and C++ compiling as well as LD.
EXTRA_CFLAGS 	= 
# Extra Linker options (e.g. -lm)
EXTRA_LDFLAGS 	= $(addprefix -l,$(LIBS))

# C Preprocessor options 
CPPFLAGS 		= -Wall -Wextra -Wpedantic $(addprefix -I,$(INCLUDES))

# Shortcuts for compiler and linker
COMPILE.c 		= $(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(CPPFLAGS) -c
COMPILE.cxx 	= $(CXX) $(CXXFLAGS) $(EXTRA_CFLAGS) $(CPPFLAGS) -c
LINK.c 			= $(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(CPPFLAGS) $(LDFLAGS)
LINK.cxx 		= $(CXX) $(CXXFLAGS) $(EXTRA_CFLAGS) $(CPPFLAGS) $(LDFLAGS)


# Source files and object files set up.
include $(DIR_SRC)/sources.mk
SRC_FILES.c := $(filter %.c,$(addprefix $(DIR_SRC)/,$(filter-out \,$(SOURCES))))
SRC_FILES.cxx := $(filter %.cpp,$(addprefix $(DIR_SRC)/,$(filter-out \,$(SOURCES))))
OBJ_FILES := $(addsuffix .o,$(basename $(filter-out \,$(SOURCES))))

# Release build set up. 
DIR_BIN_RELEASE 	:= $(DIR_BIN)/release
DIR_BUILD_RELEASE 	:= $(DIR_BUILD)/release
RELEASE_TARGET 		:= $(DIR_BIN_RELEASE)/$(TARGET_NAME)
RELEASE_FLAGS 		:= -O2
RELEASE_OBJS 		:= $(addprefix $(DIR_BUILD_RELEASE)/,$(OBJ_FILES))

# Debug build set up.
DIR_BIN_DEBUG 		:= $(DIR_BIN)/debug
DIR_BUILD_DEBUG 	:= $(DIR_BUILD)/debug
DEBUG_TARGET 		:= $(DIR_BIN_DEBUG)/$(TARGET_NAME)
DEBUG_FLAGS 		:= -O0 -g3
DEBUG_OBJS		:= $(addprefix $(DIR_BUILD_DEBUG)/,$(OBJ_FILES))


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
	@echo ======================= Directories ========================
	@echo [+] Checking project directories...
ifeq ($(filter $(DIR_BUILD_RELEASE),$(wildcard $(DIR_BUILD)/*)),)
	@echo [.]   Creating directory "$(DIR_BUILD_RELEASE)".
ifeq ($(OS),Windows_NT)
	@$(MKDIR_P) $(subst /,\,$(DIR_BUILD_RELEASE))
else
	@$(MKDIR_P) $(DIR_BUILD_RELEASE)
endif
endif
ifeq ($(filter $(DIR_BUILD_DEBUG),$(wildcard $(DIR_BUILD)/*)),)
	@echo [.]   Creating directory "$(DIR_BUILD_DEBUG)".
ifeq ($(OS),Windows_NT)
	@$(MKDIR_P) $(subst /,\,$(DIR_BUILD_DEBUG))
else
	@$(MKDIR_P) $(DIR_BUILD_DEBUG)
endif
endif
ifeq ($(filter $(DIR_BIN_RELEASE),$(wildcard $(DIR_BIN)/*)),)
	@echo [.]   Creating directory "$(DIR_BIN_RELEASE)".
ifeq ($(OS),Windows_NT)
	@$(MKDIR_P) $(subst /,\,$(DIR_BIN_RELEASE))
else
	@$(MKDIR_P) $(DIR_BIN_RELEASE)
endif
endif
ifeq ($(filter $(DIR_BIN_DEBUG),$(wildcard $(DIR_BIN)/*)),)
	@echo [.]   Creating directory "$(DIR_BIN_DEBUG)".
ifeq ($(OS),Windows_NT)
	@$(MKDIR_P) $(subst /,\,$(DIR_BIN_DEBUG))
else
	@$(MKDIR_P) $(DIR_BIN_DEBUG)
endif
endif
	@echo [+] OK
	@echo ============================================================


# Release build
.PHONY: release_info release
release_info:
	@echo ====================== Build Release =======================
	@echo [+] Building project in Release mode "$(RELEASE_TARGET)"...

release: check_directories release_info $(RELEASE_TARGET)
	@echo [+] OK
	@echo ============================================================
ifeq ($(OS),Windows_NT)
	@echo [?] Type .$(subst /,\,\$(RELEASE_TARGET)) to exectue the program.
else
	@echo [?] Type ./$(RELEASE_TARGET) to exectue the program.
endif
	@echo ============================================================

# Link for Release target.
$(RELEASE_TARGET): $(RELEASE_OBJS)
	@echo [.]   Linking Release objects
ifeq ($(SRC_FILES.cxx),)
	@$(LINK.c) $^ $(EXTRA_LDFLAGS) $(RELEASE_FLAGS) -o $@
else
	@$(LINK.cxx) $^ $(EXTRA_LDFLAGS) $(RELEASE_FLAGS) -o $@
endif

# Compile C source files for Release mode.
$(DIR_BUILD_RELEASE)/%.o: $(DIR_SRC)/%.c
ifeq ($(OS),Windows_NT)
	@if not exist "$(dir $@)" (\
		echo [.]   Creating directory "$(dir $@)" && $(MKDIR_P) "$(subst /,\,$(dir $@))" \
	)
else
	@echo [.]   Creating directory "$(dir $@)"
	@$(MKDIR_P) $(dir $@)
endif
	@echo [.]   Compiling "$<"
	@$(COMPILE.c) $< $(RELEASE_FLAGS) -o $@

# Compile C++ source files for Release mode.
$(DIR_BUILD_RELEASE)/%.o: $(DIR_SRC)/%.cpp
ifeq ($(OS),Windows_NT)
	@if not exist "$(dir $@)" (\
		echo [.]   Creating directory "$(dir $@)" && $(MKDIR_P) "$(subst /,\,$(dir $@))" \
	)
else
	@echo [.]   Creating directory "$(dir $@)"
	@$(MKDIR_P) $(dir $@)
endif
	@echo [.]   Compiling "$<"
	@$(COMPILE.cxx) $< $(RELEASE_FLAGS) -o $@


# Debug mode build
.PHONY: debug_info debug
debug_info:
	@echo ======================= Build Debug ========================
	@echo [+] Building project in Debug mode "$(DEBUG_TARGET)"...

debug: check_directories debug_info $(DEBUG_TARGET)
	@echo [+] OK
	@echo ============================================================
ifeq ($(OS),Windows_NT)
	@echo [?] Type .$(subst /,\,\$(DEBUG_TARGET)) to exectue the program.
else
	@echo [?] Type ./$(DEBUG_TARGET) to exectue the program.
endif
	@echo ============================================================

# Link for Debug mode.
$(DEBUG_TARGET): $(DEBUG_OBJS)
	@echo [.]   Linking Release objects
ifeq ($(SRC_FILES.cxx),)
	@$(LINK.c) $^ $(EXTRA_LDFLAGS) $(DEBUG_FLAGS) -o $@
else
	@$(LINK.cxx) $^ $(EXTRA_LDFLAGS) $(DEBUG_FLAGS) -o $@
endif

# Compile C source files for Debug mode.
$(DIR_BUILD_DEBUG)/%.o: $(DIR_SRC)/%.c
ifeq ($(OS),Windows_NT)
	@if not exist "$(dir $@)" (\
		echo [.]   Creating directory "$(dir $@)" && $(MKDIR_P) "$(subst /,\,$(dir $@))" \
	)
else
	@echo [.]   Creating directory "$(dir $@)"
	@$(MKDIR_P) $(dir $@)
endif
	@echo [.]   Compiling "$<"
	@$(COMPILE.c) $< $(DEBUG_FLAGS) -o $@

# Compile C++ source files for Debug mode.
$(DIR_BUILD_DEBUG)/%.o: $(DIR_SRC)/%.cpp
ifeq ($(OS),Windows_NT)
	@if not exist "$(dir $@)" (\
		echo [.]   Creating directory "$(dir $@)" && $(MKDIR_P) "$(subst /,\,$(dir $@))" \
	)
else
	@echo [.]   Creating directory "$(dir $@)"
	@$(MKDIR_P) $(dir $@)
endif
	@echo [.]   Compiling "$<"
	@$(COMPILE.cxx) $< $(DEBUG_FLAGS) -o $@


# Clean project, removing bin and build directories
clean:
	@echo ====================== Clean project =======================
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
	@echo ============================================================


# Display source and object files.
info:
	@echo ========================= Project ==========================
	@echo [?] OS : $(OS)
	@echo [?] Target : $(TARGET_NAME)
	@echo ============================================================
	@echo [+] C source files (.c) :
	@echo [.]   $(SRC_FILES.c)
	@echo [.] --------------------------------------------------------
	@echo [+] C++ source files (.cpp) :
	@echo [.]   $(SRC_FILES.cxx)
	@echo [.] --------------------------------------------------------
	@echo [+] Object files, Release :
	@echo [.]   $(RELEASE_OBJS)
	@echo [.] --------------------------------------------------------
	@echo [+] Object files, Debug :
	@echo [.]   $(DEBUG_OBJS)
	@echo ============================================================


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
	@$(CC) --version
	@$(CC) -v
