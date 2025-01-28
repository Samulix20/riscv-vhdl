# Compiler definitions
CROSS := riscv32-unknown-elf-
CC := $(CROSS)gcc
LD := $(CROSS)ld
DUMP := $(CROSS)objdump

SRC_DIR			= src
BUILD_DIR       = build
RTOS_SOURCE_DIR = $(SRC_DIR)/FreeRTOS/Source
SIM_DIR			= /mnt/c/Users/samu/Desktop/tfg/tfg_vhdl/src

CFLAGS = \
	-D__riscv_float_abi_soft \
	-DportasmHANDLE_INTERRUPT=external_interrupt_handler \
	-I include \
	-I include/FreeRTOS/config \
	-I include/FreeRTOS/include \
	-march=rv32im -mabi=ilp32 \
	-Wall \
	-fmessage-length=0 \
	-ffunction-sections \
	-fdata-sections \
	-fno-builtin-printf \
	-O2

LDFLAGS = \
	-nostartfiles -T linker.lds \
	-Xlinker --gc-sections \
	-Xlinker --defsym=__stack_size=300

SRCS = \
	$(SRC_DIR)/ext_int.c \
	$(SRC_DIR)/main.c \
	$(SRC_DIR)/vhdl_print.c \
	$(RTOS_SOURCE_DIR)/port.c \
	$(RTOS_SOURCE_DIR)/event_groups.c \
	$(RTOS_SOURCE_DIR)/list.c \
	$(RTOS_SOURCE_DIR)/queue.c \
	$(RTOS_SOURCE_DIR)/stream_buffer.c \
	$(RTOS_SOURCE_DIR)/tasks.c \
	$(RTOS_SOURCE_DIR)/timers.c \
	$(RTOS_SOURCE_DIR)/portable/MemMang/heap_4.c

ASMS = \
	$(SRC_DIR)/start.S \
	$(RTOS_SOURCE_DIR)/portASM.S

OBJS = $(SRCS:%.c=$(BUILD_DIR)/%.o) $(ASMS:%.S=$(BUILD_DIR)/%.o)
DEPS = $(SRCS:%.c=$(BUILD_DIR)/%.d) $(ASMS:%.S=$(BUILD_DIR)/%.d)

$(BUILD_DIR)/main: $(OBJS) linker.lds Makefile
	$(CC) $(LDFLAGS) $(OBJS) -o $@

$(BUILD_DIR)/%.o: %.c Makefile
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

$(BUILD_DIR)/%.o: %.S Makefile
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

rams: $(BUILD_DIR)/main
	python3 ../common/elf.py > ram.dump

dump:
	$(DUMP) -D $(BUILD_DIR)/main > main.dump

clean:
	rm -rf $(BUILD_DIR)
	rm -rf main.dump
	rm -rf ram.dump

-include $(DEPS)

