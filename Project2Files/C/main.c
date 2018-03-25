#include "stm32f05xxx.h"

void ToggleLED(void);
volatile int Count = 0;

// Interrupt service routines are the same as normal
// subroutines (or C funtions) in Cortex-M microcontrollers.
// The following should happen at a rate of 1kHz.
// The following function is associated with the TIM1 interrupt 
// via the interrupt vector table defined in startup.s
void Timer1ISR(void) 
{
	TIM1_SR &= ~BIT0; // clear update interrupt flag
	Count++;
	if (Count > 500)
	{ 
		Count = 0;
		ToggleLED(); // toggle the state of the LED every second
	}   
}

void SysInit(void)
{
	// Set up output port bit for blinking LED
	RCC_AHBENR |= 0x00020000;  // peripheral clock enable for port A
	GPIOA_MODER |= 0x00000001; // Make pin PA0 output
	
	// Set up timer
	RCC_APB2ENR |= BIT11; // turn on clock for timer1
	TIM1_ARR = 8000;      // reload counter with 8000 at each overflow (equiv to 1ms)
	ISER |= BIT13;        // enable timer interrupts in the NVIC
	TIM1_CR1 |= BIT4;     // Downcounting    
	TIM1_CR1 |= BIT0;     // enable counting    
	TIM1_DIER |= BIT0;    // enable update event (reload event) interrupt  
	enable_interrupts();
}

void ToggleLED(void) 
{    
	GPIOA_ODR ^= BIT0; // Toggle PA0
}

int main(void)
{
	SysInit();
	while(1)
	{    
	}
	return 0;
}
