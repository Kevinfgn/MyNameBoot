
# Nombre de los archivos
boot_SRC = boot.asm
MYNAME_SRC = myName.asm
boot_BIN = boot.bin
MYNAME_BIN = myName.bin
IMAGE_BIN = boot_image.bin

# Compiladores y herramientas
ASM = nasm
ASM_FLAGS = -f bin
EMU = qemu-system-x86_64

# Reglas
all: $(IMAGE_BIN)

$(boot_BIN): $(boot_SRC)
	$(ASM) $(ASM_FLAGS) $< -o $@

$(MYNAME_BIN): $(MYNAME_SRC)
	$(ASM) $(ASM_FLAGS) $< -o $@

$(IMAGE_BIN): $(boot_BIN) $(MYNAME_BIN)
	cat $(boot_BIN) $(MYNAME_BIN) > $(IMAGE_BIN)

run: $(IMAGE_BIN)
	$(EMU) -drive format=raw,file=$(IMAGE_BIN)

clean:
	rm -f $(boot_BIN) $(MYNAME_BIN) $(IMAGE_BIN)

.PHONY: all run clean
