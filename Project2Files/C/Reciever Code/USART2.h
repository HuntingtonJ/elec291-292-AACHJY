#include <stdio.h>
#include <stdlib.h>
#include "serial.h"

extern volatile unsigned char RX_data;
extern volatile unsigned char U2_RX_flag;

void initUSART2(int BaudRate);
void usart2_rx(void);