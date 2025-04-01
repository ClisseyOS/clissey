#!/bin/bash

# --- Settings ---
KERNEL_SRC_DIR="src/kernel"
ISO_DIR="iso"
OUTPUT_ISO="Clissey.iso"

# --- Previous clearing ---
echo "[*] Clearing other compilations..."
rm -rf "$ISO_DIR" "$KERNEL_SRC_DIR"/*.o "$KERNEL_SRC_DIR"/kernel.bin "$OUTPUT_ISO"

# --- Make directory structure ---
echo "[*] Making directory structure..."
mkdir -p "$ISO_DIR"/boot/grub

# --- Compiling kernel ---
echo "[*] Compiling kernel..."

# boot.s (Multiboot 2)
nasm -f elf32 src/kernel/boot.s -o src/kernel/boot.o || exit 1

# Compile main.c
gcc -m32 -c src/kernel/main.c -o src/kernel/main.o -ffreestanding -nostdlib -O0 || exit 1

# Link
ld -m elf_i386 -T src/kernel/linker.ld src/kernel/boot.o src/kernel/main.o -o src/kernel/kernel.bin -nostdlib || exit 1

# --- Copy files to /iso ---
echo "[*] Copying files to $ISO_DIR..."
cp "$KERNEL_SRC_DIR"/kernel.bin "$ISO_DIR"/boot/
cp "$KERNEL_SRC_DIR"/../boot/grub.cfg "$ISO_DIR"/boot/grub/

# --- Generate ISO ---
echo "[*] Generating ISO..."
grub-mkrescue -o "$OUTPUT_ISO" "$ISO_DIR" || { echo "[!] grub-mkrescue failed!"; exit 1; }

# --- Done ---
echo "[+] Done! generated ISO: $OUTPUT_ISO"
echo "[+] Run on QEMU: qemu-system-x86_64 -cdrom $OUTPUT_ISO"