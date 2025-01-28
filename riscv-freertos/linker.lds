OUTPUT_ARCH( "riscv" )
ENTRY( _start )

MEMORY
{
	ram (wxa) : ORIGIN = 0x00000000, LENGTH = 32K
}

SECTIONS
{
	.init :
	{
		_text = .;
		KEEP (*(SORT_NONE(.init)))
	} >ram
	
	.text :
	{
		*(.text.unlikely .text.unlikely.*)
		*(.text.startup .text.startup.*)
		*(.text .text.*)
		*(.gnu.linkonce.t.*)
	} >ram
	
	.fini :
	{
		KEEP (*(SORT_NONE(.fini)))
		_etext = .;
	} >ram

	.rodata.align :
	{
		. = ALIGN(4);
		_rodata = .;
	} >ram

	.rodata.start :
	{
		_rodata_lma = LOADADDR(.rodata.start);
	} >ram

	.rodata :
	{
		*(.rdata)
		*(.rodata .rodata.*)
		*(.gnu.linkonce.r.*)

		. = ALIGN(4);
		_erodata = .;
	} >ram

	.data.align :
	{
		. = ALIGN(4);
		_data = .;
	} >ram

	.data.start :
	{
		_data_lma = LOADADDR(.data.start);
	} >ram

	.data :
	{
		*(.data .data.*)
		*(.gnu.linkonce.d.*)
		. = ALIGN(8);
		PROVIDE( __global_pointer$ = . + 0x800 );
		*(.sdata .sdata.*)
		*(.sdata2 .sdata2.*)
		*(.gnu.linkonce.s.*)
		. = ALIGN(8);
		*(.srodata.cst16)
		*(.srodata.cst8)
		*(.srodata.cst4)
		*(.srodata.cst2)
		*(.srodata .srodata.*)

		. = ALIGN(4);
		_edata = .;
	} >ram

	.bss.align :
	{
		. = ALIGN(4);
		_bss = .;
	} >ram

	.bss.start :
	{
		_bss_lma = LOADADDR(.bss.start);
	} >ram

	.bss :
	{
		*(.sbss*)
		*(.gnu.linkonce.sb.*)
		*(.bss .bss.*)
		*(.gnu.linkonce.b.*)
		*(COMMON)

		. = ALIGN(4);
		_ebss = .;
	} >ram

	. = ALIGN(8);
	_end = .;

	.stack :
	{
		. = ALIGN(16);
		. += __stack_size;
		_stack_top = .;
	} >ram AT>ram
}
