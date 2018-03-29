#include <stdio.h>
#include <stdlib.h>
#include "serial.h"

extern unsigned char count;
extern unsigned char duty_cycleLF; //Left wheel forward
extern unsigned char duty_cycleLR;  //Left wheel reverse (default 0)
extern unsigned char duty_cycleRF; //Right wheel forward
extern unsigned char duty_cycleRR;  //Right wheel reverse


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