#include "stm32f05xxx.h"
#include <stdio.h>
#include <stdlib.h>
#include "Motor_control.h"
#include "USART2.h"
#include "Servo_control.h"

#define SYSCLK 48000000L
#define DEF_F 100L
#define Servo_F 12500L
// unsigned char count = 0;
// unsigned char duty_cycleLF = 75; //Left wheel forward
// unsigned char duty_cycleLR = 0;  //Left wheel reverse (default 0)
// unsigned char duty_cycleRF = 25; //Right wheel forward
// unsigned char duty_cycleRR = 0;  //Right wheel reverse
//unsigned char opcode;
//unsigned char

int egets(char *s, int Max);


// Interrupt service routines are the same as normal
// subroutines (or C funtions) in Cortex-M microcontrollers.
// The following should happen at a rate of 1kHz.
// The following function is associated with the TIM1 interrupt
// via the interrupt vector table defined in startup.s
// void Timer1ISR(void)
// {
// 	TIM1_SR &= ~BIT0; // clear update interrupt flag
// 	TogglePins(); // toggle the state of the LED every second
// }

void SysInit(void)
{
	// Set up output port bit for blinking LED
	RCC_AHBENR |= 0x00020000;  // peripheral clock enable for port A
	GPIOA_MODER |= (BIT8 | BIT9| BIT10 | BIT11 | BIT12 | BIT14 | BIT16); // Make pin PAx output
	GPIOA_OTYPER &= ~( BIT4 | BIT5 | BIT6 | BIT7 | BIT8 );  //Set as push-pull, pins PA4-7=0
	//GPIOA_ODR |= ( BIT4 | BIT5| BIT6 | BIT7 );      //Set to 1


	// Set up timer
	RCC_APB2ENR |= BIT11; // turn on clock for timer1
	TIM1_ARR = (SYSCLK/8)/(100*(DEF_F/2));
	ISER |= BIT13;        // enable timer interrupts in the NVIC
	TIM1_CR1 |= BIT4;     // Downcounting
	TIM1_CR1 |= BIT0;     // enable counting
	TIM1_DIER |= BIT0;    // enable update event (reload event) interrupt

	RCC_APB1ENR |=BIT0;// turn on clock for timer2
	TIM2_ARR= (SYSCLK/8)/(Servo_F);
	TIM2_CR1 |= BIT4;     // Downcounting
	TIM2_CR1 |= BIT0;     // enable counting
	TIM2_DIER |= BIT0;    // enable update event (reload event) interrupt
	enable_interrupts();
}

void lights(unsigned char headflag, unsigned char tailflag, unsigned char Rindicflag, unsigned char Lindicflag){

	if(headflag == 1){
		GPIOA_ODR = BIT9;
	}else{
		GPIOA_ODR = ~(BIT9);
	}
	if(tailflag == 1){
		GPIOA_ODR = BIT10;
	}else{
		GPIOA_ODR = ~(BIT10);
	}
	if(Rindicflag == 1){
		GPIOA_ODR ^= BIT11;
	}else{
		GPIOA_ODR = ~(BIT11);
	}
	if(Lindicflag == 1){
		GPIOA_ODR ^= BIT12;
	}else{
		GPIOA_ODR = ~(BIT12);
	}
}

//Take RX_data value recieved from EFM8 and convert the char back to get the
//	opcode and the value as seen in Transmitter_src.c file
void Extract_op_val(unsigned char RX_data, unsigned char *speed, unsigned char *direction){
	unsigned char opcode, value;

	opcode = RX_data/(0b100000);
	value =  RX_data - opcode;

	printf("\t\t\tOpcode:%d\r\n", opcode);
	printf("\t\t\tValue:%d\r\n", value);

	switch(opcode){
		case 0b000:
			printf("\t\t\tSPEED_OP\n");
			*speed= value*(0b100);
			break;
		case 0b001:
			printf("\t\t\tDIRECTION_OP\n");
			*direction=(value-0b11111);
			break;
		case 0b010:
			printf("\t\t\tLIGHTS_OP\n");
			break;
		case 0b100:
			printf("\t\t\tGRAB_OP\n");
			servo_update(value);
			break;
		case 0b111:
			printf("\t\t\tSTOP_OP\n");
			*direction = 0b11111;
			break;
		default:
			printf("\t\t\tUnknown_OP\n");
			*direction = 0b11111;
			break;
	}

}

int main(void) {
    char buf[32];
    int newF, reload;
    unsigned char opcode, value;
    unsigned char speed, direction;
	unsigned char upflag=1, downflag=0;
	SysInit();

    printf("Magnetic Field Receiver.\r\n\r\n");

	while (1){
		//Receives data on Pin 9.
    	if (U2_RX_flag & 1) {
    		Extract_op_val(RX_data, &speed, &direction);
			printf("speed=%d, direction=%d\r\n", speed, direction);
			drive(speed, direction);
    		//printf("Received: %d\r\n", RX_data);
    		U2_RX_flag = 0;
    	}
    	if (U2_RXO_flag & 1) {
    		printf("Receive Overflow\r\n");
    		U2_RXO_flag = 0;
    	}
		lights(headflag, tailflag, Rindicflag, Lindicflag);

    	putc2(0x55);
	}
}
