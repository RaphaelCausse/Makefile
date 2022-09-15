# Generic Makefile for C/C++ projects.
# Author : Raphael CAUSSE
# Date   : 08/2022


# Directories path set up.
#
DIR_BIN := bin
DIR_SRC := src
DIR_OBJ := obj
DIR_INC := include

# Compiler and linker.
#
CC := clang
CXX := clang++
LD := clang++

# Compiler flags.
#
CFLAGS := -Wall -Wextra -I$(DIR_INC)/
CXXFLAGS := -Wall -Wextra -I$(DIR_INC)/

# Sanitizer flags
#
FSAN_FLAGS := -fsanitize=address

# Linker flags.
#
LDFLAGS := -I$(DIR_INC)/

# Library flags.
#
LDLIBS := -lm

# Files set up.
#
TARGET := app
SRCS.c := $(shell find $(DIR_SRC)/ -name "*.c" 2> /dev/null)
SRCS.cpp := $(shell find $(DIR_SRC)/ -name "*.cpp" 2> /dev/null)

# Shell commands.
#
MKDIR_P := mkdir -p
RM := rm -rf

# Release build set up. 
#
DIR_BIN_REL := $(DIR_BIN)/release
DIR_OBJ_REL := $(DIR_OBJ)/release
REL_TARGET := $(DIR_BIN_REL)/$(TARGET)
REL_FLAGS := -O2 -DNDEBUG
REL_OBJS := $(patsubst $(DIR_SRC)/%.c,$(DIR_OBJ_REL)/%.o,$(SRCS.c)) \
			$(patsubst $(DIR_SRC)/%.cpp,$(DIR_OBJ_REL)/%.o,$(SRCS.cpp))
DIR_PATH_OBJ_REL := $(dir $(REL_OBJS))

# Debug build set up.
#
DIR_BIN_DBG := $(DIR_BIN)/debug
DIR_OBJ_DBG := $(DIR_OBJ)/debug
DBG_TARGET := $(DIR_BIN_DBG)/$(TARGET)
DBG_FLAGS := -g $(FSAN_ADDRESS) -O0 -DDEBUG
DBG_OBJS := $(patsubst $(DIR_SRC)/%.c,$(DIR_OBJ_DBG)/%.o,$(SRCS.c)) \
			$(patsubst $(DIR_SRC)/%.cpp,$(DIR_OBJ_DBG)/%.o,$(SRCS.cpp))
DIR_PATH_OBJ_DBG := $(dir $(DBG_OBJS))


# Default build, Release mode.
#
all: release

# Before build, create directories if necessary.
#
prep:
	@echo ":: Create project directories ..."
	@$(MKDIR_P) $(DIR_BIN_REL) $(DIR_BIN_DBG) $(DIR_PATH_OBJ_REL) $(DIR_PATH_OBJ_DBG)

# Release build
#
release: prep $(REL_TARGET)

# Linking for Release target.
#
$(REL_TARGET): $(REL_OBJS)
	@echo ":: Build '$@' ..."
	$(LD) $(LDFLAGS) $^ -o $@ $(LDLIBS)
	@echo "==> Done"

# Compiling source files for Release mode.
#
$(DIR_OBJ_REL)/%.o: $(DIR_SRC)/%.c
	@echo ":: Compile '$<' ..."
	$(CC) $(CFLAGS) $(REL_FLAGS) -c $< -o $@

$(DIR_OBJ_REL)/%.o: $(DIR_SRC)/%.cpp
	@echo ":: Compile '$<' ..."
	$(CXX) $(CXXFLAGS) $(REL_FLAGS) -c $< -o $@

# Debug build.
#
debug: prep $(DBG_TARGET)

# Linking for Debug mode.
#
$(DBG_TARGET): $(DBG_OBJS)
	@echo ":: Build '$@' ..."
	$(LD) $(LDFLAGS) $(FSAN_ADDRESS) $^ -o $@ $(LDLIBS)
	@echo "==> Done"

# Compiling source files for Debug mode.
#
$(DIR_OBJ_DBG)/%.o: $(DIR_SRC)/%.c
	@echo ":: Compile '$<' ..."
	$(CC) $(CFLAGS) $(DBG_FLAGS) -c $< -o $@

$(DIR_OBJ_DBG)/%.o: $(DIR_SRC)/%.cpp
	@echo ":: Compile '$<' ..."
	$(CXX) $(CXXFLAGS) $(DBG_FLAGS) -c $< -o $@


# Run release target.
#
run:
	@echo ":: Run '$(REL_TARGET)' ..."
	./$(REL_TARGET)

# Run debug target.
#
run-debug:
	@echo ":: Run '$(DBG_TARGET)' ..."
	./$(DBG_TARGET)

# Remove target and object files.
#
clean:
	@echo ":: Clean project directory ..."
	$(RM) $(DIR_BIN) $(DIR_OBJ)

# Display source and object files.
#
info:
	@echo -e "[*] Sources, C:\t\t$(SRCS.c)"
	@echo -e "[*] Sources, C++:\t$(SRCS.cpp)"
	@echo
	@echo -e "[*] Objects, release:\t$(REL_OBJS)"
	@echo -e "[*] Target, release:\t$(REL_TARGET)"
	@echo
	@echo -e "[*] Objects, debug:\t$(DBG_OBJS)"
	@echo -e "[*] Target, debug:\t$(DBG_TARGET)"

# Display usage help. 
#
help:
	@echo "USAGE:"
	@echo -e "\tmake \t\t\tBuild project, in Release mode by default."
	@echo -e "\tmake debug \t\tBuild project in Debug mode."
	@echo -e "\tmake run \t\tRun target, by default Release target."
	@echo -e "\tmake run-debug \tRun Debug target."
	@echo -e "\tmake clean \t\tClean project directory."
	@echo -e "\tmake info \t\tDisplay info about files in project directory."
	@echo -e "\tmake help \t\tDisplay this help message."
