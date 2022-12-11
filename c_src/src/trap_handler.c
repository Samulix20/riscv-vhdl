#include <trap_handler.h>
#include <print.h>
#include <csr.h>
#include <mtimer.h>


void _trap_handler() {
    unsigned int mcause = read_mcause();

    switch (mcause) {
        case MCAUSE_TIMER_IRQ:
            _mtimer_irq();
            break;
        default:
            print_str("Unexpected mcause found, ");
            print_uint(mcause, 16);
            print_str("\n");
            while(1);
    }
}
