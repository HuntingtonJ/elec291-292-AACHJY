#include <stdio.h>
#include <stdlib.h>
#include "serial.h"

extern volatile unsigned char count;
extern volatile unsigned char duty_cycleLF; //Left wheel forward
extern volatile unsigned char duty_cycleLR;  //Left wheel reverse (default 0)
extern volatile unsigned char duty_cycleRF; //Right wheel forward
extern volatile unsigned char duty_cycleRR;  //Right wheel reverse

// extern volatile unsigned char pwm_count;
// extern volatile unsigned char number1;
// extern volatile unsigned char number2; 
// extern volatile unsigned char number3;
// extern volatile unsigned char number4;

int getsn (char * buff, int len);  
void TogglePins(void);
void go_straight(char speed);
void go_reverse(char speed);
void turn_west(char speed);
void turn_east(char speed);
void turn_NW(char speed);
void turn_NE(char speed);
void turn_NNE(char speed);
void turn_NNW(char speed);
void turn_NEE(char speed);
void turn_NWW(char speed);
void turn_SW(char speed);
void turn_SE(char speed);
void turn_SSE(char speed);
void turn_SSW(char speed);
void turn_SEE(char speed);
void turn_SWW(char speed);

void stop();

void drive(unsigned char speed, unsigned char direction);