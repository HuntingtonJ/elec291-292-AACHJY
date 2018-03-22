#include <stdio.h>
#include <stdlib.h>
#include <EFM8LB1.h>

// ~C51~  

#define SYSCLK 72000000L
#define BAUDRATE 115200L
#define  SMB_FREQUENCY  100000L   // I2C SCL clock rate (10kHz to 100kHz)


#define Mot1_forward P1_6
#define Mot1_reverse P1_7
#define Mot2_forward P1_3
#define Mot2_reverse P1_4

#define ON 	1
#define OFF 0

#define north 'w'
#define south 's'
#define west    'a'
#define east   'd'
#define NW      'e'
#define NE      'q'

#define headlight //pin?;
#define taillight //pin?

#define CHARS_PER_LINE 16

#define ARRAY_SIZE 4


char _c51_external_startup (void)