#include <stdlib.h>
#include <stdio.h>
#include <EFM8LB1.h>

#ifndef SYSCLK
#define SYSCLK 72000000L
#endif

#define UART1_BAUDRATE 115200L

void UART1_Init (unsigned long baudrate)
{
    SFRPAGE = 0x20;
	SMOD1 = 0x0C; // no parity, 8 data bits, 1 stop bit
	SCON1 = 0x10; //Receive fifo overrun flag = 0; Parity Error Flag = 0; 0; Receive enable flag = 1; TBX = 0; RBX = 0; Transmit Interrupt Flag = 0; Receive Interrupt FLag = 0;
	SBCON1 =0x00;   // disable baud rate generator
	SBRL1 = 0x10000L-((SYSCLK/baudrate)/(12L*2L));  //Baud rate reload
	TI1 = 1; // indicate ready for TX
	SBCON1 |= 0x40;   // enable baud rate generator
	SFRPAGE = 0x00;
}

void putchar1 (char c) 
{
    SFRPAGE = 0x20;
	if (c == '\n') 
	{
		while (!TI1);
		TI1=0;
		SBUF1 = '\r';
	}
	while (!TI1);
	TI1=0;
	SBUF1 = c;
	SFRPAGE = 0x00;
}

char getchar1 (void)
{
	char c;
    SFRPAGE = 0x20;
	while (!RI1);
	RI1=0;
	// Clear Overrun and Parity error flags 
	SCON1&=0b_0011_1111;
	c = SBUF1;
	SFRPAGE = 0x00;
	return (c);
}