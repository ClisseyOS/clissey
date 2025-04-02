#include "vga.h"
#include "keyboard.h"
#include "idt.h"

void kernel_main() {
    vga_init();
    vga_print("Setting up IDT...");
    
    idt_init();          // Configurar IDT
    install_exception_handlers(); // Handlers básicos
    keyboard_init();     // Configurar teclado
    
    vga_print("\nClisseyOS Ready!");
    vga_print("\n> ");
    
    asm volatile("sti"); // Habilitar interrupciones
    
    while(1) {
        asm volatile("hlt"); // Esperar interrupciones
    }
}