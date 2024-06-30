#==============================================================================
# Makefile template for small/medium sized C projects.
# Follow recommanded project layout in README.
# 
# Author: Raphael CAUSSE
#==============================================================================


#==============================================================================
# 
#==============================================================================


#==============================================================================
# COMPILER AND LINKER
#==============================================================================

### C Compiler
CC := gcc

### C standard
C_STANDARD := -std=c99

### Extra flags to give to the C compiler
CFLAGS = $(C_STANDARD) -Wall -Werror -Wextra

### Extra flags to give to the C preprocessor
CPPFLAGS = 

### Extra flags to give to compiler when it invokes the linker
LDFLAGS = 

### Library names given to compiler when it invokes the linker
LDLIBS =


#==============================================================================
# 
#==============================================================================
