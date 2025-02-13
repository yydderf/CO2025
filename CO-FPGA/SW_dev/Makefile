# Compiler and linker flags
# ======================================================================
CFLAGS     := -Wall -O2 -march=rv32i -fno-builtin -nostdlib
LDFLAGS    := -T hello.ld
# ======================================================================


# Source files and output files
# ======================================================================
SOURCES    := cpu_lib.c hello.c
OBJECTS    := $(SOURCES:.c=.o)
EXECUTABLE := hello.elf
DUMP       := hello.objdump
BIN        := hello.bin
BINSTR     := mem_preload.mem
# ======================================================================



# Default build
all: echo_env $(BIN) $(DUMP) $(BINSTR)


sim: CFLAGS += -DDEBUG_SIM
sim: clean all

echo_env:

%.o: %.c
	@echo "Compiling using flags :$(CFLAGS)."
	riscv32-unknown-elf-gcc $(CFLAGS) -c $< -o $@

$(EXECUTABLE): $(OBJECTS)
	riscv32-unknown-elf-ld $(LDFLAGS) ${OBJECTS} -o $@
	rm -f ${OBJECTS}

$(BIN): $(EXECUTABLE)
	riscv32-unknown-elf-objcopy -O binary $< $@
	

$(BINSTR): $(BIN)
	xxd -b $< | awk '{print $$2 $$3 $$4 $$5 $$6 $$7}' | tr -d '\n' | awk '{gsub(/[^01]/, ""); printf "%-32s\n", $$0}' | fold -w 32 | awk '{printf "%-32s\n", $$0}' | tr ' ' '0' > $@
	rm $<

$(DUMP): $(EXECUTABLE)
	riscv32-unknown-elf-objdump -d -s -x $< > $@
	rm $<

clean:
	rm -f $(OBJECTS) $(EXECUTABLE) $(BIN) $(DUMP) $(BINSTR)

.PHONY: all clean echo_env sim
