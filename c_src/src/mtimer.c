#include <mtimer.h>
#include <csr.h>
#include <print.h>

static unsigned long long period;

void _mtimer_irq() {
    MTIMER_CMP = MTIMER_COUNTER + period;
    print_str("Tick!\n");
}

void set_mtimer_period(unsigned long long p) {
    period = p;
    MTIMER_CMP = MTIMER_COUNTER + period;
}

void enable_mtimer() {
    set_mie(MIE_MTIMER);
    set_mstatus(MSTATUS_MIE);
}

