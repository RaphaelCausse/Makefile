# Generic Makefile for C/C++ projects.
# Author : Raphael CAUSSE
# Date   : 08/2022


# Mode for run rule. 0 is default for release mode, 1 is for debug mode.
#
MODE := 0

# Directories path set up.
#
DIR_BIN := bin/
DIR_SRC := src/
DIR_OBJ := obj/
DIR_INC := include/

# Compiler and linker.
#
CC := gcc
CXX := g++
LD := g++

# Compiler flags.
#
CFLAGS := -Wall -Wextra -I$(DIR_INC)
CXXFLAGS := -Wall -Wextra -I$(DIR_INC)
# Sanitizer flags
#
FSAN_ADDRESS := -fsanitize=address

# Linker flags.
#
LDFLAGS := -I$(DIR_INC)

# Library flags.
#
LDLIBS := -lm

# Files set up.
#
TARGET := app
SRCS.c := $(shell find $(DIR_SRC) -name *.c)
SRCS.cpp := $(shell find $(DIR_SRC) -name *.cpp)

# Shell commands.
#
MKDIR_P := mkdir -p
RM := rm -rf

# Release build set up. 
#
DIR_BIN_REL := $(DIR_BIN)release/
DIR_OBJ_REL := $(DIR_OBJ)release/
REL_TARGET := $(DIR_BIN_REL)$(TARGET)
REL_FLAGS := -O2 -DNDEBUG
REL_OBJS := $(addprefix $(DIR_OBJ_REL),$(patsubst %.c,%.o,$(notdir $(SRCS.c)))) \
			$(addprefix $(DIR_OBJ_REL),$(patsubst %.cpp,%.o,$(notdir $(SRCS.cpp))))

# Debug build set up.
#
DIR_BIN_DBG := $(DIR_BIN)debug/
DIR_OBJ_DBG := $(DIR_OBJ)debug/
DBG_TARGET := $(DIR_BIN_DBG)$(TARGET)
DBG_FLAGS := -g $(FSAN_ADDRESS) -O0 -DDEBUG
DBG_OBJS := $(addprefix $(DIR_OBJ_DBG),$(patsubst %.c,%.o,$(notdir $(SRCS.c)))) \
			$(addprefix $(DIR_OBJ_DBG),$(patsubst %.cpp,%.o,$(notdir $(SRCS.cpp))))


# Default build, Release mode.
#
all: release

#.PHONY: prep release debug

# Before build, create directories if necessary.
#
prep:
	@$(MKDIR_P) $(DIR_BIN_REL) $(DIR_BIN_DBG) $(DIR_OBJ_REL) $(DIR_OBJ_DBG)

# Release build
#
release: prep $(REL_TARGET)

# Linking for Release target.
#
$(REL_TARGET): $(REL_OBJS)
	@echo ":: Build '$@' ..."
	$(LD) $(LDFLAGS) $^ -o $@ $(LDLIBS)
	@echo "==> Done"

# Compilation source files for Release mode.
#
$(DIR_OBJ_REL)%.o: $(DIR_SRC)%.c
	@echo ":: Compile '$<' ..."
	$(CC) $(CFLAGS) $(REL_FLAGS) -c $< -o $@

$(DIR_OBJ_REL)%.o: $(DIR_SRC)%.cpp
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

# Compilation source files for Debug mode.
#
$(DIR_OBJ_DBG)%.o: $(DIR_SRC)%.c
	@echo ":: Compile '$<' ..."
	$(CC) $(CFLAGS) $(DBG_FLAGS) -c $< -o $@

$(DIR_OBJ_DBG)%.o: $(DIR_SRC)%.cpp
	@echo ":: Compile '$<' ..."
	$(CXX) $(CXXFLAGS) $(DBG_FLAGS) -c $< -o $@


.PHONY: run clean info

# Run target.
#
run:
	@if [ "$(MODE)" -eq "0" ]; then\
		echo ":: Run $(REL_TARGET) ...";\
		./$(REL_TARGET);\
	elif [ "$(MODE)" -eq "1" ]; then\
		echo ":: Run $(DBG_TARGET) ...";\
		./$(DBG_TARGET);\
	else\
		echo "No target to run.";\
	fi

# Remove target and objet files.
#
clean:
	@echo ":: Clean build directory ..."
	$(RM) $(DIR_BIN) $(DIR_OBJ)

# Display source and object files.
#
info:
	@echo "[*] Sources, C: 	$(SRCS.c)"
	@echo "[*] Sources, C++: 	$(SRCS.cpp)"
	@echo
	@echo "[*] Objects, release: 	$(REL_OBJS)"
	@echo "[*] Target, release:	$(REL_TARGET)"
	@echo
	@echo "[*] Objects, debug: 	$(DBG_OBJS)"
	@echo "[*] Target, debug:	$(DBG_TARGET)"