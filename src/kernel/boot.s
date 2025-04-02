section .multiboot_header
header_start:
    dd 0x1BADB002       ; Magic number
    dd 0x03             ; Flags
    dd -(0x1BADB002 + 0x03) ; Checksum
header_end:

section .text
bits 32
extern kernel_main
global _start
_start:
    ; Limpia pantalla (80x25, blanco sobre negro)
    mov edi, 0xB8000
    mov ecx, 80*25
    mov eax, 0x0F20     ; 0x0F=atributo (blanco), 0x20=espacio ASCII
    rep stosw           ; ¡Llena toda la pantalla!

    mov esp, 0x90000
    mov ebp, esp

    extern kernel_main
    call kernel_main
    
    cli
    hlt