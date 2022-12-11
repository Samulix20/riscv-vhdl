/*
Copyright (c) 2012-2015, The Regents of the University of California (Regents).
All Rights Reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. Neither the name of the Regents nor the
   names of its contributors may be used to endorse or promote products
   derived from this software without specific prior written permission.

IN NO EVENT SHALL REGENTS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,
SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING
OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF REGENTS HAS
BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

REGENTS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED
HEREUNDER IS PROVIDED "AS IS". REGENTS HAS NO OBLIGATION TO PROVIDE
MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
*/

#*****************************************************************************
# ma_addr.S
#-----------------------------------------------------------------------------
#
# Test misaligned ld/st trap.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_CODE_BEGIN

la x1, mtvec_handler
csrrw x0, mtvec, x1

  .align 2
  .option norvc

  la s0, data

  # indicate it's a load test
  li s1, CAUSE_MISALIGNED_LOAD

#define SEXT(x, n) ((-((x) >> ((n)-1)) << (n)) | ((x) & ((1 << (n))-1)))

/* Check that a misaligned load either writes the correct value, or
   takes an exception and performs no writeback.  */
#define MISALIGNED_LOAD_TEST(testnum, insn, base, offset, res) \
  li TESTNUM, testnum; \
  la t2, 1f; \
  addi t1, base, offset; \
  insn t1, offset(base); \
  li t2, res; \
  bne t1, t2, fail; \
1:

  MISALIGNED_LOAD_TEST(2,  lh,  s0, 1, SEXT(0xbbcc, 16))
  MISALIGNED_LOAD_TEST(3,  lhu, s0, 1, 0xbbcc)
  MISALIGNED_LOAD_TEST(4,  lw,  s0, 1, SEXT(0x99aabbcc, 32))
  MISALIGNED_LOAD_TEST(5,  lw,  s0, 2, SEXT(0x8899aabb, 32))
  MISALIGNED_LOAD_TEST(6,  lw,  s0, 3, SEXT(0x778899aa, 32))

  # indicate it's a store test
  li s1, CAUSE_MISALIGNED_STORE

/* Check that a misaligned store has some effect and takes no exception,
   or takes no effect and generates an exception.  This is not very
   thorough.  */
#define MISALIGNED_STORE_TEST(testnum, insn, base, offset, size) \
  li TESTNUM, testnum; \
  la t2, 1f; \
  addi t1, base, offset; \
  insn x0, offset(base); \
  lb t1, (offset - 1)(base); \
  beqz t1, fail; \
  lb t1, (offset + size)(base); \
  beqz t1, fail; \
  lb t1, (offset + 0)(base); \
  bnez t1, fail; \
  lb t1, (offset + size - 1)(base); \
  bnez t1, fail; \
1:

  MISALIGNED_STORE_TEST(22,  sh,  s0, 1, 2)
  MISALIGNED_STORE_TEST(23,  sw,  s0, 5, 4)
  MISALIGNED_STORE_TEST(24,  sw,  s0, 10, 4)
  MISALIGNED_STORE_TEST(25,  sw,  s0, 15, 4)

  TEST_PASSFAIL

  .align 3
mtvec_handler:
  csrr t0, mcause
  bne t0, s1, fail

  csrr t0, mbadaddr
  beqz t0, 1f
  bne t0, t1, fail

  lb t0, (t0)
  beqz t0, fail
1:

  csrw mepc, t2
  mret


RVTEST_DATA_BEGIN

data:
  .align 3
.word 0xaabbccdd
.word 0x66778899
.word 0x22334455
.word 0xeeffee11
.fill 0xff, 1, 80