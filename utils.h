#ifndef ni__utils__h
#define ni__utils__h

#include <stdio.h>
#include <stdlib.h>

#define ni_err(A, ...) do {           \
  printf("[x] error : ", ##__VA_ARGS); \
  exit(EXIT_FAILURE);                   \
} while(0)
#define ni_warn(A, ...) printf("[!] warn : ",##__VA_ARGS)
#define ni_ok(A, ...) printf("[V] okay : ",##__VA_ARGS)

#endif //ni__utils__h
