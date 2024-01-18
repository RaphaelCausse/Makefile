#include <iostream>
#include "test/test.h"
#ifdef _WIN32
    #include <winsock2.h>
#else
    #include <arpa/inet.h>
#endif



int main(int argc, char *argv[])
{
    std::cout << "argc:\t" << argc << std::endl;
    for (int i = 0; i < argc; i++)
    {
        std::cout << "argv[" << i << "]:\t" << argv[i] << std::endl;
    }
    
    test_print();

    // Test Endian swapping
    u_long u32_h = 64;  // Host (Little Endian on Windows)
    u_long u32_n = htonl(u32_h);    // Network (Big Endian)
    std::printf("u32_h: %12lu\tin hexa: %08lX\n", u32_h, u32_h);
    std::printf("u32_n: %12lu\tin hexa: %08lX\n", u32_n, u32_n);

    return 0;
}