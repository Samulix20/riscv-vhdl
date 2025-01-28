#include <vhdl_print.h>

void print_str(char* str) {
    for (int i = 0; str[i] != 0; i++) {
        PRINT_REG = str[i];
    }
}

void print_uint(unsigned int num, unsigned int base) {
    unsigned int aux = num;
    char res[32];
    int i = 0;

    while(aux > 0) {
        char val = aux % base;
        aux /= base;
        res[i] = '0' + val;
        i++;
    }

    i--;
    while(i >= 0) {
        PRINT_REG = res[i];
        i--;
    }
}
