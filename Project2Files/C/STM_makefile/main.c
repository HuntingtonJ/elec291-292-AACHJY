#include "stm32f05xxx.h"
#include "serial.h"
//#include "newlib_stubs.h"
#include <stdio.h>
#include <stdlib.h>


// #define SYSCLK 72000000L
// #define BAUDRATE 115200L
// #define  SMB_FREQUENCY  100000L   // I2C SCL clock rate (10kHz to 100kHz)

// #define Mot1_forward P1_6
// #define Mot1_reverse P1_7
// #define Mot2_forward P1_3
// #define Mot2_reverse P1_4

#define ON 	1
#define OFF 0

#define north 'w'
#define south 's'
#define west    'a'
#define east   'd'
#define NW      'e'
#define NE      'q'

#define headlight //pin?;
#define taillight //pin?

#define CHARS_PER_LINE 16

#define ARRAY_SIZE 4

volatile unsigned char pwm_count=0;
volatile unsigned char number1=0;
volatile unsigned char number2=0; 
volatile unsigned char number3=0;
volatile unsigned char number4=0; 


// Interrupt service routines are the same as normal
// subroutines (or C funtions) in Cortex-M microcontrollers.
// The following should happen at a rate of 1kHz.
// The following function is associated with the TIM1 interrupt 
// via the interrupt vector table defined in startup.s
void Timer1ISR(void) 
{
	TIM1_SR &= ~BIT0; // clear update interrupt flag

	pwm_count++;
	if(pwm_count>100) pwm_count=0;
	
	if(pwm_count>number1){
		GPIOA_ODR = BIT0;
	}else{
		GPIOA_ODR != BIT0;
	}
	if(pwm_count>number2){
		GPIOA_ODR = BIT1;
	}else{
		GPIOA_ODR != BIT1;
	}
	if(pwm_count>number2){
		GPIOA_ODR = BIT2;
	}else{
		GPIOA_ODR != BIT2;
	}
	if(pwm_count>number3){
		GPIOA_ODR = BIT3;
	}else{
		GPIOA_ODR != BIT3;
	}
}

void SysInit(void)
{
	// Set up output port bit for blinking LED
	RCC_AHBENR |= 0x00020000;  // peripheral clock enable for port A
	GPIOA_MODER |= 0x00000055; // Make pin PA0-3 output
	
	// Set up timer
	RCC_APB2ENR |= BIT11; // turn on clock for timer1
	TIM1_ARR = 8000;      // reload counter with 8000 at each overflow (equiv to 1ms)
	ISER |= BIT13;        // enable timer interrupts in the NVIC
	TIM1_CR1 |= BIT4;     // Downcounting    
	TIM1_CR1 |= BIT0;     // enable counting    
	TIM1_DIER |= BIT0;    // enable update event (reload event) interrupt  
	enable_interrupts();
}

//same as EFM8 Code
int getsn (char * buff, int len)
{
	int j;
	char c;
	
	for(j=0; j<(len-1); j++)
	{
		c=getchar();
		if ( (c=='\n') || (c=='\r') )
		{
			buff[j]=0;
			return j;
		}
		else
		{
			buff[j]=c;
		}
	}
	buff[j]='\0';
	return len;
}

//a function that describes going straight
void go_straight(char speed){
				//Let the speed will become the duty of both motors equally
	 			number1=speed;
		 		number3=speed;
		 		number2=0;
		 		number4=0;
		
	 		}

void go_reverse(char speed){
				//Let the speed will become the duty of both motors equally
	 			number1=0;
		 		number3=0;
		 		number2=speed;
		 		number4=speed;
		
	 		}

void turn_west(char speed){
				//Let the speed will become the duty of both motors equally
	 			number1=0;
		 		number3=speed;
		 		number2=speed;
		 		number4=0;
		
	 		}
void turn_east(char speed){
				//Let the speed will become the duty of both motors equally
	 			number1=speed;
		 		number3=0;
		 		number2=0;
		 		number4=speed;
		
	 		}

void turn_NW(char speed){
				//Let the speed will become the duty of both motors equally
	 			number1=speed;
		 		number3=speed/2;
		 		number2=0;
		 		number4=0;
		
	 		}

void turn_NE(char speed){
				//Let the speed will become the duty of both motors equally
	 			number1=speed/2;
		 		number3=speed;
		 		number2=0;
		 		number4=0;
		
	 		}

void stop(){

		number1=0;
		number2=0;
		number3=0;
		number4=0;
}


void main(void)
{
	printf("yo\n");
	SysInit();
	char num1[ARRAY_SIZE];
	//char num2[ARRAY_SIZE]; 
	char speed=0;
	char direction;
	//char display[ARRAY_SIZE*2];
		

	// Wait for user to comply. Give putty a chance to start
	//waitms(1000);

	printf("\x1b[2J"); // Clear screen using ANSI escape sequence.
	printf("Drive the car!\r\n"
	       "Use ASWDQE to control its direction! \r\n");

	 	printf("Enter a speed between 0 and 100\n"); 
		getsn(num1, ARRAY_SIZE); //numbers separated by an enter
	 
	 	//Loads speed variable
		sscanf(num1, "%i", &speed);



//forever
	while(1)
	{

//Gets speed and direction from terminal 
	// get_param(*num1, *num2, ARRAY_SIZE);
	 if(getchar()=='\r'){
	 	printf("Enter a speed between 0 and 100\n"); 
		getsn(num1, ARRAY_SIZE); //numbers separated by an enter
	 
	 	//Loads speed variable
		sscanf(num1, "%i", &speed);
	}
		//printf("Enter a direction using the AWSD arrow keys\n"); 
		//getsn(num2, ARRAY_SIZE); //numbers separated by an enter
		// is this necessray for multidirectional things? 
		/*	
		Direction key: 
		#define north 'w'
		#define south 's'
		#define west    'a'
		#define NW      'e'
		#define NE      'q'
		#define east   'd'		*/
		//loads up direction from 
		//sscanf(num2, "%c", &direction);
		
		direction=getchar();

		switch(direction){

			case north :
			{
				go_straight(speed);
				//headlight=ON;
				//taillight=OFF;
				break;
			}

			case south: 
			{
				go_reverse(speed);
				//headlight=ON;
				//taillight=ON;
				break;
			}

			case west: 
			{
				turn_west(speed);
				break;
			}

			case east: 
				{
					turn_east(speed);
					break;
				}

			case NW: 
				{
					turn_NW(speed);
					break;

				}

			case NE: 
				{ 
					turn_NE(speed);
					break;
					}

			default: 
				{
					stop();
					direction='x';
					break;
				}

		}
	direction='0'; //reset direction so it stops if no direction selected. 
	 // motor_control(speed, direction)
	  //New Architecture
	  //Speed remains constant until updated
	  //Direction is continually checked 
		//Check if numbers are greater than 100, throw error if so. 
	/*	
		if(speed>100||direction>100){
				printf("Error: Numbers need to be between 0 and 100, please enter again. \n");
				speed=0;
				direction=0;
				}*/		
		//printf("Speed: %i, Direction: %i \n", speed, direction); 
	}
}
