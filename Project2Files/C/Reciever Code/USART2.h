#include <stdio.h>
#include <stdlib.h>
#include "serial.h"

extern volatile unsigned char RX_data;
extern volatile unsigned char U2_RX_flag;
extern volatile unsigned char U2_RXO_flag;
extern volatile unsigned char U2_RXNF_flag;

void initUSART2(int BaudRate);
void usart2_rx(void);
void usart2_rxo(void);
void usart2_rxnf(void);
void putc2(unsigned char c);