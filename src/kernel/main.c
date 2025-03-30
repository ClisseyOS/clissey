volatile void kernel_main() {
    volatile unsigned short *vga = (unsigned short*)0xB8000;
    const char *prompt = "ClisseyOS> ";
    
    // Limpia pantalla
    for (int i = 0; i < 80*25; i++) {
        vga[i] = 0x0F00 | ' ';
    }
    
    // Muestra prompt
    for (int i = 0; prompt[i]; i++) {
        vga[i] = 0x0F00 | prompt[i];
    }
    
    // Espera entrada (implementación básica)
    while (1) {
        // Aquí iría el código para leer el teclado
    }
}