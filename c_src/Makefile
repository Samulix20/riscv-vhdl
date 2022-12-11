# Compiler definitions
CROSS := riscv32-unknown-elf-
CC := $(CROSS)gcc
LD := $(CROSS)ld
DUMP := $(CROSS)objdump

# Dir definitions
SRC_DIR := src
BUILD_DIR := build

# Source and object files names
CSRCS := $(wildcard $(SRC_DIR)/*.c)
COBJS := $(CSRCS:$(SRC_DIR)%.c=$(BUILD_DIR)%.o) 

SSRCS := $(wildcard $(SRC_DIR)/*.S)
SOBJS := $(SSRCS:$(SRC_DIR)%.S=$(BUILD_DIR)%.o)

# Compiler flags
CFLAGS := -Wall -I include -march=rv32im -mabi=ilp32
# Linker flags
LDFLAGS := -nostartfiles -T linker.lds

$(BUILD_DIR)/main : $(SOBJS) $(COBJS)
	$(CC) $(LDFLAGS) $^ -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.S
	$(CC) $(CFLAGS) -c $< -o $@

rams: $(BUILD_DIR)/main
	python3 ../common/elf.py > /dev/null

dump:
	$(DUMP) -D $(BUILD_DIR)/main > main.dump

clean:
	rm -rf $(BUILD_DIR)/*
	rm -rf main.dump
