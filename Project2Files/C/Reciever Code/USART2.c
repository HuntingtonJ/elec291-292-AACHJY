#include  "stm32f05xxx.h"

#include "USART2.h"

volatile unsigned char U2_RX_flag = 0;
volatile unsigned char RX_data = 0;

void initUSART2(int BaudRate) {
	int BaudRateDivisor;
	
	disable_interrupts();
	//Calculate BaudRate reload value
	BaudRateDivisor = 48000000; // assuming 48MHz clock 
	BaudRateDivisor = BaudRateDivisor / (long) BaudRate;
	
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
	RCC_APB1ENR   |= BIT17; 
	
	//Configure USART2 Parameters (1 start, 1 Stop, No parity
	//USART2_CR1    &= 0x00000000;
	USART2_CR1    |= (BIT2 | BIT3 | BIT5 );  //Enable Transmit, Receive and Receive Interrupt.
	//USART2_CR1    |= BIT6;  //Enable Transmit Interrupt
	USART2_CR2     = 0x00000000;
	USART2_CR3     = 0x00000000;
	
	USART2_BRR     = BaudRateDivisor;
	
	USART2_CR1    |= BIT0;  //Enable USART2  
	ISER          |= BIT28;
	enable_interrupts();
}

void isr_usart2(void) {
	//Checks if RXNE flag is enables
	if (USART2_ISR & BIT5) {
		usart2_rx();
	}
}

void usart2_rx(void) {
	// Handles usart2 receive
	RX_data = USART2_RDR;
	U2_RX_flag = 1;
}