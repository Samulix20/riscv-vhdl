
.section .init
.globl _start
.type _start,@function

_start:
    .cfi_startproc
    .cfi_undefined ra
.option push
.option norelax
	la  gp, __global_pointer$
.option pop

    // Primary hart
	la sp, _stack_top

	// Load data section
	la a0, _data_lma
	la a1, _data
	la a2, _edata
	bgeu a1, a2, 2f
1:
	lw t0, 0(a0)
	sw t0, 0(a1)
	addi a0, a0, 32
	addi a1, a1, 32
	bltu a1, a2, 1b
2:

	// Clear bss section
	la a0, _bss
	la a1, _ebss
	bgeu a0, a1, 2f
1:
	sw zero, 0(a0)
	addi a0, a0, 32
	bltu a0, a1, 1b
2:

	// argc, argv, envp is 0
	li  a0, 0
	li  a1, 0
	li  a2, 0
	jal main
	.cfi_endproc
