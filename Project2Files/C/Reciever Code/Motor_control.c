#include  "stm32f05xxx.h"
#include "Motor_control.h"

unsigned char count = 0;
unsigned char duty_cycleLF = 75; //Left wheel forward
unsigned char duty_cycleLR = 0;  //Left wheel reverse (default 0)
unsigned char duty_cycleRF = 25; //Right wheel forward
unsigned char duty_cycleRR = 0;  //Right wheel reverse

// volatile unsigned char pwm_count=0;
// volatile unsigned char number1=0;
// volatile unsigned char number2=0; 
// volatile unsigned char number3=0;
// volatile unsigned char number4=0; 


// #define Mot1_forward P1_6
// #define Mot1_reverse P1_7
// #define Mot2_forward P1_3
// #define Mot2_reverse P1_4

// #define north 'w'
// #define south 's'
// #define west    'a'
// #define east   'd'
// #define NW      'e'
// #define NE      'q'

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

void Timer1ISR(void) 
{
	TIM1_SR &= ~BIT0; // clear update interrupt flag	
    
    TogglePins(); // toggle the state of the LED every second  
}

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

// void go_straight(char speed){
// 	//Let the speed will become the duty of both motors equally
// 	number1=speed;
// 	number3=speed;
// 	number2=0;
// 	number4=0;
// 	}

// void go_reverse(char speed){
// 	//Let the speed will become the duty of both motors equally
// 	number1=0;
// 	number3=0;
// 	number2=speed;
// 	number4=speed;
// 	}

// void turn_west(char speed){
// 	//Let the speed will become the duty of both motors equally
//     number1=0;
// 	number3=speed;
// 	number2=speed;
// 	number4=0;
// 	}

// void turn_east(char speed){
// 	//Let the speed will become the duty of both motors equally
// 	number1=speed;
// 	number3=0;
// 	number2=0;
// 	number4=speed;
// 	}

// void turn_NW(char speed){
// 	//Let the speed will become the duty of both motors equally
// 	number1=speed;
// 	number3=speed/2;
// 	number2=0;
// 	number4=0;
// 	}

// void turn_NE(char speed){
// 	//Let the speed will become the duty of both motors equally
// 	number1=speed/2;
// 	number3=speed;
// 	number2=0;
// 	number4=0;
// 	}

// void stop(){
    // number1=0;
	// number2=0;
	// number3=0;
	// number4=0;
	// }