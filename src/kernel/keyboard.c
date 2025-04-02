#include "keyboard.h"
#include "vga.h"
#include "io.h"
#include "idt.h"

// Mapa de teclado US QWERTY (simplificado)
static const char kbdus[128] = {
    0,  27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '\b',
    '\t', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n',
    0, 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '`',
    0, '\\', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0, '*',
    0, ' ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '-',
    0, 0, 0, '+', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

void keyboard_handler(void) {
    uint8_t scancode = inb(0x60);
    outb(0x20, 0x20); // EOI al PIC

    if(scancode < 128) {
        char c = kbdus[scancode];
        if(c) vga_putchar(c, 0x0F); // Usa color blanco
    }
}

void keyboard_init(void) {
    idt_set_gate(33, (uint32_t)keyboard_handler, 0x08, 0x8E); // IRQ1 -> Int 33
}