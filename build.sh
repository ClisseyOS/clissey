#!/bin/bash

# --- Configuración ---
KERNEL_SRC_DIR="src/kernel"
ISO_DIR="iso"
OUTPUT_ISO="Clissey.iso"

# --- Limpieza previa ---
echo "[*] Limpiando compilaciones anteriores..."
rm -rf "$ISO_DIR" "$KERNEL_SRC_DIR"/*.o "$KERNEL_SRC_DIR"/kernel.bin "$OUTPUT_ISO"

# --- Crear estructura de directorios ---
echo "[*] Creando estructura de directorios..."
mkdir -p "$ISO_DIR"/boot/grub

# --- Compilar el kernel ---
echo "[*] Compilando el kernel..."

# Ensamblar boot.s (Multiboot 2)
nasm -f elf32 src/kernel/boot.s -o src/kernel/boot.o || exit 1

# Compilar main.c
gcc -m32 -c src/kernel/main.c -o src/kernel/main.o -ffreestanding -nostdlib -O0 || exit 1

# Enlazar
ld -m elf_i386 -T src/kernel/linker.ld src/kernel/boot.o src/kernel/main.o -o src/kernel/kernel.bin -nostdlib || exit 1

# --- Copiar archivos a /iso ---
echo "[*] Copiando archivos a $ISO_DIR..."
cp "$KERNEL_SRC_DIR"/kernel.bin "$ISO_DIR"/boot/
cp "$KERNEL_SRC_DIR"/../boot/grub.cfg "$ISO_DIR"/boot/grub/

# --- Generar ISO ---
echo "[*] Generando ISO..."
grub-mkrescue -o "$OUTPUT_ISO" "$ISO_DIR" || { echo "[!] Falló grub-mkrescue"; exit 1; }

# --- Éxito ---
echo "[+] ¡Éxito! ISO generada: $OUTPUT_ISO"
echo "[+] Ejecuta en QEMU: qemu-system-x86_64 -cdrom $OUTPUT_ISO"