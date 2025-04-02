#include "vga.h"
#include "string.h"  // Asegúrate de incluir este header

void process_command(char* cmd) {
    vga_print("\n> ");
    vga_print(cmd);
    
    if(strcmp(cmd, "help") == 0) {
        vga_print("\nCommands: help, clear, echo");
    }
    else if(strcmp(cmd, "clear") == 0) {
        vga_clear();
    }
    else if(strncmp(cmd, "echo ", 5) == 0) {
        vga_print("\n");
        vga_print(cmd + 5);
    }
    else {
        vga_print("\nUnknown command. Type 'help'");
    }
    
    vga_print("\nclissey> ");
}