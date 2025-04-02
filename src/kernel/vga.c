#include "vga.h"

static uint16_t* vga_buffer = (uint16_t*)VGA_ADDR;
static size_t vga_row = 0;
static size_t vga_col = 0;
static uint8_t vga_color = 0x0F; // Blanco sobre negro

void vga_clear() {
    for(size_t y = 0; y < VGA_HEIGHT; y++) {
        for(size_t x = 0; x < VGA_WIDTH; x++) {
            const size_t index = y * VGA_WIDTH + x;
            vga_buffer[index] = (vga_color << 8) | ' ';
        }
    }
    vga_row = 0;
    vga_col = 0;
}

void vga_putchar(char c, uint8_t color) {
    if(c == '\n') {
        vga_col = 0;
        vga_row++;
    } else {
        const size_t index = vga_row * VGA_WIDTH + vga_col;
        vga_buffer[index] = (color << 8) | c;
        vga_col++;
    }

    if(vga_col >= VGA_WIDTH) {
        vga_col = 0;
        vga_row++;
    }

    if(vga_row >= VGA_HEIGHT) {
        vga_row = 0; // Scroll básico
    }
}

void vga_print(const char* str) {
    while(*str) {
        vga_putchar(*str++, vga_color);
    }
}

void vga_init() {
    vga_clear();
}