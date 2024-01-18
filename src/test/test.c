#include "test/test.h"


void test_print()
{
    const char *os = OS;
    if (strcmp(os, "OS_unknown") == 0)
    {
        return;
    }
    printf("Thank you for using my Makefile on %s !\n", os);
}