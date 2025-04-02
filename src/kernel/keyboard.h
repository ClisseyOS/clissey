#ifndef KEYBOARD_H
#define KEYBOARD_H

#include <stdint.h>

// Prototipos de funciones
void keyboard_init();
void keyboard_handler();

// Para uso en main.c
extern void process_command(char* cmd);

#endif