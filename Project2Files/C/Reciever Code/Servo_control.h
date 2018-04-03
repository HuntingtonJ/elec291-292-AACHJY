#include <stdio.h>
#include <stdlib.h>

#define ON 	1
#define OFF 0

#define LiftUP 0b10000
#define LiftDOWN 0b10001

extern volatile unsigned char count_servo;
extern volatile unsigned char servo_duty_cycle;
extern volatile unsigned char duty_cycleLiftDOWN; //Servo Lifter Control
extern volatile unsigned char duty_cycleLiftUP; //Servo Lifter Control

void Timer2ISR(void);
int getsn (char * buff, int len);
void Servo_PWM(char DutyCycle);
void servo_update(unsigned char value);
