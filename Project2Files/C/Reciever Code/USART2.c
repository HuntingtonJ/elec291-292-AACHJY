#include  "stm32f05xxx.h"

#include "USART2.h"

volatile unsigned char U2_RX_flag = 0;
volatile unsigned char U2_RXO_flag = 0;
volatile unsigned char U2_RXNF_flag = 0;
volatile unsigned char RX_data = 0;

void initUSART2(int BaudRate) {
	int BaudRateDivisor;
	
	disable_interrupts();
	//Calculate BaudRate reload value
	//BaudRateDivisor = 48000000; // assuming 48MHz clock 
	BaudRateDivisor = 6000000 / (long) BaudRate;
	
	//Enables clock for PORTA
	//RCC_AHBENR  |= BIT17;
	
	//Configure PA2 (Pin8) as TXD for USART2
	GPIOA_OSPEEDR |= BIT4;  //Medium Speed
	GPIOA_OTYPER  &= ~BIT2; //Push-Pull mode
	GPIOA_MODER   |= BIT5;  //Alternative function mode
	GPIOA_AFRL    |= BIT8;  //AF mode 1
	
	//Configure PA3 (Pin9) as RXD for USART2
	GPIOA_MODER   |= BIT7;  //Alternative function mode
	GPIOA_AFRL    |= BIT12;  //AF mode 1
	
	// Turn on the clock for the USART2 peripheral
	RCC_CFGR      |= ( BIT10 | BIT9 ); //Divide APB clk by 8
	//RCC_CFGR3     &= ~( BIT17 | BIT16 );
	RCC_APB1ENR   |= BIT17;  //Timer2.
	
	//Configure USART2 Parameters (1 start, 1 Stop, No parity
	USART2_CR1     = 0x00000000;
	USART2_CR1    |= ( BIT2 | BIT3 | BIT5 );  //Enable Transmit, Receive and Receive Interrupt.
	//USART2_CR1    |= BIT6;  //Enable Transmit Interrupt
	USART2_CR2     = 0x00000000;
	USART2_CR3     = 0x00000001; //EIE for ORE, NF, FE
	
	USART2_BRR     = BaudRateDivisor;
	//USART2_GTBR   |= BIT4;//Divide by 8
	
	
	USART2_CR1    |= BIT0;  //Enable USART2  
	ISER          |= BIT28;
	enable_interrupts();
}

void isr_usart2(void) {
	if (USART2_ISR & BIT2) { //NF
		usart2_rxnf();
	}
	//Checks if ORE flag is set (overrun)
	if (USART2_ISR & BIT3) { //ORE
		usart2_rxo();
	}
	//Checks if RXNE flag is set
	if (USART2_ISR & BIT5) { //RXNE 
		usart2_rx();
	} 
	
}

void usart2_rx(void) {
	// Handles usart2 receive
	U2_RX_flag = 1;
	RX_data = USART2_RDR;
}

void usart2_rxo(void) {
	// Handles usart2 receive overflow
	USART2_RQR |= BIT3; //Clear RXNE
	USART2_ICR |= BIT3; //Clear ORE
	U2_RXO_flag = 1;
}

void usart2_rxnf(void) {
	USART2_RQR |= BIT3; //Clear RXNE
	USART2_ICR |= BIT2; //Clear NF
	U2_RXNF_flag = 1;
}

void putc2(unsigned char c) {
	USART2_TDR = c;
}