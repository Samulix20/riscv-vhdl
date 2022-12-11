# Simplified missaligned jump test

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_CODE_BEGIN

la x1, mtvec_handler
csrrw x0, mtvec, x1

li TESTNUM, 2
li x6, 0
la x5, test_1
jalr x6, x5, 2
test_1:
nop
jal x0, fail

nop
li TESTNUM, 3
la x5, test_3_1
jalr x6, x5, 1
test_3_1:
jal x0, test_3_2
jal x0, fail
test_3_2:

li TESTNUM, 4
li x6, 0
la x5, test_4_1
jalr x6, x5, 3
test_4_1:
nop
jal x0, fail

nop
li TESTNUM, 5
li x6, 0
la x5, test_5_1
jal x6, test_5_2
test_5_1:
.half 0xffff
test_5_2:
.half 0xffff
jal x0, fail

nop
li TESTNUM, 6
li x6, 0
la x5, test_6_1
beq x0, x0, test_6_2
test_6_1:
.half 0xffff
test_6_2:
.half 0xffff
jal x0, fail

nop
li TESTNUM, 7
bne x0, x0, test_7_1
jal x0, test_7_2
.half 0xffff
test_7_1:
.half 0xffff
jal x0, fail
test_7_2:

nop
jal x0, ending

mtvec_handler:
li x10, 2
beq TESTNUM, x10, handler_pass
li x10, 4
beq TESTNUM, x10, handler_pass
li x10, 5
beq TESTNUM, x10, handler_pass
li x10, 6
beq TESTNUM, x10, handler_pass
jal x0, fail

handler_pass:
bne x0, x6, fail

li x11, 0
csrrs x10, mcause, x0
bne x10, x11, fail

csrrs x11, mepc, x0
addi x11, x11, 4
bne x5, x11, fail

csrrs x10, mtval, x0
beq x0, x10, handler_end
addi x10, x10, -2
bne x10, x5, fail

handler_end:
addi x11, x11, 12
csrrw x0, mepc, x11
mret

ending:
TEST_PASSFAIL
