
#include "ext_int.h"
#include <vhdl_print.h>

void external_interrupt_handler( unsigned int cause )
{
	print_str("External interrupt!");
	while (1);
}
