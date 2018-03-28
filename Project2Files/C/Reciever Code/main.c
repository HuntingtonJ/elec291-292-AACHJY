#include "stm32f05xxx.h"
#include <stdio.h>
#include <stdlib.h>

#include "USART2.h"

#define SYSCLK 48000000L
#define DEF_F 5000L

unsigned char count = 0;
unsigned char duty_cycleLF = 75; //Left wheel forward
unsigned char duty_cycleLR = 0;  //Left wheel reverse (default 0)
unsigned char duty_cycleRF = 25; //Right wheel forward
unsigned char duty_cycleRR = 0;  //Right wheel reverse

int egets(char *s, int Max);

void TogglePins(void) 
{    
	if (count == duty_cycleLF) {
		GPIOA_ODR &= ~( BIT4 );
	} 
	
	if (count == duty_cycleLR) {
		GPIOA_ODR &= ~( BIT5 );
	}
	
	if (count == duty_cycleRF) {
		GPIOA_ODR &= ~( BIT6 );
	}
	
	if (count == duty_cycleRR) {
		GPIOA_ODR &= ~( BIT7 );
	}
	
	if (count == 100) {
		GPIOA_ODR |= ( BIT4 | BIT5| BIT6 | BIT7 );
		count = 0;
	} else {
		count++;
	}	
}


// Interrupt service routines are the same as normal
// subroutines (or C funtions) in Cortex-M microcontrollers.
// The following should happen at a rate of 1kHz.
// The following function is associated with the TIM1 interrupt 
// via the interrupt vector table defined in startup.s
void Timer1ISR(void)
{
	TIM1_SR &= ~BIT0; // clear update interrupt flag
	TogglePins(); // toggle the state of the LED every second
}

void SysInit(void)
{
	// Set up output port bit for blinking LED
	RCC_AHBENR |= 0x00020000;  // peripheral clock enable for port A
	GPIOA_MODER |= ( BIT8 | BIT10 | BIT12 | BIT14); // Make pin PAx output
	GPIOA_OTYPER &= ~( BIT4 | BIT5 | BIT6 | BIT7);  //Set as push-pull
	//GPIOA_ODR |= ( BIT4 | BIT5| BIT6 | BIT7 );      //Set to 1
	
	
	// Set up timer
	RCC_APB2ENR |= BIT11; // turn on clock for timer1
	TIM1_ARR = (SYSCLK/4)/(DEF_F*2L);
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
    		printf("Received: %d\r\n", RX_data);
    		U2_RX_flag = 0;
    	}
    	if (U2_RXO_flag & 1) {
    		printf("Receive Overflow\r\n");
    		U2_RXO_flag = 0;
    	}
    	putc2(0x55);
	}
}
