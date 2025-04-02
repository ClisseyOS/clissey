#!/bin/bash

# --- Configuration ---
KERNEL_SRC_DIR="src/kernel"
ISO_DIR="iso"
OUTPUT_ISO="Clissey.iso"
CC="gcc"
LD="ld"
NASM="nasm"
CFLAGS="-m32 -ffreestanding -nostdlib -O0 -I./src/kernel -fno-stack-protector"
LDFLAGS="-m elf_i386 -T src/kernel/linker.ld -nostdlib"

# List of kernel source files (without extensions)
KERNEL_FILES=(
    "boot"      # .s
    "main"      # .c
    "vga"       # .c
    "keyboard"  # .c
    "cli"       # .c
    "io"        # .c
    "idt"       # .c
    "string"    # .c
)

# --- Clean previous builds ---
clean() {
    echo "[*] Cleaning previous builds..."
    rm -rf "$ISO_DIR" "$KERNEL_SRC_DIR"/*.o "$KERNEL_SRC_DIR"/kernel.bin "$OUTPUT_ISO"
}

# --- Create directory structure ---
create_dirs() {
    echo "[*] Creating directory structure..."
    mkdir -p "$ISO_DIR"/boot/grub
}

# --- Compile kernel files ---
compile() {
    echo "[*] Compiling kernel components..."
    
    # Compile assembly files
    $NASM -f elf32 "$KERNEL_SRC_DIR/boot.s" -o "$KERNEL_SRC_DIR/boot.o" || exit 1
    
    # Compile C files
    for file in "${KERNEL_FILES[@]:1}"; do  # Skip boot.s (already compiled)
        echo "  → Compiling $file.c"
        $CC $CFLAGS -c "$KERNEL_SRC_DIR/$file.c" -o "$KERNEL_SRC_DIR/$file.o" || {
            echo "[!] Failed to compile $file.c"
            exit 1
        }
    done
}

# --- Link kernel ---
link() {
    echo "[*] Linking kernel..."
    
    # Generate object list
    OBJ_FILES=()
    for file in "${KERNEL_FILES[@]}"; do
        OBJ_FILES+=("$KERNEL_SRC_DIR/$file.o")
    done
    
    $LD $LDFLAGS "${OBJ_FILES[@]}" -o "$KERNEL_SRC_DIR/kernel.bin" || {
        echo "[!] Linking failed!"
        exit 1
    }
}

# --- Prepare ISO ---
build_iso() {
    echo "[*] Building ISO..."
    cp "$KERNEL_SRC_DIR/kernel.bin" "$ISO_DIR/boot/"
    cp "$KERNEL_SRC_DIR/../boot/grub.cfg" "$ISO_DIR/boot/grub/"
    
    grub-mkrescue -o "$OUTPUT_ISO" "$ISO_DIR" 2> /dev/null || {
        echo "[!] ISO generation failed"
        exit 1
    }
}

# --- Main build process ---
clean
create_dirs
compile
link
build_iso

# --- Success message ---
echo -e "\n[+] Build successful!"
echo "[+] Kernel: $KERNEL_SRC_DIR/kernel.bin"
echo "[+] ISO: $OUTPUT_ISO"
echo -e "\nRun with: qemu-system-x86_64 -cdrom $OUTPUT_ISO"