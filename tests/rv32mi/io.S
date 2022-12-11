# Test MMIO register

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_CODE_BEGIN

li x1, IO_REG
li x2, 0xff
sb x2, 0(x1)
lbu x3, 0(x1)
bne x2, x3, aux_fail
li x2, 0xffffffff
lb x3, 0(x1)
bne x2, x3, aux_fail

li x1, IO_REG
li x2, 0xff
sb x2, 0(x1)
lbu x3, 0(x1)
bne x2, x3, aux_fail
li x2, 0xffffffff
lb x3, 0(x1)
bne x2, x3, aux_fail

li x1, 0x00080002
li x2, 0xff
sb x2, 0(x1)
lbu x3, 0(x1)
bne x2, x3, aux_fail
li x2, 0xffffffff
lb x3, 0(x1)
bne x2, x3, aux_fail

li x1, 0x00080003
li x2, 0xff
sb x2, 0(x1)
lbu x3, 0(x1)
bne x2, x3, aux_fail
li x2, 0xffffffff
lb x3, 0(x1)
bne x2, x3, aux_fail

li x1, IO_REG
li x2, 0xbeef
sh x2, 0(x1)
lhu x3, 0(x1)
bne x3, x2, aux_fail
li x2, 0xffffbeef
lh x3, 0(x1)
bne x2, x3, aux_fail

li x1, 0x00080002
li x2, 0xbeef
sh x2, 0(x1)
lhu x3, 0(x1)
bne x3, x2, aux_fail
li x2, 0xffffbeef
lh x3, 0(x1)
bne x2, x3, aux_fail

li x1, IO_REG
li x2, 0xdeadbeef
sw x2, 0(x1)
lw x3, 0(x1)
bne x2, x3, aux_fail

TEST_PASSFAIL

aux_fail:
    li TESTNUM, 1
    j fail
