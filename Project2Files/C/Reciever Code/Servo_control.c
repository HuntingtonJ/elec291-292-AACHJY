#include  "stm32f05xxx.h"
#include "Motor_control.h"
#include "Servo_control.h"

volatile unsigned char count_servo=0;
volatile unsigned char servo_duty_cycle = 33;
volatile unsigned char duty_cycleLiftDOWN=25; //Servo Lifter Control 
volatile unsigned char duty_cycleLiftUP=33; //Servo Lifter Control

void Timer2ISR(void)
{
	TIM2_SR &= ~BIT1; // clear update interrupt flag
  	Servo_PWM(servo_duty_cycle);
}


void Servo_PWM(char DutyCycle){
  if (count_servo >= DutyCycle ){
    GPIOA_ODR ^= BIT8;
  }
  if (count_servo == 100) {
    GPIOA_ODR |= BIT8;
    count_servo=0;
  } else {
    count_servo++;
  }
}

void servo_update(unsigned char value){
	switch(value) {
		case LiftUP: //Up 0b10001
			if (servo_duty_cycle < duty_cycleLiftUP) {
				servo_duty_cycle++;
			}
			break;
		case LiftDOWN: //Down 0b10000
			if (servo_duty_cycle > duty_cycleLiftDOWN) {
				servo_duty_cycle--;
			}
			break;
		default:
			break;
	}
}

/*
while (button){
	if (downflag==1){
		DutyCycle=duty_cycleLiftDOWN;
		direflag=0;
	}
	
	if (upflag==1){
		DutyCycle=duty_cycleLiftUP;
		direflag=1;
	}
}

if (direflag==1){
	upflag=0;
	downflag=1;
}
else{
	upflag=1;
	downflag=0;
}
*/
