#include "idt.h"
#include "io.h"
#include "string.h"
#include <stdint.h>

// Variables globales
struct idt_entry idt[256];
struct idt_ptr idtp;

void idt_set_gate(uint8_t num, uint32_t base, uint16_t sel, uint8_t flags) {
    idt[num].base_lo = base & 0xFFFF;
    idt[num].base_hi = (base >> 16) & 0xFFFF;
    idt[num].sel = sel;
    idt[num].always0 = 0;
    idt[num].flags = flags;
}

__attribute__((noreturn))
void exception_handler(void) {
    asm volatile(
        "cli\n"
        "hlt\n"
    );
    __builtin_unreachable();
}

void install_exception_handlers(void) {
    for(uint8_t i = 0; i < 32; i++) {
        idt_set_gate(i, (uint32_t)exception_handler, 0x08, 0x8E);
    }
}

void idt_init(void) {
    idtp.limit = sizeof(struct idt_entry) * 256 - 1;
    idtp.base = (uint32_t)&idt;
    
    memset(&idt, 0, sizeof(idt));
    install_exception_handlers();
    
    asm volatile("lidt %0" : : "m"(idtp));
}