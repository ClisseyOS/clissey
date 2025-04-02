#ifndef VGA_H
#define VGA_H

#include <stddef.h>  // Para size_t
#include <stdint.h>

// Configuración VGA
#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_ADDR 0xB8000

// Funciones públicas
void vga_init(void);
void vga_clear(void);
void vga_putchar(char c, uint8_t color);  // Acepta parámetro de color
void vga_print(const char* str);

#endif