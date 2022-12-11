#ifndef CSR_H
#define CSR_H

// mcause values
#define MCAUSE_MISALIGNED_FETCH      0x0
#define MCAUSE_FETCH_ACCESS          0x1
#define MCAUSE_ILLEGAL_INSTRUCTION   0x2
#define MCAUSE_BREAKPOINT            0x3
#define MCAUSE_MISALIGNED_LOAD       0x4
#define MCAUSE_LOAD_ACCESS           0x5
#define MCAUSE_MISALIGNED_STORE      0x6
#define MCAUSE_STORE_ACCESS          0x7
#define MCAUSE_USER_ECALL            0x8
#define MCAUSE_SUPERVISOR_ECALL      0x9
#define MCAUSE_HYPERVISOR_ECALL      0xa
#define MCAUSE_MACHINE_ECALL         0xb
#define MCAUSE_FETCH_PAGE_FAULT      0xc
#define MCAUSE_LOAD_PAGE_FAULT       0xd
#define MCAUSE_STORE_PAGE_FAULT      0xf
#define MCAUSE_TIMER_IRQ             0x80000007

// mstatus mie bit
#define MSTATUS_MIE (1 << 3)

unsigned int read_mcause();

// Bitmask set mie
void set_mie(unsigned int mask);
// Bitmask clear mie
void clear_mie(unsigned int mask);

// Bitmask set mstatus
void set_mstatus(unsigned int mask);
// Bitmask clear mstatus
void clear_mstatus(unsigned int mask);
unsigned int read_mstatus();

#endif
