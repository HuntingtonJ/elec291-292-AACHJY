#include <stdio.h>
#include <stdlib.h>
#include "serial.h"

extern unsigned char count;
extern unsigned char duty_cycleLF; //Left wheel forward
extern unsigned char duty_cycleLR;  //Left wheel reverse (default 0)
extern unsigned char duty_cycleRF; //Right wheel forward
extern unsigned char duty_cycleRR;  //Right wheel reverse

// extern volatile unsigned char pwm_count;
// extern volatile unsigned char number1;
// extern volatile unsigned char number2; 
// extern volatile unsigned char number3;
// extern volatile unsigned char number4;

int getsn (char * buff, int len);  
void TogglePins(void);
// void go_straight(char speed);
// void go_reverse(char speed);
// void turn_west(char speed);
// void turn_east(char speed);
// void turn_NW(char speed);
// void turn_NE(char speed);
// void stop();