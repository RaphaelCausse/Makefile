# Generic Makefile for C/C++ projects.
# Author : Raphael CAUSSE
# Date   : 08/2022


# Compiler and linker.
CC := gcc
#CC += -fsanitize=address
CXX := g++
#CXX += -fsanitize=address
LD := g++

# Compiler flags.
CFLAGS = -Wall -Wextra -g -O2 -I$(DIR_INC)
CXXFLAGS = -Wall -Wextra -g -O2 -I$(DIR_INC)
# Extra compiler flags.
EXTRA_CFLAGS :=
EXTRA_CXXFLAGS :=
#CFLAGS += $(EXTRA_CFLAGS)
#CXXFLAGS += $(EXTRA_CXXFLAGS)

# Linker flags.
LDFLAGS = -I$(DIR_INC) -lm
# Extra linker flags.
EXTRA_LDFLAGS :=
#LDFLAGS += $(EXTRA_LDFLAGS)

# Library flags.
LDLIBS :=

# Directories path.
DIR_BUILD := build/
DIR_INC := include/
DIR_SRC := src/
DIR_OBJ := $(DIR_BUILD)obj/

# Target executable and files.
TARGET := $(DIR_BUILD)prog.app
SRCS := $(wildcard $(DIR_SRC)*.c $(DIR_SRC)*.cpp)
OBJS := $(patsubst $(DIR_SRC)%.c, $(DIR_OBJ)%.o, $(wildcard $(DIR_SRC)*.c)) \
	   $(patsubst $(DIR_SRC)%.cpp, $(DIR_OBJ)%.o, $(wildcard $(DIR_SRC)*.cpp))

# Shell commands.
MKDIR_P := mkdir -p
RM := rm -rf

# Compilation and linking.
.PHONY: all
all: $(TARGET)

# Linking and generating the target executable.
$(TARGET): $(OBJS)
	@echo ":: Build $@"
	@$(MKDIR_P) $(DIR_BUILD)
	$(LD) $(LDFLAGS) $(LDLIBS) $^ -o $@
	@echo "==> Done"

# Compilation and generating object files (.o).
# Rule for C files.
$(DIR_OBJ)%.o: $(DIR_SRC)%.c
	@echo ":: Compile $<"
	@$(MKDIR_P) $(DIR_OBJ)
	$(CC) $(CFLAGS) -c $< -o $@

# Rule for C++ files.
$(DIR_OBJ)%.o: $(DIR_SRC)%.cpp
	@echo ":: Compile $<"
	@$(MKDIR_P) $(DIR_OBJ)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Run the executable.
.PHONY: run
run: $(TARGET)
	@echo ":: Run $(TARGET)"
	@./$(TARGET)

# Clean the project directory.
.PHONY: clean
clean:
	@echo ":: Clean project directory"
	$(RM) $(DIR_BUILD)
	@echo "==> Done"