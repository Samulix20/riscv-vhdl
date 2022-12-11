# Test for RISCV mtimer

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_CODE_BEGIN

# Set exception handler
la x1, mtvec_handler
csrrw x0, mtvec, x1

# Check mtimer is increasing
li      TESTNUM, 2
li      x1, MTIMER_BASE
lw      x2, 0(x1)
lw      x4, 0(x1)
bge     x2, x4, fail

# Make mtimer cause an interrupt
li      TESTNUM, 3
# Set mtimer to interrupt after 400 ticks
addi    x4, x4, 400
sw      x2, 8(x1)
sw      x0, 12(x1)
# Enable timer interrupts in MIE
li      x1, (1 << 7)
csrs    mie, x1
# Enable interrupts in MSTATUS
li      x1, (1 << 3)
csrs    mstatus, x1

# Wait for 400 ticks in a loop
li      x2, 400
li      x1, 0
wloop:
    addi x1, x1, 1
    ble x1, x2, wloop

# If loop finishes mtimer is not working
j fail

TEST_PASSFAIL

mtvec_handler:
    # Check if interrupt was caused by the mtimer
    csrr    x1, mcause
    li      x2, CAUSE_TIMER_IRQ
    bne     x2, x1, fail
    j       pass

