ENTRY(_start)

SECTIONS {
    . = 1M;
    .multiboot_header : {
        *(.multiboot_header)
    }
    .text : ALIGN(4K) {
        *(.text)
    }
    .data : ALIGN(4K) {
        *(.data)
        *(.rodata*)
    }
    .bss : ALIGN(4K) {
        *(COMMON)
        *(.bss)
    }
}