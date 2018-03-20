#include <stdio.h>
#include <stdlib.h>
#include <EFM8LB1.h>

#define SYSCLK      72000000L  // SYSCLK frequency in Hz

#define OUT0 P2_0
#define OUT1 P1_7

volatile unsigned char pwm_count = 0;
volatile unsigned char duty_cycle0 = 0;
volatile unsigned char duty_cycle1 = 0;

bit reload_flag = 0;

void Timer2_init(void) {
	TMR2CN0=0b_0000_0000;   // Stop Timer2; Clear TF2; T2XCLK uses Sysclk/12
	CKCON0|=0b_0000_0000; // Timer 2 uses the system clock; Timer2 uses T2XCLK
	TMR2RL=64936; //Initilizes reload value for 100hz;
	TMR2=0xffff;   // Set to reload immediately
	ET2=1;         // Enable Timer2 interrupts
	TR2=1;         // Start Timer2 (TMR2CN is bit addressable)
}

void Timer2_ISR (void) interrupt 5 {
	reload_flag = 1;
	TF2H = 0; // Clear Timer2 interrupt flag
	
	pwm_count++;
	if(pwm_count>100) pwm_count=0;
	
	OUT0=pwm_count>duty_cycle0?0:1;
	OUT1=pwm_count>duty_cycle1?0:1;
	reload_flag = 0;
}

void setDutyCycle(char* input, unsigned char op) {
	unsigned int duty;
	sscanf(input, "%*s %d", &duty);
	if (duty > 100)
		duty = 100;
		
	if (op == 0) {
		duty_cycle0 = (char)duty;
		printf("Duty Cycle 0 set to: %u\r\n", duty_cycle0);
	} else if (op == 1) {
		duty_cycle1 = (char)duty;
		printf("Duty Cycle 1 set to: %u\r\n", duty_cycle1);
	}
}

unsigned int frequencyToReload(unsigned int freq) {
	return 65536 - (60000/(freq));
}

unsigned int reloadToFrequency(unsigned int reload) {
	return ((SYSCLK/12)/(65536 - reload))/100;
}

void setFrequency(char* input) {
	unsigned int frequency;
	sscanf(input, "%*s %u", &frequency);
	while(reload_flag != 0);
	TMR2RL = frequencyToReload(frequency);
}

void setReload(char* input) {
	unsigned int reload;
	sscanf(input, "%*s %u", &reload);
	while(reload_flag != 0);
	TMR2RL = reload;
}

void setRotation(char* input) {
	unsigned int duty;
	sscanf(input, "%*s %u", &duty); 
	
	if (input[2] == 'w') {
		duty_cycle0 = (char)duty;
		duty_cycle1 = 0;
	}else if(input[2] == 'c') {
		duty_cycle1 = (char)duty;
		duty_cycle0 = 0;
	} else {
		printf("Invalid direction. Use -cw or -ccw\r\n");
	}
}

void PWMoff() {
	OUT0 = 0;
	OUT1 = 0;
	TR2 = 0;
}

void PWMon() {
	TR2 = 1;
}

void getCommand(char* input) {
	//printf("\~ %s\r\n", input);
	if (input[0] == '-') {
		switch(input[1]) {
			case 'c':
				setRotation(input);
				break;
			case 'd':
				if (input[2] == '0') {
					setDutyCycle(input, 0);
					break;
				} else if (input[2] == '1') {
					setDutyCycle(input, 1);
					break;
				}
			case 'f':
				setFrequency(input);
				break;
			case 'h':
				printf("Help Menu\r\nList of Commands: \r\n-cw [duty value]\r\n-ccw [duty value]\r\n-d0 [duty value]\r\n-d1 [duty value]\r\n-f [freq value]\r\n-r [reload value]\r\n-o\r\n-s\r\n-i\r\n\n");
				break;
			case 'i':
				printf("Reload: %u, Freq: %d, duty0: %d, duty1: %d\r\n", TMR2RL, reloadToFrequency(TMR2RL), duty_cycle0, duty_cycle1);
				break;
			case 'r':
				setReload(input);
				break;
			case 's':
				if (input[2] == 0)
					PWMon();
				break;
			case 'o':
			    if (input[2] == 0)
				    PWMoff();
				break;
			default:-
				printf("\"%s\" invalid command\r\n", input);
				break;
		}
	} else {
		printf("Not Valid input\r\n");
	}
	return;
}