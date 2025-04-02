#include "string.h"

void* memset(void* ptr, int value, size_t num) {
    unsigned char* p = ptr;
    while(num--) {
        *p++ = (unsigned char)value;
    }
    return ptr;
}

void* memcpy(void* dest, const void* src, size_t n) {
    unsigned char* d = dest;
    const unsigned char* s = src;
    while(n--) {
        *d++ = *s++;
    }
    return dest;
}

int strcmp(const char* s1, const char* s2) {
    while(*s1 && (*s1 == *s2)) {
        s1++;
        s2++;
    }
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}

int strncmp(const char* s1, const char* s2, size_t n) {
    while(n-- && *s1 && (*s1 == *s2)) {
        s1++;
        s2++;
    }
    return n ? *(const unsigned char*)s1 - *(const unsigned char*)s2 : 0;
}