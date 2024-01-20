#include <stdio.h>
#include <stdint.h>

#ifdef _WIN32       // For Windows
    #include <winsock2.h>
#endif
#ifdef __linux__    // For Linux
    #include <arpa/inet.h>
#endif


int main()
{
    printf("Thank you for using my Makefile !\n\n");

#ifdef _WIN32
    uint32_t word_h = 1;  // Host word, little endian 
    uint32_t word_n = htonl(word_h);  // Network word, big endian
    printf("HOST word ->  bytes: %u  -> dec: %10u  -> hex: %08X\n", sizeof(word_h), word_h, word_h);
    printf("NTWK word ->  bytes: %u  -> dec: %10u  -> hex: %08X\n", sizeof(word_n), word_n, word_n);
    printf("This is an Endian swap example from Little Endian to Big Endian.\n");
#endif
#ifdef __linux__
    uint32_t word_h = 1;  // Host word, little endian
    uint32_t word_n = htonl(word_h);  // Network word, big endian
    printf("HOST word ->  bytes: %lu  -> dec: %10u  -> hex: %08X\n", sizeof(word_h), word_h, word_h);
    printf("NTWK word ->  bytes: %lu  -> dec: %10u  -> hex: %08X\n", sizeof(word_n), word_n, word_n);
    printf("This is an Endian swap example from Little Endian to Big Endian.\n");
#endif

    return 0;
}