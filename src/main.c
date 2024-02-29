#include <stdio.h>

int main(int argc, char *argv[])
{
    printf("Hello with my Makefile !\n");
    for (int i = 0; i < argc; ++i)
    {
        printf("argv[%i]: %s\n", i, argv[i]);
    }
    return 0;
}