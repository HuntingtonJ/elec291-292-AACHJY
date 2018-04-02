#include  "stm32f05xxx.h"
#include "Motor_control.h"
#include "Servo_control.h"

extern volatile unsigned char count=0;
extern volatile unsigned char duty_cycleLiftDOWN=25; //Servo Lifter Control
extern volatile unsigned char duty_cycleLiftUP=33; //Servo Lifter Control



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
void Timer2ISR(void)
{
	TIM2_SR &= ~BIT1; // clear update interrupt flag
  Servo_PWM(duty_cycleLiftDOWN);
}


void Servo_PWM(char DutyCycle){
  if (count== DutyCycle ){
    GPIOA_ODR ^= BIT8;
  }
  if (count== 100) {
    GPIOA_ODR |= BIT8;
    count=0
  }else{
    count++
  }
}


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
