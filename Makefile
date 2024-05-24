# Assembler, Compiler, Linker
# You must compile/build your own cross-compiler. Read README.md for more information.
AS = my_tools/bin/i686-elf-as
CC = my_tools/bin/i686-elf-gcc
LD = my_tools/bin/i686-elf-ld

all: bootloader kernel
# Link the kernel and bootloader
# We can use compiler to link (using linker only prevents the compiler from performing various tasks during linking). Read about it on OSdev.
	$(CC) -T src/linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc
# Check if the file is multiboot
	@if grub-file --is-x86-multiboot myos.bin; then \
		echo multiboot confirmed; \
	else \
		echo the file is not multiboot; \
	fi
# Create the ISO file
	grub-mkrescue -o myos.iso isodir

run:
	qemu-system-i386 -cdrom myos.iso

bootloader:
	$(AS) src/boot.s -o boot.o

kernel:
	$(CC) -c src/kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

