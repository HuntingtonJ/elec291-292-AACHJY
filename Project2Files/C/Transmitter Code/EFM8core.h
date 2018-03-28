#include <stdio.h>
#include <stdlib.h>
#include <EFM8LB1.h>

#define SYSCLK      72000000L  // SYSCLK frequency in Hz


// Uses Timer3 to delay <us> micro-seconds. 
void Timer2us(unsigned char us)
{
	unsigned char i;               // usec counter
	
	SFRPAGE=0x00;
	// The input for Timer 3 is selected as SYSCLK by setting T3ML (bit 6) of CKCON0:
	CKCON0|=0b_0001_0000;
	
	TMR2RL = (-(SYSCLK)/1000000L); // Set Timer3 to overflow in 1us.
	TMR2 = TMR2RL;                 // Initialize Timer3 for first overflow
	
	TMR2CN0 = 0x04;                 // Start Timer3 and clear overflow flag

	for (i = 0; i < us; i++)       // Count <us> overflows
	{
		while (!(TMR2CN0 & 0x80));  // Wait for overflow
	
		TMR2CN0 &= ~(0x80);         // Clear overflow indicator
			
	}
	TMR2CN0 = 0 ;                   // Stop Timer3 and clear overflow flag
}

void waitms (unsigned int ms)
{
	unsigned int j;
	for(j=ms; j!=0; j--)
	{
		Timer2us(249);
		Timer2us(249);
		Timer2us(249);
		Timer2us(250);
	}
}

