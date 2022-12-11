#include <csr.h>

unsigned int read_mcause() {
    unsigned int mcause;
    asm("csrr %0, mcause" : "=r" (mcause));
    return mcause;
}

void set_mie(unsigned int mask) {
    asm("csrs mie, %0" :: "r" (mask));
}

void clear_mie(unsigned int mask) {
    asm("csrc mie, %0" :: "r" (mask));
}

void set_mstatus(unsigned int mask) {
    asm("csrs mstatus, %0" :: "r" (mask));
}

void clear_mstatus(unsigned int mask) {
    asm("csrc mstatus, %0" :: "r" (mask));
}

unsigned int read_mstatus() {
    unsigned int mstatus;
    asm("csrr %0, mstatus" : "=r" (mstatus));
    return mstatus;
}

