# Test for ebreak and ecall

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_CODE_BEGIN

la x1, mtvec_handler
csrrw x0, mtvec, x1

# Check machine mode ecall, test 1
li TESTNUM, 1
ecall

# Check user mode ecall, test 2
li TESTNUM, 2
ecall

# Ebreak test 3
li TESTNUM, 3
ebreak
jal x0, ending

mtvec_handler:
csrrs x10, mcause, x0
li x5, 2
beq TESTNUM, x5, test2_handler
li x5, 3
beq TESTNUM, x5, test3_handler

li x11, 11
bne x10, x11, fail
li x5, 0x1800
csrrc x0, mstatus, x5
jal x0, handler_exit

test2_handler:
li x11, 8
bne x10, x11, fail
jal x0, handler_exit

test3_handler:
li x11, 3
bne x10, x11, fail
jal x0, handler_exit

handler_exit:
csrrs x5, mepc, x0
addi x5, x5, 4
csrrw x0, mepc, x5
mret

ending:
TEST_PASSFAIL
