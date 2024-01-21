###########################################
# Makefile template for C/C++ projects.
# Please follow recommended project layout in README.
# Author : Raphael CAUSSE
# Date : 08/2022
###########################################

# Target executable name
TARGET_NAME := prog

ifeq ($(OS),Windows_NT)
TARGET_NAME := $(addsuffix .exe,$(TARGET_NAME))
endif


################## PATHS ##################

# Directories path set up.
DIR_BIN 	:= bin
DIR_BUILD 	:= build
DIR_SRC 	:= src

# Sources list file, where all source files to compile should be declared, without the "src/" path prefix.
SOURCES_FILE_MK := sources.mk
SRC_FILE_MK_START_CMT := \# C/C++ source files

# Include directories, indicate where to search for included header files. It should contain the space-separated list of directories where header files can be found.
INCLUDES		:= src
# OS specific includes. Might defer depending your system configuration.
INCLUDES_LINUX		:=
INCLUDES_WINDOWS	:=
ifeq ($(OS),Windows_NT)
INCLUDES += $(INCLUDES_WINDOWS)
else
INCLUDES += $(INCLUDES_LINUX)
endif

# Libraries to link, given by their name without the "lib". It should contain the space-separated list of libraries that are used by your programs.
LIBS		:= m
# OS specific libraries
LIBS_LINUX  	:=
LIBS_WINDOWS	:= ws2_32
ifeq ($(OS),Windows_NT)
LIBS += $(LIBS_WINDOWS)
else
LIBS += $(LIBS_LINUX)
endif

# Libraries directories, specify the linker where to search for the libraries. It should contain the space-separated list of directories where libraries can be found.
LIBS_DIRS	:= 
# OS specific libraries directories
LIBS_DIRS_LINUX 	:=
LIBS_DIRS_WINDOWS 	:=
ifeq ($(OS),Windows_NT)
LIBS_DIRS += $(LIBS_DIRS_WINDOWS)
else
LIBS_DIRS += $(LIBS_DIRS_LINUX)
endif


################ COMPILER ################

# Compiler and linker for both C and C++.
CC      := gcc --std=c99
CXX     := g++

# /!\ Comment this line if you are using only C or only C++. Un-comment this line if you are using both C and C++.
# CC 		= $(CXX)

# Compiler options, applies to both C and C++ compiling as well as LD.
CFLAGS			= -Wall -Wextra -Wpedantic
# Extra Compiler options, applies to both C and C++ compiling as well as LD.
EXTRA_CFLAGS    =

# C Preprocessor options, to include directories.
CPPFLAGS        = $(addprefix -I,$(INCLUDES))

# Linker options, to indicate where to search for linked libraries.
LDFLAGS 		= $(addprefix -L,$(LIBS_DIRS))
# Extra Linker options, to link libraries.
EXTRA_LDFLAGS   = $(addprefix -l,$(LIBS))


# Shortcuts for compiler and linker
COMPILE.c       = $(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(CPPFLAGS) -c
COMPILE.cxx     = $(CXX) $(CXXFLAGS) $(EXTRA_CFLAGS) $(CPPFLAGS) -c
LINK.c          = $(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(CPPFLAGS) $(LDFLAGS)
LINK.cxx        = $(CXX) $(CXXFLAGS) $(EXTRA_CFLAGS) $(CPPFLAGS) $(LDFLAGS)


# Source files and object files set up.
-include $(DIR_SRC)/$(SOURCES_FILE_MK)
SRC_FILES.c   := $(filter %.c,$(addprefix $(DIR_SRC)/,$(filter-out \,$(SOURCES))))
SRC_FILES.cxx := $(filter %.cpp,$(addprefix $(DIR_SRC)/,$(filter-out \,$(SOURCES))))
OBJ_FILES     := $(addsuffix .o,$(basename $(filter-out \,$(SOURCES))))


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
DEBUG_OBJS     		:= $(addprefix $(DIR_BUILD_DEBUG)/,$(OBJ_FILES))


################## SHELL ##################

ifeq ($(OS),Windows_NT)
MKDIR_P := mkdir
RM_RF   := rmdir /S/Q
CAT 	:= type
else
MKDIR_P := mkdir -p
RM_RF   := rm -rf
CAT 	:= cat
endif


################## RULES ##################

# Default build, Release mode.
default: release


# Initialize project layout
.PHONY: init
init:
	@echo ======================== Initialize ========================
	@echo [+] Initialize project layout...
ifeq ($(filter $(DIR_SRC),$(wildcard *)),)
ifeq ($(OS),Windows_NT)
	@echo [.]   Creating directory "$(DIR_SRC)"
	@$(MKDIR_P) $(subst /,\,$(DIR_SRC))
else
	@echo "[.]   Creating directory '$(DIR_SRC)'"
	@$(MKDIR_P) $(DIR_SRC)
endif
endif
ifeq ($(filter $(DIR_SRC)/$(SOURCES_FILE_MK),$(wildcard $(DIR_SRC)/*)),)
ifeq ($(OS),Windows_NT)
	@echo [.]   Creating file "$(DIR_SRC)/$(SOURCES_FILE_MK)"
	@echo # Declare all source files in the SOURCES variable, with "src" as the relative root. > $(subst /,\,$(DIR_SRC)/$(SOURCES_FILE_MK))
	@echo # Write source files names on one line, or on multiple lines by adding a backslash at the end and going on a new line. >> $(subst /,\,$(DIR_SRC)/$(SOURCES_FILE_MK))
	@echo SOURCES := >> $(subst /,\,$(DIR_SRC)/$(SOURCES_FILE_MK))
else
	@echo "[.]   Creating file '$(DIR_SRC)/$(SOURCES_FILE_MK)'"
	@echo "# Declare all source files in the SOURCES variable, with 'src' as the relative root." > $(subst /,\,$(DIR_SRC)/$(SOURCES_FILE_MK))
	@echo "# Write source files names on one line, or on multiple lines by adding a backslash at the end and going on a new line." >> $(subst /,\,$(DIR_SRC)/$(SOURCES_FILE_MK))
	@echo "SOURCES := " >> $(DIR_SRC)/$(SOURCES_FILE_MK)
endif
endif
	@echo [+] OK
	@echo ============================================================
ifeq ($(OS),Windows_NT)
	@echo [?] Declare all the source files in the "$(DIR_SRC)/$(SOURCES_FILE_MK)" file.
else
	@echo "[?] Declare all the source files in the '$(DIR_SRC)/$(SOURCES_FILE_MK)' file."
endif
	@echo ============================================================


# Check existing project directories
.PHONY: check_directories
check_directories:
	@echo ======================= Directories ========================
	@echo [+] Checking project directories...
ifeq ($(filter $(DIR_BUILD_RELEASE),$(wildcard $(DIR_BUILD)/*)),)
ifeq ($(OS),Windows_NT)
	@echo [.]   Creating directory "$(DIR_BUILD_RELEASE)"
	@$(MKDIR_P) $(subst /,\,$(DIR_BUILD_RELEASE))
else
	@echo "[.]   Creating directory '$(DIR_BUILD_RELEASE)'"
	@$(MKDIR_P) $(DIR_BUILD_RELEASE)
endif
endif
ifeq ($(filter $(DIR_BUILD_DEBUG),$(wildcard $(DIR_BUILD)/*)),)
ifeq ($(OS),Windows_NT)
	@echo [.]   Creating directory "$(DIR_BUILD_DEBUG)"
	@$(MKDIR_P) $(subst /,\,$(DIR_BUILD_DEBUG))
else
	@echo "[.]   Creating directory '$(DIR_BUILD_DEBUG)'"
	@$(MKDIR_P) $(DIR_BUILD_DEBUG)
endif
endif
ifeq ($(filter $(DIR_BIN_RELEASE),$(wildcard $(DIR_BIN)/*)),)
ifeq ($(OS),Windows_NT)
	@echo [.]   Creating directory "$(DIR_BIN_RELEASE)"
	@$(MKDIR_P) $(subst /,\,$(DIR_BIN_RELEASE))
else
	@echo "[.]   Creating directory '$(DIR_BIN_RELEASE)'"
	@$(MKDIR_P) $(DIR_BIN_RELEASE)
endif
endif
ifeq ($(filter $(DIR_BIN_DEBUG),$(wildcard $(DIR_BIN)/*)),)
ifeq ($(OS),Windows_NT)
	@echo [.]   Creating directory "$(DIR_BIN_DEBUG)"
	@$(MKDIR_P) $(subst /,\,$(DIR_BIN_DEBUG))
else
	@echo "[.]   Creating directory '$(DIR_BIN_DEBUG)'"
	@$(MKDIR_P) $(DIR_BIN_DEBUG)
endif
endif
	@echo [+] OK
	@echo ============================================================


# Release pre-build
.PHONY: release_info release
release_info:
	@echo ====================== Build Release =======================
ifeq ($(SOURCES),)
ifeq ($(OS),Windows_NT)
	@echo [!] No source files declared in "$(SOURCES_FILE_MK)"
else
	@echo "[!] No source files declared in '$(SOURCES_FILE_MK)'"
endif
	@echo.
endif
ifeq ($(OS),Windows_NT)
	@echo [+] Building project in Release mode...
else
	@echo "[+] Building project in Release mode..."
endif

# Release build
release: check_directories release_info $(RELEASE_TARGET)
ifeq ($(OS),Windows_NT)
	@echo [?] Type ".\$(subst /,\,$(RELEASE_TARGET))" to exectue the program.
else
	@echo "[?] Type './$(RELEASE_TARGET)' to exectue the program."
endif
	@echo ============================================================

# Link object files for Release target.
$(RELEASE_TARGET): $(RELEASE_OBJS)
ifeq ($(OS),Windows_NT)
	@echo [.]   Linking Release objects into "$(RELEASE_TARGET)"
else
	@echo "[.]   Linking Release objects into '$(RELEASE_TARGET)'"
endif
ifeq ($(SRC_FILES.cxx),)
	@$(LINK.c) $(RELEASE_FLAGS) $^ $(EXTRA_LDFLAGS) -o $@
else
	@$(LINK.cxx) $(RELEASE_FLAGS) $^ $(EXTRA_LDFLAGS) -o $@
endif
	@echo [+] OK
	@echo ============================================================

# Compile C source files for Release build.
$(DIR_BUILD_RELEASE)/%.o: $(DIR_SRC)/%.c
ifeq ($(OS),Windows_NT)
	@if not exist "$(dir $@)" (\
		echo [.]   Creating directory "$(dir $@)" && $(MKDIR_P) "$(subst /,\,$(dir $@))" \
	)
	@echo [.]   Compiling "$<"
else
	@echo "[.]   Creating directory '$(dir $@)'"
	@$(MKDIR_P) $(dir $@)
	@echo "[.]   Compiling '$<'"
endif
	@$(COMPILE.c) $(RELEASE_FLAGS) $< -o $@

# Compile C++ source files for Release build.
$(DIR_BUILD_RELEASE)/%.o: $(DIR_SRC)/%.cpp
ifeq ($(OS),Windows_NT)
	@if not exist "$(dir $@)" (\
		echo [.]   Creating directory "$(dir $@)" && $(MKDIR_P) "$(subst /,\,$(dir $@))" \
	)
	@echo [.]   Compiling "$<"
else
	@echo "[.]   Creating directory '$(dir $@)'"
	@$(MKDIR_P) $(dir $@)
	@echo "[.]   Compiling '$<'"
endif
	@$(COMPILE.cxx) $(RELEASE_FLAGS) $< -o $@


# Debug pre-build
.PHONY: debug_info debug
debug_info:
	@echo ======================= Build Debug ========================
ifeq ($(SOURCES),)
ifeq ($(OS),Windows_NT)
	@echo [!] No source files declared in "$(SOURCES_FILE_MK)".
else
	@echo "[!] No source files declared in '$(SOURCES_FILE_MK)'."
endif
	@echo.
endif
ifeq ($(OS),Windows_NT)
	@echo [+] Building project in Release mode...
else
	@echo "[+] Building project in Debug mode..."
endif

# Debug build
debug: check_directories debug_info $(DEBUG_TARGET) cleanobj
ifeq ($(OS),Windows_NT)
	@echo [?] Type ".\$(subst /,\,$(DEBUG_TARGET))" to exectue the program.
else
	@echo "[?] Type './$(DEBUG_TARGET)' to exectue the program."
endif
	@echo ============================================================

# Link objects files for Debug target.
$(DEBUG_TARGET): $(DEBUG_OBJS)
ifeq ($(OS),Windows_NT)
	@echo [.]   Linking Debug objects into "$(DEBUG_TARGET)"
else
	@echo "[.]   Linking Debug objects into '$(DEBUG_TARGET)'"
endif
ifeq ($(SRC_FILES.cxx),)
	@$(LINK.c) $(DEBUG_FLAGS) $^ $(EXTRA_LDFLAGS) -o $@
else
	@$(LINK.cxx) $(DEBUG_FLAGS) $^ $(EXTRA_LDFLAGS) -o $@
endif
	@echo [+] OK
	@echo ============================================================

# Compile C source files for Debug build.
$(DIR_BUILD_DEBUG)/%.o: $(DIR_SRC)/%.c
ifeq ($(OS),Windows_NT)
	@if not exist "$(dir $@)" (\
		echo [.]   Creating directory "$(dir $@)" && $(MKDIR_P) "$(subst /,\,$(dir $@))" \
	)
	@echo [.]   Compiling "$<"
else
	@echo "[.]   Creating directory '$(dir $@)'"
	@$(MKDIR_P) $(dir $@)
	@echo "[.]   Compiling '$<'"
endif
	@$(COMPILE.c) $(DEBUG_FLAGS) $< -o $@

# Compile C++ source files for Debug build.
$(DIR_BUILD_DEBUG)/%.o: $(DIR_SRC)/%.cpp
ifeq ($(OS),Windows_NT)
	@if not exist "$(dir $@)" (\
		echo [.]   Creating directory "$(dir $@)" && $(MKDIR_P) "$(subst /,\,$(dir $@))" \
	)
	@echo [.]   Compiling "$<"
else
	@echo "[.]   Creating directory '$(dir $@)'"
	@$(MKDIR_P) $(dir $@)
	@echo "[.]   Compiling '$<'"
endif
	@$(COMPILE.cxx) $(DEBUG_FLAGS) $< -o $@


# Clean project, removing bin and build directories
.PHONY: clean
clean:
	@echo ====================== Clean project =======================
	@echo [+] Cleaning project...
ifeq ($(filter $(DIR_BUILD),$(wildcard *)),$(DIR_BUILD))
ifeq ($(OS),Windows_NT)
	@echo [.]   Deleting directory "$(DIR_BUILD)"
else
	@echo "[.]   Deleting directory '$(DIR_BUILD)'"
endif
	@$(RM_RF) $(DIR_BUILD)
endif
ifeq ($(filter $(DIR_BIN),$(wildcard *)),$(DIR_BIN))
ifeq ($(OS),Windows_NT)
	@echo [.]   Deleting directory "$(DIR_BIN)"
else
	@echo "[.]   Deleting directory '$(DIR_BIN)'"
endif
	@$(RM_RF) $(DIR_BIN)
endif
	@echo [+] OK
	@echo ============================================================

# Clean objects, removing build directories
.PHONY: cleanobj
cleanobj:
	@echo ====================== Clean objects =======================
	@echo [+] Cleaning objects files...
ifeq ($(filter $(DIR_BUILD),$(wildcard *)),$(DIR_BUILD))
ifeq ($(OS),Windows_NT)
	@echo [.]   Deleting directory "$(DIR_BUILD)"
else
	@echo "[.]   Deleting directory '$(DIR_BUILD)'"
endif
	@$(RM_RF) $(DIR_BUILD)
endif
	@echo [+] OK
	@echo ============================================================


# Run the release executable with no arguments
.PHONY: run
run:
ifneq ($(filter $(RELEASE_TARGET),$(wildcard $(DIR_BIN_RELEASE)/*)),)
	@$(RELEASE_TARGET)
else
ifeq ($(OS),Windows_NT)
	@echo [!] No executable "$(RELEASE_TARGET)" found.
	@echo [!] Try to compile using the command "make release".
else
	@echo "[!] No executable '$(RELEASE_TARGET)' found."
	@echo "[!] Try to compile using the command 'make release'."
endif
endif



# Run the debug executable with no arguments
.PHONY: run-debug
run-debug:
ifneq ($(filter $(DEBUG_TARGET),$(wildcard $(DIR_BIN_DEBUG)/*)),)
	@$(DEBUG_TARGET)
else
ifeq ($(OS),Windows_NT)
	@echo [!] No executable "$(DEBUG_TARGET)" found.
	@echo [!] Try to compile using the command "make debug".
else
	@echo "[!] No executable '$(DEBUG_TARGET)' found."
	@echo "[!] Try to compile using the command 'make debug'."
endif
endif

# Update the sources.mk with .c & .cpp which are in src folder
cpt := 0
.PHONY: upt-src
upt-src:
ifneq ($(filter $(DIR_SRC)/$(SOURCES_FILE_MK),$(wildcard $(DIR_SRC)/*)),)
ifeq ($(OS),Windows_NT)
ifeq ($(findstring powershell.exe,$(SHELL)),powershell.exe)
# make command comes from a PowerShell
	@echo [.]   (Pas fini) Updating "$(SOURCES_FILE_MK)" using PowerShell...
	@Get-ChildItem -Path "$(DIR_SRC)" -Recurse -Filter *.c,*.cpp | ForEach-Object { echo SOURCES += $$_.FullName.Replace('$(DIR_SRC)\', '.') }
else
# make command comes from a CMD	
	@echo [.] Updating "$(SOURCES_FILE_MK)" using CMD...
	@echo. > tmp.txt
	@echo $(SRC_FILE_MK_START_CMT)> "$(DIR_SRC)/$(SOURCES_FILE_MK)"
	@for /r "$(DIR_SRC)" %%i in (*.c,*.cpp) do ( \
		set /a cpt+=1 && \
		@setlocal enabledelayedexpansion && \
		set "srcPath=%%i" && \
		set "srcPath=!srcPath:\=/!" && \
		set "srcPath=!srcPath:$(CURDIR)/$(DIR_SRC)/=!" && \
		set "srcPath=!srcPath!" && \
		(if !cpt! equ 1 ( \
			set "srcLine=SOURCES := !srcPath! \" \
		) else ( \
			set "srcLine=!srcPath! \" \
		)) && \
		echo !srcLine!>>"$(DIR_SRC)/$(SOURCES_FILE_MK)"&&\
		endlocal \
	)
	@del tmp.txt
	@echo [.] $(SOURCES_FILE_MK) Update complete.
	@echo ====================== $(SOURCES_FILE_MK) ==========================
	@$(CAT) "$(DIR_SRC)\$(SOURCES_FILE_MK)"
	@echo ============================================================
endif
else
	@echo [.]  (Pas fini) Updating "$(SOURCES_FILE_MK)"...
	@find $(DIR_SRC) -type f \( -name '*.c' -or -name '*.cpp' \) -exec echo SOURCES += {} \; | sed 's|$(DIR_SRC)/|./|g' 
endif
else
ifeq ($(OS),Windows_NT)
	@echo [!] No src folder nor sources.mk "$(SOURCES_FILE_MK)" found.
	@echo [!] Try to initialize the project using the command "make init".
else
	@echo "[!] No src folder nor sources.mk '$(SOURCES_FILE_MK)' found."
	@echo "[!] Try to initialize the project using the command 'make init'."
endif
endif


# Display source and object files.
.PHONY: info
info:
	@echo ========================= Project ==========================
ifeq ($(OS),Windows_NT)
	@echo [?] OS : $(OS)
	@echo [?] Target : "$(TARGET_NAME)" in "$(DIR_BIN_RELEASE)/" or "$(DIR_BIN_DEBUG)/"
else
	@echo "[?] OS : $(shell uname)"
	@echo "[?] Target : '$(TARGET_NAME)' in '$(DIR_BIN_RELEASE)/' or '$(DIR_BIN_DEBUG)/'"
endif
	@echo ============================================================
ifeq ($(OS),Windows_NT)
	@echo [+] C source files (.c) :
	@echo [.]   $(SRC_FILES.c)
	@echo [.]---------------------------------------------------------
	@echo [+] C++ source files (.cpp) :
	@echo [.]   $(SRC_FILES.cxx)
	@echo [.]---------------------------------------------------------
	@echo [+] Object files, Release :
	@echo [.]   $(RELEASE_OBJS)
	@echo [.]---------------------------------------------------------
	@echo [+] Object files, Debug :
	@echo [.]   $(DEBUG_OBJS)
else
	@echo "[+] C source files (.c) :"
	@echo "[.]   $(SRC_FILES.c)"
	@echo [.]---------------------------------------------------------
	@echo "[+] C++ source files (.cpp) :"
	@echo "[.]   $(SRC_FILES.cxx)"
	@echo [.]---------------------------------------------------------
	@echo [+] Object files, Release :
	@echo "[.]   $(RELEASE_OBJS)"
	@echo [.]---------------------------------------------------------
	@echo [+] Object files, Debug :
	@echo "[.]   $(DEBUG_OBJS)"
endif
	@echo ============================================================


# Display usage help.
.PHONY: help
help:
	@echo ========================== Help ============================
ifeq ($(OS),Windows_NT)
	@echo Usage:
	@echo     make             Build project, in Release mode by default.
	@echo     make release     Build project, in Release mode.
	@echo     make debug       Build project, in Debug mode.
	@echo     make clean       Clean project, remove directories '$(DIR_BIN)' and '$(DIR_BUILD)'.
	@echo     make cleanobj    Clean project, remove directory '$(DIR_BUILD)'.
	@echo     make info        Display info about files in project.
	@echo     make version     Display compilers version.
	@echo     make help        Display this help message.
else
	@echo "Usage:"
	@echo -e "\tmake \t\tBuild project, in Release mode by default."
	@echo -e "\tmake release \tBuild project, in Release mode."
	@echo -e "\tmake debug \tBuild project, in Debug mode."
	@echo -e "\tmake clean \tClean project, remove directories '$(DIR_BIN)' and '$(DIR_BUILD)'."
	@echo -e "\tmake clean \tClean project, remove directory '$(DIR_BUILD)'."
	@echo -e "\tmake info \tDisplay info about files in project directory."
	@echo -e "\tmake version \tDisplay compiler version."
	@echo -e "\tmake help \tDisplay this help message."
endif
	@echo ============================================================


## Version info
.PHONY: version
version:
	@$(CC) --version
	@$(CXX) --version
