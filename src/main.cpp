#include <iostream>
#include "test/test.h"


int main(int argc, char *argv[])
{
    std::cout << "argc\t:" << argc << std::endl;
    for (int i = 0; i < argc; i++)
    {
        std::cout << "argv[" << i << "]\t:" << argv[i] << std::endl;
    }
    test_print();
    return 0;
}