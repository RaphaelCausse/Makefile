# Generic Makefile for C/C++ projects.
# Please follow recommended directory layout in README.
# Author	: Raphael CAUSSE
# Date   	: 08/2022
# OS 		: Linux only


# Directories path set up.
DIR_BIN := bin
DIR_INC := include
DIR_OBJ := obj
DIR_SRC := src

# Compiler and linker.
CC := gcc
CXX := g++
LD := g++

# Linker flags.
LDFLAGS := -I$(DIR_INC)/

# Compiler flags.
CFLAGS := -Wall -Wextra $(LDFLAGS)/
CXXFLAGS := $(CFLAGS)

# Library flags.
LDLIBS := -lm

# Sanitizer flags
FSAN_FLAGS := -fsanitize=address

# Files set up.
TARGET := app
SRCS.c := $(shell find $(DIR_SRC)/ -name "*.c" 2> /dev/null)
SRCS.cpp := $(shell find $(DIR_SRC)/ -name "*.cpp" 2> /dev/null)

# Shell commands.
MKDIR_P := mkdir -p
RM_RF := rm -rf

# Release build set up. 
DIR_BIN_REL := $(DIR_BIN)/release
DIR_OBJ_REL := $(DIR_OBJ)/release
REL_TARGET := $(DIR_BIN_REL)/$(TARGET)
REL_FLAGS := -O3 -DNDEBUG
REL_OBJS := $(patsubst $(DIR_SRC)/%.c,$(DIR_OBJ_REL)/%.o,$(SRCS.c)) \
			$(patsubst $(DIR_SRC)/%.cpp,$(DIR_OBJ_REL)/%.o,$(SRCS.cpp))
DIR_PATH_OBJ_REL := $(sort $(dir $(REL_OBJS)))

# Debug build set up.
DIR_BIN_DBG := $(DIR_BIN)/debug
DIR_OBJ_DBG := $(DIR_OBJ)/debug
DBG_TARGET := $(DIR_BIN_DBG)/$(TARGET)
DBG_FLAGS := -g $(FSAN_FLAGS) -O0 -DDEBUG
DBG_OBJS := $(patsubst $(DIR_SRC)/%.c,$(DIR_OBJ_DBG)/%.o,$(SRCS.c)) \
			$(patsubst $(DIR_SRC)/%.cpp,$(DIR_OBJ_DBG)/%.o,$(SRCS.cpp))
DIR_PATH_OBJ_DBG := $(sort $(dir $(DBG_OBJS)))


# Default build, Release mode.
all: release

# Before build setup, create directories if necessary.
setup:
	@if [ -z "$(SRCS.c)" ] && [ -z "$(SRCS.cpp)" ]; then\
		echo "/!\ [ERROR] : No source files found";\
		exit 1;\
	fi
	@if [ ! -z "$(DIR_BIN_REL)" ] || [ ! -z "$(DIR_BIN_DBG)" ] || [ ! -z "$(DIR_PATH_OBJ_REL)" ] || [ ! -z "$(DIR_PATH_OBJ_DBG)" ]; then\
		echo ":: Create project directories...";\
		$(MKDIR_P) $(DIR_BIN_REL) $(DIR_BIN_DBG) $(DIR_PATH_OBJ_REL) $(DIR_PATH_OBJ_DBG);\
	fi

# Release build
release: setup $(REL_TARGET)

# Link for Release target.
$(REL_TARGET): $(REL_OBJS)
	@echo ":: Build '$@'..."
	@$(LD) $(LDFLAGS) $^ -o $@ $(LDLIBS)
	@echo "==> Done"

# Compile source files for Release mode.
$(DIR_OBJ_REL)/%.o: $(DIR_SRC)/%.c
	@echo ":: Compile '$<'..."
	@$(CC) $(CFLAGS) $(REL_FLAGS) -c $< -o $@

$(DIR_OBJ_REL)/%.o: $(DIR_SRC)/%.cpp
	@echo ":: Compile '$<'..."
	@$(CXX) $(CXXFLAGS) $(REL_FLAGS) -c $< -o $@

# Debug build.
debug: setup $(DBG_TARGET)

# Link for Debug mode.
$(DBG_TARGET): $(DBG_OBJS)
	@echo ":: Build '$@'..."
	@$(LD) $(LDFLAGS) $(FSAN_FLAGS) $^ -o $@ $(LDLIBS)
	@echo "==> Done"

# Compile source files for Debug mode.
$(DIR_OBJ_DBG)/%.o: $(DIR_SRC)/%.c
	@echo ":: Compile '$<'..."
	@$(CC) $(CFLAGS) $(DBG_FLAGS) -c $< -o $@

$(DIR_OBJ_DBG)/%.o: $(DIR_SRC)/%.cpp
	@echo ":: Compile '$<'..."
	@$(CXX) $(CXXFLAGS) $(DBG_FLAGS) -c $< -o $@


# Run release target.
run:
	@echo ":: Run '$(REL_TARGET)'..."
	@./$(REL_TARGET)
	@echo "==> Done"

# Run debug target.
rundbg:
	@echo ":: Run '$(DBG_TARGET)'..."
	@./$(DBG_TARGET)
	@echo "==> Done"

# Remove bin and object directories.
clean:
	@echo ":: Clean project directories..."
	@$(RM_RF) $(DIR_BIN) $(DIR_OBJ)
	@echo "==> Done"

# Display source and object files.
info:
	@echo "[*] Sources, C:"
	@echo -e "\t$(SRCS.c)\n"
	@echo "[*] Sources, C++:"
	@echo -e "\t$(SRCS.cpp)\n"
	@echo "[*] Objects, Release:"
	@echo -e "\t$(REL_OBJS)\n"
	@echo "[*] Target, Release:"
	@echo -e "\t$(REL_TARGET)\n"
	@echo "[*] Objects, Debug:"
	@echo -e "\t$(DBG_OBJS)\n"
	@echo "[*] Target, Debug:"
	@echo -e "\t$(DBG_TARGET)\n"

# Display usage help. 
help:
	@echo "USAGE:"
	@echo "\tmake \t\t\tBuild project, in Release mode by default."
	@echo "\tmake debug \t\tBuild project in Debug mode."
	@echo "\tmake run \t\tRun target, by default Release target."
	@echo "\tmake rundbg \t\tRun Debug target."
	@echo "\tmake clean \t\tClean project directory."
	@echo "\tmake info \t\tDisplay info about files in project directory."
	@echo "\tmake help \t\tDisplay this help message."