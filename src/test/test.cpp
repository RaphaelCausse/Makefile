#include <cstdio>
#include <cstring>
#include "test/test.h"


void test_print()
{
    const char *os = OS;
    if (std::strcmp(os, "OS_unknown") == 0)
    {
        return;
    }
    std::printf("Thank you for using my Makefile on %s !\n", os);
}
