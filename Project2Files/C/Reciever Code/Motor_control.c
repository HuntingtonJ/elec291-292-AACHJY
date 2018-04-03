#include  "stm32f05xxx.h"
#include "Motor_control.h"

volatile unsigned char count = 0;
volatile unsigned char duty_cycleLF = 0; //Left wheel forward
volatile unsigned char duty_cycleLR = 0;  //Left wheel reverse (default 0)
volatile unsigned char duty_cycleRF = 0; //Right wheel forward
volatile unsigned char duty_cycleRR = 0;  //Right wheel reverse

unsigned char headflag=0, tailflag=0, Rindicflag=0, Lindicflag=0;


// #define Mot1_forward P1_6
// #define Mot1_reverse P1_7
// #define Mot2_forward P1_3
// #define Mot2_reverse P1_4

#define ON 	1
#define OFF 0

//-10 to 10
#define north 0b00000//'a'
#define south 0b00001// 'b'
//10 to 30 
#define NNE 0b00010//'c'//00010
#define NNW 0b00011//'d'//00011
//parameters to change motor driving ratios 
#define NNnum 

//30 to 50
#define NE 0b00100//	'e'//00100
#define NW 0b00101 // 'f'//00101
//parameters to change motor driving ratios 
#define midnum 2
#define middenom 3

//50 to 70 
#define NEE 0b00110 //'g'//00110
#define NWW 0b00111 //'h'//00111
//#define 

//70 to 90
#define east 0b01000  //'i'//01000
#define west 0b01001 //'j'//01001

//south directions: 
//10 to 30 
#define SSE 0b01010//'k'//01010
#define SSW 0b01011 //'l'//01011
//30 to 50
#define SE 	0b01100 //'m'//01100
#define SW  0b01101 //'n'//01101

//50 to 70 
#define SEE 0b01110 //'o'//01110
#define SWW 0b01111 //'p'//01111

//Unknow OP recieved, drive function goes stationary 
#define uknownOP 0b11111

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
		GPIOA_ODR ^= BIT4;	//&= ~( BIT4 );
	} 
	
	if (count == duty_cycleLR) {
		GPIOA_ODR ^= BIT5;	//&= ~( BIT5 );
	}
	
	if (count == duty_cycleRF) {
		GPIOA_ODR ^= BIT6;	//&= ~( BIT6 );
	}
	
	if (count == duty_cycleRR) {
		GPIOA_ODR ^= BIT7;	//&= ~( BIT7 );
	}
	
	if (count == 100) {
		GPIOA_ODR |= ( BIT4 | BIT5| BIT6 | BIT7 );
		count = 0;
	} else {
		count++;
	}	
}

void lights(void){
	if(headflag == 1){
		GPIOA_ODR |= BIT14;
	} else {
		GPIOA_ODR &= ~(BIT14);
	}
	if(tailflag == 1){
		GPIOA_ODR |= BIT13;
	} else {
		GPIOA_ODR &= ~(BIT13);
	}
	if(Rindicflag == 1){
		GPIOA_ODR |= BIT12;
	} else {
		GPIOA_ODR &= ~(BIT12);
	}
	if(Lindicflag == 1){
		GPIOA_ODR |= BIT11;
	} else {
		GPIOA_ODR &= ~(BIT11);
	}
}

//a function that describes going straight
void go_straight(char speed){
	//Let the speed will become the duty of both motors equally
	duty_cycleLF=speed;
	duty_cycleRF=speed;
	duty_cycleLR=0;
	duty_cycleRR=0;
}

void go_reverse(char speed){
	//Let the speed will become the duty of both motors equally
	duty_cycleLF=0;
	duty_cycleRF=0;
	duty_cycleLR=speed;
	duty_cycleRR=speed;
}

void turn_west(char speed ){
	//Let the speed will become the duty of both motors equally
	duty_cycleLF=0;
	duty_cycleRF=speed;
	duty_cycleLR=speed;
	duty_cycleRR=0;
}
	 		
void turn_east(char speed){
	//Let the speed will become the duty of both motors equally
	duty_cycleLF=speed;
	duty_cycleRF=0;
	duty_cycleLR=0;
	duty_cycleRR=speed;

}

void turn_NW(char speed){
	//Let the speed will become the duty of both motors equally
	duty_cycleLF=speed/3;
	duty_cycleRF=speed*2;
	duty_cycleLR=0;
	duty_cycleRR=0;

}

void turn_NE(char speed){
	//Let the speed will become the duty of both motors equally
	duty_cycleLF=speed*2;
	duty_cycleRF=speed/3;
	duty_cycleLR=0;
	duty_cycleRR=0;
}

void turn_NNE(char speed){
	duty_cycleLF=speed;
	duty_cycleRF=speed/2;
	duty_cycleLR=0;
	duty_cycleRR=0;
}

void turn_NNW(char speed){
	duty_cycleLF=speed/2;
	duty_cycleRF=speed;
	duty_cycleLR=0;
	duty_cycleRR=0;
}

void turn_NEE(char speed){
	duty_cycleLF=speed;
	duty_cycleRF=speed/5;
	duty_cycleLR=0;
	duty_cycleRR=0;
}

void turn_NWW(char speed){
	duty_cycleLF=speed/5;
	duty_cycleRF=speed;
	duty_cycleLR=0;
	duty_cycleRR=0;
}

void turn_SW(char speed){
//Let the speed will become the duty of both motors equally
	duty_cycleLF=0;
	duty_cycleRF=0;
	duty_cycleLR=speed/3;
	duty_cycleRR=speed;

}


void turn_SE(char speed){
	//Let the speed will become the duty of both motors equally
	duty_cycleLF=0;
	duty_cycleRF=0;
	duty_cycleLR=speed;
	duty_cycleRR=speed/3;
}

void turn_SSE(char speed){
	duty_cycleLF=0;
	duty_cycleRF=0;
	duty_cycleLR=speed;
	duty_cycleRR=speed/2;
}

void turn_SSW(char speed){
	duty_cycleLF=0;
	duty_cycleRF=0;
	duty_cycleLR=speed/2;
	duty_cycleRR=speed;
}

void turn_SEE(char speed){
	duty_cycleLF=0;
	duty_cycleRF=0;
	duty_cycleLR=speed;
	duty_cycleRR=speed/5;
}

void turn_SWW(char speed){
	duty_cycleLF=0;
	duty_cycleRF=0;
	duty_cycleLR=speed/5;
	duty_cycleRR=speed;
}


void stop(){
	duty_cycleLF=0;
	duty_cycleLR=0;
	duty_cycleRF=0;
	duty_cycleRR=0;
}

void drive(unsigned char speed, unsigned char direction){
	switch(direction){
		case north :
			go_straight(speed);
			printf("carson likes fish\r\n");
			//headflag = 1;
			//tailflag = 0;
			//Rindicflag = 0;
			//Lindicflag = 0;
			GPIOA_ODR |= BIT14;
			GPIOA_ODR &= ~( BIT11 | BIT12 | BIT13 );
			break;
		case south: 
			go_reverse(speed);
			printf("go reverse\n");
			//headflag = 0;
			//tailflag = 1;
			//Rindicflag = 0;
			//Lindicflag = 0;
			GPIOA_ODR |= BIT13;
			GPIOA_ODR &= ~( BIT11 | BIT12 | BIT14 );
			break;
		case west: 
			turn_west(speed);
			printf("turn west\n");
			//headflag = 1;
			//tailflag = 0;
			//Rindicflag = 0;
			//Lindicflag = 1;
			GPIOA_ODR |= ( BIT11 | BIT14 );
			GPIOA_ODR &= ~( BIT12 | BIT13 );
			break;
		case east: 
			turn_east(speed);
			printf("turn east\n");
			//headflag = 1;
			//tailflag = 0;
			//Rindicflag = 1;
			//Lindicflag = 0;
			GPIOA_ODR |= ( BIT12 | BIT14 );
			GPIOA_ODR &= ~( BIT11 | BIT13 );
			break;
		case NW: 
			turn_NW(speed);
			printf("turn nw\n");
			//headflag = 1;
			//tailflag = 0;
			//Rindicflag = 0;
			//Lindicflag = 1;
			GPIOA_ODR |= ( BIT11 | BIT14 );
			GPIOA_ODR &= ~( BIT12 | BIT13 );
			break;
		case NNE: 
			turn_NNE(speed);
			printf("turn nne\n");
			//headflag = 1;
			//tailflag = 0;
			//Rindicflag = 1;
			//Lindicflag = 0;
			GPIOA_ODR |= ( BIT12 | BIT14 );
			GPIOA_ODR &= ~( BIT11 | BIT13 );
			break;
		case NNW: 
			turn_NNW(speed);
			printf("turn nnw\n");
			//headflag = 1;
			//tailflag = 0;
			//Rindicflag = 0;
			//Lindicflag = 1;
			GPIOA_ODR |= ( BIT11 | BIT14 );
			GPIOA_ODR &= ~( BIT12 | BIT13 );
			break;
		case NE: 
			turn_NE(speed);
			printf("turn ne\n");
			// headflag = 1;
			// tailflag = 0;
			// Rindicflag = 1;
			// Lindicflag = 0;
			GPIOA_ODR |= ( BIT12 | BIT14 );
			GPIOA_ODR &= ~( BIT11 | BIT13 );
			break;
		case NEE: 
			turn_NEE(speed);
			printf("turn nee\n");
			// headflag = 1;
			// tailflag = 0;
			// Rindicflag = 1;
			// Lindicflag = 0;
			GPIOA_ODR |= ( BIT12 | BIT14 );
			GPIOA_ODR &= ~( BIT11 | BIT13 );
			break;
		case NWW: 
			turn_NWW(speed);
			printf("turn nww\n");
			// headflag = 1;
			// tailflag = 0;
			// Rindicflag = 0;
			// Lindicflag = 1;
			GPIOA_ODR |= ( BIT11 | BIT14 );
			GPIOA_ODR &= ~( BIT12 | BIT13 );
			break;
		case SW: 
			turn_SW(speed);
			printf("turn sw\n");
			// headflag = 0;
			// tailflag = 1;
			// Rindicflag = 0;
			// Lindicflag = 1;
			GPIOA_ODR |= ( BIT11 | BIT13 );
			GPIOA_ODR &= ~( BIT12 | BIT14 );
			break;
		case SSE: 
			turn_SSE(speed);
			printf("turn sse\n");
			// headflag = 0;
			// tailflag = 1;
			// Rindicflag = 1;
			// Lindicflag = 0;
			GPIOA_ODR |= ( BIT12 | BIT13 );
			GPIOA_ODR &= ~( BIT11 | BIT14 );
			break;
		case SSW: 
			turn_SSW(speed);
			printf("turn ssw\n");
			// headflag = 0;
			// tailflag = 1;
			// Rindicflag = 0;
			// Lindicflag = 1;
			GPIOA_ODR |= ( BIT11 | BIT13 );
			GPIOA_ODR &= ~( BIT12 | BIT14 );
			break;
		case SE: 
			turn_SE(speed);
			printf("turn se\n");
			// headflag = 0;
			// tailflag = 1;
			// Rindicflag = 1;
			// Lindicflag = 0;
			GPIOA_ODR |= ( BIT12 | BIT13 );
			GPIOA_ODR &= ~( BIT11 | BIT14 );
			break;
		case SEE: 
			turn_SEE(speed);
			printf("turn see\n");
			// headflag = 0;
			// tailflag = 1;
			// Rindicflag = 1;
			// Lindicflag = 0;
			GPIOA_ODR |= ( BIT12 | BIT13 );
			GPIOA_ODR &= ~( BIT11 | BIT14 );
			break;
		case SWW: 
			turn_SWW(speed);
			printf("turn sww\n");
			// headflag = 0;
			// tailflag = 1;
			// Rindicflag = 0;
			// Lindicflag = 1;
			GPIOA_ODR |= ( BIT11 | BIT13 );
			GPIOA_ODR &= ~( BIT12 | BIT14 );
			break;
		case uknownOP:
			printf("Drive Stationary\r\n");
			// headflag = 0;
			// tailflag = 0;
			// Rindicflag = 1;
			// Lindicflag = 1;
			GPIOA_ODR |= ( BIT11 | BIT12 );
			GPIOA_ODR &= ~( BIT13 | BIT14 );
			stop();
			break;
		default: 
			stop();
			direction='x';
			printf("default\r\n");
			// headflag = 0;
			// tailflag = 0;
			// Rindicflag = 0;
			// Lindicflag = 0;
			GPIOA_ODR &= ~( BIT11 | BIT12 | BIT13 | BIT14 );
			break;
	}
}

