
# Check if pass routine works

#include <riscv_test.h>
#include <test_macros.h>

RVTEST_CODE_BEGIN

li TESTNUM, 2
j pass
nop
nop
nop

TEST_PASSFAIL
