#include <stdio.h>
#include <stdlib.h>
#include <EFM8LB1.h>

#include "EFM8UART1lib.h"

#ifndef SYSCLK
#define SYSCLK      72000000L  // SYSCLK frequency in Hz
#endif

#define  SMB_FREQUENCY  100000L   // I2C SCL clock rate (10kHz to 100kHz)

#define OUT0 P2_0
#define OUT1 P1_6

// volatile unsigned char pwm_count = 0;
// volatile unsigned char duty_cycle0 = 50;
// volatile unsigned char duty_cycle1 = 0;

//OPCODES to send 

#define SPEED_OP 		0b000
#define DIRECTION_OP 	0b001
#define GRAB_OP 		0b001
#define LIGHTS_OP		0b010

bit reload_flag = 0;


//initialize timer0 for I2C clk synchronizations with the Wii Nunchuck
void Timer0_init(void){

	// Configure Timer 0 as the I2C clock source
	CKCON0 |= 0b_0000_0100; // Timer0 clock source = SYSCLK/12
	TMOD &= 0xf0;  // Mask out timer 1 bits
	TMOD |= 0x02;  // Timer0 in 8-bit auto-reload mode
	// Timer 0 configured to overflow at 1/3 the rate defined by SMB_FREQUENCY
	TL0 = TH0 = 256-(SYSCLK/SMB_FREQUENCY/3);
	TR0 = 1; // Enable timer 0
	//ET0=1; //Enable Timer 0 interrupts
	
}
//used for SCL clock generation of SMB0,
void Timer0_ISR (void) interrupt INTERRUPT_TIMER0 {
	TF0 = 0;
	SI=0;

}

//no current tasks
void Timer2_init(void) {
	TMR2CN0=0b_0000_0000;   // Stop Timer2; Clear TF2; T2XCLK uses Sysclk/12
	CKCON0|=0b_0000_0000; // Timer 2 uses the system clock; Timer2 uses T2XCLK
	TMR2RL=64936; //Initilizes reload value for 100hz;
	TMR2=0xffff;   // Set to reload immediately
	ET2=0;         // Enable Timer2 interrupts
	TR2=1;         // Start Timer2 (TMR2CN is bit addressable)
}

void Timer2_ISR (void) interrupt 5 {
	SFRPAGE=0x00;
	//reload_flag = 1;
	TF2H = 0; // Clear Timer2 interrupt flag
	
	// pwm_count++;
	// if(pwm_count>100) pwm_count=0;
	
	// OUT0=pwm_count>duty_cycle0?0:1;
	// reload_flag = 0;
}

/*void Timer3_init(void) {
	TMR3CN0=0b_0000_0000;   // Stop Timer3; Clear TF3; T3XCLK uses Sysclk/12
	CKCON0|=0b_0000_0000; // Timer 3 uses the system clock; Timer3 uses T2XCLK
	TMR3RL=64936; //Initilizes reload value for 100hz;
	TMR3=0xffff;   // Set to reload immediately
	//ET3=1;         // Enable Timer3 interrupts
	TR3=1;         // Start Timer3 (TMR3CN is bit addressable)

}*/



//used to generate output frequencies
void Timer4_init(void) {
	SFRPAGE=0x10;
	TMR4CN0=0b_0000_0000;
	TMR4CN1=0b_0110_0000;
	
	TMR4RL=65336; //reload = 2^16 - (SYSCLK/12)/(F*2); 15kHz
	TMR4=0xffff;
	
	EIE2|=0b_0000_0100;
	TR4=1;
	SFRPAGE=0x00;
}	

//minimized code in here to maximize possible frequencies 
void Timer4_ISR(void) interrupt INTERRUPT_TIMER4 {
	TF4H = 0; //interrupt flag
	
	OUT0 = !OUT0;
}

void sendCommand(unsigned char op, unsigned char value) {
	if (op < 0b_1000 && value < 0b_100000) {
		putchar1(op*0b_100000 + value);
		printf("Sent: %d\r\n", op*0b_100000 + value);
	} else {
		printf("c err\r\n");
	}
}

void sendCommandS(char* input) {
	unsigned char op;
	unsigned char d;
	
	sscanf(input, "%*s %c %c", &op, &d);
	
	switch(op) {
		case 's':
			op = 0;
			break;
		case 'f':
			op = 0b_001;
			break;
		case 'r':
			op = 0b_010;
			break;
		default:
			return;
	}
	sendCommand(op, d);
}


// void setDutyCycle(char* input, unsigned char op) {
// 	unsigned int duty;
// 	sscanf(input, "%*s %d", &duty);
// 	if (duty > 100)
// 		duty = 100;
		
// 	if (op == 0) {
// 		duty_cycle0 = (char)duty;
// 		printf("Duty Cycle 0 set to: %u\r\n", duty_cycle0);
// 	} else if (op == 1) {
// 		duty_cycle1 = (char)duty;
// 		printf("Duty Cycle 1 set to: %u\r\n", duty_cycle1);
// 	}
// }

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

// void setRotation(char* input) {
// 	unsigned int duty;
// 	sscanf(input, "%*s %u", &duty); 
	
// 	if (input[2] == 'w') {
// 		duty_cycle0 = (char)duty;
// 		duty_cycle1 = 0;
// 	}else if(input[2] == 'c') {
// 		duty_cycle1 = (char)duty;
// 		duty_cycle0 = 0;
// 	} else {
// 		printf("Invalid direction. Use -cw or -ccw\r\n");
// 	}
// }

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
			case '/':
				sendCommandS(input);
				break;

			// case 'c':
			// 	setRotation(input);
			// 	break;
			// case 'd':
			// 	if (input[2] == '0') {
			// 		setDutyCycle(input, 0);
			// 		break;
			// 	} else if (input[2] == '1') {
			// 		setDutyCycle(input, 1);
			// 		break;
			// 	}
			case 'f':
				setFrequency(input);
				break;
			case 'h':
				printf("Help Menu\r\nList of Commands: \r\n-cw [duty value]\r\n-ccw [duty value]\r\n-f [freq value]\r\n-r [reload value]\r\n-o\r\n-s\r\n-i\r\n\n");
				break;
			case 'i':
				printf("Reload: %u, Freq: %d \r\n", TMR2RL, reloadToFrequency(TMR2RL));

				break;
			case 'o':
			    if (input[2] == 0)
				    PWMoff();
				break;	
			case 'r':
				setReload(input);
				break;
			case 's':
				if (input[2] == 0)
					PWMon();
				break;
			case 't':
				putchar1(0b_1010_1010);
				break;
			default:
				printf("\"%s\" invalid command\r\n", input);
				break;
		}
	} else {
		printf("Not Valid input\r\n");
	}
	return;
}

void Tcom_init(unsigned long baudrate) {
	//Timer0_init(); //used for I2C clock source for nunchuck
	//timer 1 used for baudrate
	//Timer2_init(); //unused currently
	//timer 3 used for waitms...wrongly, actually used for SMBus- I2C bus for nunchuck

	Timer4_init(); //used for frequency-resolution interrupts
	
	//timer 5 unused
	UART1_Init(baudrate);

}

