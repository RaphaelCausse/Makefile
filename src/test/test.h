#ifndef _TEST_H_
#define _TEST_H_


#ifdef _WIN32
   #define OS "Windows 32-bits"
#elif _WIN64
   #define OS "Windows 64-bits"
#elif __linux
    #define OS "Linux"
#elif __APPLE__
    #define OS "Apple"
#else
    #define OS "OS_unknown"
#endif


extern void test_print();


#endif /* _TEST_H_ */