#include <stdio.h>
#include <stdlib.h>
#include "serial.h"

extern volatile unsigned char count;
extern volatile unsigned char duty_cycleLift;

#define ON 	1
#define OFF 0

#define LiftUP 0b10000
#define LiftDOWN 0b10001
extern volatile unsigned char duty_cycleLiftDOWN=25; //Servo Lifter Control
extern volatile unsigned char duty_cycleLiftUP=33; //Servo Lifter Control

void Timer2ISR(void);
int getsn (char * buff, int len);
void Servo_PWM(char DutyCycle);
