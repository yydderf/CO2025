CC=riscv64-unknown-elf-gcc
CFLAGS=-g
SIM=spike pk

.PHONY: run
run: recursive.c
	$(CC) $(CFLAGS) recursive.c recursive.s -o recursive && $(SIM) recursive
