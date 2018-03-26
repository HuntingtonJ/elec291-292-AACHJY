#include "stm32f05xxx.h"
#include <stdio.h>
#include <stdlib.h>

#include "USART2.h"

#define SYSCLK 48000000L
#define DEF_F 15000L

int egets(char *s, int Max);

void TogglePin(void) 
{    
	GPIOA_ODR ^= 0x00000001; // Toggle PA0
}


// Interrupt service routines are the same as normal
// subroutines (or C funtions) in Cortex-M microcontrollers.
// The following should happen at a rate of 1kHz.
// The following function is associated with the TIM1 interrupt 
// via the interrupt vector table defined in startup.s
void Timer1ISR(void)
{
	TIM1_SR &= ~BIT0; // clear update interrupt flag
	TogglePin(); // toggle the state of the LED every second
}

void SysInit(void)
{
	// Set up output port bit for blinking LED
	RCC_AHBENR |= 0x00020000;  // peripheral clock enable for port A
	GPIOA_MODER |= 0x00000001; // Make pin PA0 output
	
	// Set up timer
	RCC_APB2ENR |= BIT11; // turn on clock for timer1
	TIM1_ARR = SYSCLK/(DEF_F*2L);
	ISER |= BIT13;        // enable timer interrupts in the NVIC
	TIM1_CR1 |= BIT4;     // Downcounting    
	TIM1_CR1 |= BIT0;     // enable counting    
	TIM1_DIER |= BIT0;    // enable update event (reload event) interrupt  
	enable_interrupts();
}

int main(void) {
    char buf[32];
    int newF, reload;

	SysInit();
	
    printf("Magnetic Field Receiver.\r\n\r\n");
	
	while (1){
		//Receives data on Pin 9.
    	if (U2_RX_flag & 1) {
    		printf("Recieved: %d\r\n", RX_data);
    		U2_RX_flag = 0;
    	}
	}
}
