#ifndef VHDL_PRINT_H
#define VHDL_PRINT_H

// print register
#define PRINT_REG_ADDR   0x00090000
#define PRINT_REG       *((unsigned int *) PRINT_REG_ADDR)

void print_str(char* str);

// Print num according to base
void print_uint(unsigned int num, unsigned int base);

#endif