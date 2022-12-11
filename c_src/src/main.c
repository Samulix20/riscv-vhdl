#include <print.h>
#include <mtimer.h>

// Example main
int main() {
    print_str("Hello world!\n");
    
    // Make mtimer interrupt every 2000 ticks
    set_mtimer_period(2000);
    enable_mtimer();

    // Wait
    while(1);
}
