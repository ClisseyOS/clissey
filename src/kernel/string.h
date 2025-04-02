#ifndef STRING_H
#define STRING_H

#include <stddef.h>

// Funciones de memoria
void* memset(void* ptr, int value, size_t num);
void* memcpy(void* dest, const void* src, size_t n);

// Funciones de strings
int strcmp(const char* s1, const char* s2);
int strncmp(const char* s1, const char* s2, size_t n);

#endif