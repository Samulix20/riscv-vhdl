
# Check if CSR and Zicsr extension works

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_CODE_BEGIN

la x1, mtvec_handler
csrrw x0, mtvec, x1

# Make sure reading the cycle counter in four ways doesn't trap.
TEST_CASE(25, x0, 0, csrrc  x0, mcycle, x0);
TEST_CASE(26, x0, 0, csrrs  x0, mcycle, x0);
TEST_CASE(27, x0, 0, csrrci x0, mcycle, 0);
TEST_CASE(28, x0, 0, csrrsi x0, mcycle, 0);

TEST_CASE(20, a0,         0, csrw mscratch, zero; csrr a0, mscratch);
TEST_CASE(21, a0,         0, csrrwi a0, mscratch, 0; csrrwi a0, mscratch, 0xF);
TEST_CASE(22, a0,      0x1f, csrrsi x0, mscratch, 0x10; csrr a0, mscratch);

csrrwi x0, mscratch, 3
TEST_CASE( 2, a0,         3, csrr a0, mscratch);
TEST_CASE( 3, a1,         3, csrrci a1, mscratch, 1);
TEST_CASE( 4, a2,         2, csrrsi a2, mscratch, 4);
TEST_CASE( 5, a3,         6, csrrwi a3, mscratch, 2);
TEST_CASE( 6, a1,         2, li a0, 0xbad1dea; csrrw a1, mscratch, a0);
TEST_CASE( 7, a1, 0xbad1dea, li a0, 0x0001dea; csrrc a1, mscratch, a0);
TEST_CASE( 8, a1, 0xbad0000, li a0, 0x000beef; csrrs a1, mscratch, a0);
TEST_CASE( 9, a0, 0xbadbeef, li a0, 0xbad1dea; csrrw a0, mscratch, a0);
TEST_CASE(10, a0, 0xbad1dea, li a0, 0x0001dea; csrrc a0, mscratch, a0);
TEST_CASE(11, a0, 0xbad0000, li a0, 0x000beef; csrrs a0, mscratch, a0);
TEST_CASE(12, a0, 0xbadbeef, csrr a0, mscratch);

csrrs x10, misa, x0
srli x10, x10, 20
andi x10, x10, 1
beq x0, x10, ending
li x5, 0x1800
csrrc x0, mstatus, x5
la x5, userland
csrrw x0, mepc, x5
mret
userland:

TEST_CASE(14, a0, 255, li a0, 255; csrrw a0, mcycle, x0);
TEST_CASE(15, a0, 255, li a0, 255; csrr a0, mstatus)

ending:
TEST_PASSFAIL

mtvec_handler:
    li x5, 12
    bltu x3, x5, fail
    li x5, 14
    bgeu x5, x3, privileged

privileged:
    csrrs x5, mcause, x0
    li x6, 0x2
    bne x5, x6, fail
    csrrs x5, mepc, x0
    addi x5, x5, 4
    csrrw x0, mepc, x5
    mret
