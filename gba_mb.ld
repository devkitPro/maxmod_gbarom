/* raped linker script */

OUTPUT_FORMAT("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)

MEMORY {

	ewram	: ORIGIN = 0x02000000, LENGTH = 256K
	iwram	: ORIGIN = 0x03000000, LENGTH = 32K
	rom	: ORIGIN = 0x08000000, LENGTH = 32M
}

__header_start	=	ORIGIN(ewram);
__text_start	=	ORIGIN(iwram);

__iwram_top	=	ORIGIN(iwram) + LENGTH(iwram);

__sp_irq	=	__iwram_top - 0x060;
__sp_usr	=	__sp_irq - 0x0a0;
__irq_flags	=	0x03007ff8;

SECTIONS
{
	. = __header_start;
	
	.header :
	{
		__header_start = ABSOLUTE(.);
		*(.header)
		__header_end = ABSOLUTE(.);
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >ewram = 0xff
/*
	.rodata :
	{
		*(.rodata)
		. = ALIGN(4);   
	} >ewram = 0xff
*/
	__text_lma = .;
	
	.text __text_start : AT (__text_lma)
	{
		*(.rodata)
		*(.iwram)
		*(.data)
		*(.text)
		*(.glue_7)
		*(.glue_7t)
		. = ALIGN(4);
	} >iwram = 0xff
	
	__text_end = .;

	.bss ALIGN(4) :
	{
		__bss_start = ABSOLUTE(.);
		__bss_start__ = ABSOLUTE(.);
		*(.dynbss)
		*(.gnu.linkonce.b*)
		*(.bss*)
		*(COMMON)
		. = ALIGN(4);    /* REQUIRED. LD is flaky without it. */
		__bss_end = ABSOLUTE(.) ;
	}
	
	__bss_end__ = __bss_end ;
	
}
