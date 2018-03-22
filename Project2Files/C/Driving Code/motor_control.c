//  Project 2 
//motor drive.c: Uses timer 2 interrupt to generate a square wave in pin
//  P2.0 and a 75% duty cycle wave in pin P2.1
//  Copyright (c) 2010-2018 Jesus Calvino-Fraga
//  ~C51~



// EFM8_I2C_Nunchuck.c: Reads the WII nunchuck using the hardware I2C port
// available in the EFM8LB1 and sends them using the serial port.  The best
// information so far about the nunchuck is at:
//
// http://wiibrew.org/wiki/Wiimote/Extension_Controllers
// http://wiibrew.org/wiki/Wiimote/Extension_Controllers/Nunchuck
//
// Some good information was found also here:
//
// http://forum.arduino.cc/index.php/topic,45924.0.html
//
// By:  Jesus Calvino-Fraga (c) 2010-2018
//
// The next line clears the "C51 command line options:" field when compiling with CrossIDE
//  ~C51~  

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


volatile unsigned char pwm_count=0;
volatile unsigned char number1=0;
volatile unsigned char number2=0; 
volatile unsigned char number3=0;
volatile unsigned char number4=0; 


char _c51_external_startup (void)
{
	// Disable Watchdog with key sequence
	SFRPAGE = 0x00;
	WDTCN = 0xDE; //First key
	WDTCN = 0xAD; //Second key
  
	VDM0CN=0x80;       // enable VDD monitor
	RSTSRC=0x02|0x04;  // Enable reset on missing clock detector and VDD

	#if (SYSCLK == 48000000L)	
		SFRPAGE = 0x10;
		PFE0CN  = 0x10; // SYSCLK < 50 MHz.
		SFRPAGE = 0x00;
	#elif (SYSCLK == 72000000L)
		SFRPAGE = 0x10;
		PFE0CN  = 0x20; // SYSCLK < 75 MHz.
		SFRPAGE = 0x00;
	#endif
	
	#if (SYSCLK == 12250000L)
		CLKSEL = 0x10;
		CLKSEL = 0x10;
		while ((CLKSEL & 0x80) == 0);
	#elif (SYSCLK == 24500000L)
		CLKSEL = 0x00;
		CLKSEL = 0x00;
		while ((CLKSEL & 0x80) == 0);
	#elif (SYSCLK == 48000000L)	
		// Before setting clock to 48 MHz, must transition to 24.5 MHz first
		CLKSEL = 0x00;
		CLKSEL = 0x00;
		while ((CLKSEL & 0x80) == 0);
		CLKSEL = 0x07;
		CLKSEL = 0x07;
		while ((CLKSEL & 0x80) == 0);
	#elif (SYSCLK == 72000000L)
		// Before setting clock to 72 MHz, must transition to 24.5 MHz first
		CLKSEL = 0x00;
		CLKSEL = 0x00;
		while ((CLKSEL & 0x80) == 0);
		CLKSEL = 0x03;
		CLKSEL = 0x03;
		while ((CLKSEL & 0x80) == 0);
	#else
		#error SYSCLK must be either 12250000L, 24500000L, 48000000L, or 72000000L
	#endif
	
	P0MDOUT |= 0x10; // Enable UART0 TX as push-pull output
	XBR0     = 0x01; // Enable UART0 on P0.4(TX) and P0.5(RX)                     
	XBR1     = 0X00;
	XBR2     = 0x40; // Enable crossbar and weak pull-ups

	// Configure Uart 0
	#if (((SYSCLK/BAUDRATE)/(2L*12L))>0xFFL)
		#error Timer 0 reload value is incorrect because (SYSCLK/BAUDRATE)/(2L*12L) > 0xFF
	#endif
	SCON0 = 0x10;
	TH1 = 0x100-((SYSCLK/BAUDRATE)/(2L*12L));
	TL1 = TH1;      // Init Timer1
	TMOD &= ~0xf0;  // TMOD: timer 1 in 8-bit auto-reload
	TMOD |=  0x20;                       
	TR1 = 1; // START Timer1
	TI = 1;  // Indicate TX0 ready

	// Initialize timer 2 for periodic interrupts
	TMR2CN0=0x00;   // Stop Timer2; Clear TF2;
	CKCON0|=0b_0001_0000; // Timer 2 uses the system clock
	TMR2RL=(0x10000L-(SYSCLK/10000L)); // Initialize reload value ....Timer overflow rate (FREQ) found by SYSCLK/(2^16-TMR2RL)
	TMR2=0xffff;   // Set to reload immediately
	ET2=1;         // Enable Timer2 interrupts
	TR2=1;         // Start Timer2 (TMR2CN is bit addressable)

	EA=1; // Enable interrupts

  	
	return 0;
}	
void Timer3us(unsigned char us)
{
	unsigned char i;               // usec counter
	
	// The input for Timer 3 is selected as SYSCLK by setting T3ML (bit 6) of CKCON0:
	CKCON0|=0b_0100_0000;
	
	TMR3RL = (-(SYSCLK)/1000000L); // Set Timer3 to overflow in 1us.
	TMR3 = TMR3RL;                 // Initialize Timer3 for first overflow
	
	TMR3CN0 = 0x04;                 // Sart Timer3 and clear overflow flag
	for (i = 0; i < us; i++)       // Count <us> overflows
	{
		while (!(TMR3CN0 & 0x80));  // Wait for overflow
		TMR3CN0 &= ~(0x80);         // Clear overflow indicator
	}
	TMR3CN0 = 0 ;                   // Stop Timer3 and clear overflow flag
}

void waitms (unsigned int ms)
{
	unsigned int j;
	unsigned char k;
	for(j=0; j<ms; j++)
		for (k=0; k<4; k++) Timer3us(250);
}

int getsn (char * buff, int len)
{
	int j;
	char c;
	
	for(j=0; j<(len-1); j++)
	{
		c=getchar();
		if ( (c=='\n') || (c=='\r') )
		{
			buff[j]=0;
			return j;
		}
		else
		{
			buff[j]=c;
		}
	}
	buff[j]='\0';
	return len;
}

void Timer2_ISR (void) interrupt 5
{
	TF2H = 0; // Clear Timer2 interrupt flag
	
	pwm_count++;
	if(pwm_count>100) pwm_count=0;
	
	Mot1_forward=pwm_count>number1?0:1;
	Mot1_reverse=pwm_count>number2?0:1;

	Mot2_forward=pwm_count>number3?0:1;
	Mot2_reverse=pwm_count>number4?0:1;
}
/*
	void get_param(char array1,char array2,int array_size){
		printf("Enter a speed between 0 and 100\n"); 
		getsn(*array1, array_size); //numbers separated by an enter

		printf("Enter a direction between 0 and 100, 50 is neutral\n"); 
		getsn(*array2, array_size); //numbers separated by an enter


	
	}
*/
//a function that describes going straight
	void go_straight(char speed){
					//Let the speed will become the duty of both motors equally
		 			number1=speed;
			 		number3=speed;
			 		number2=0;
			 		number4=0;
			
		 		}

	void go_reverse(char speed){
					//Let the speed will become the duty of both motors equally
		 			number1=0;
			 		number3=0;
			 		number2=speed;
			 		number4=speed;
			
		 		}

	void turn_west(char speed){
					//Let the speed will become the duty of both motors equally
		 			number1=0;
			 		number3=speed;
			 		number2=speed;
			 		number4=0;
			
		 		}
	void turn_east(char speed){
					//Let the speed will become the duty of both motors equally
		 			number1=speed;
			 		number3=0;
			 		number2=0;
			 		number4=speed;
			
		 		}

	void turn_NW(char speed){
					//Let the speed will become the duty of both motors equally
		 			number1=speed;
			 		number3=speed/2;
			 		number2=0;
			 		number4=0;
			
		 		}

	void turn_NE(char speed){
					//Let the speed will become the duty of both motors equally
		 			number1=speed/2;
			 		number3=speed;
			 		number2=0;
			 		number4=0;
			
		 		}

	void stop(){

			number1=0;
			number2=0;
			number3=0;
			number4=0;
	}

	 
void main (void)
{

	char num1[ARRAY_SIZE];
	//char num2[ARRAY_SIZE]; 
	char speed=0;
	char direction;
	//char display[ARRAY_SIZE*2];
		

	// Wait for user to comply. Give putty a chance to start
	waitms(1000);

	printf("\x1b[2J"); // Clear screen using ANSI escape sequence.
	printf("Drive the car!\r\n"
	       "Use ASWDQE to control its direction! \r\n");

	 	printf("Enter a speed between 0 and 100\n"); 
		getsn(num1, ARRAY_SIZE); //numbers separated by an enter
	 
	 	//Loads speed variable
		sscanf(num1, "%i", &speed);



//forever
	while(1)
	{

//Gets speed and direction from terminal 
	// get_param(*num1, *num2, ARRAY_SIZE);
	 if(getchar()=='\r'){
	 	printf("Enter a speed between 0 and 100\n"); 
		getsn(num1, ARRAY_SIZE); //numbers separated by an enter
	 
	 	//Loads speed variable
		sscanf(num1, "%i", &speed);
}



		//printf("Enter a direction using the AWSD arrow keys\n"); 
		//getsn(num2, ARRAY_SIZE); //numbers separated by an enter


// is this necessray for multidirectional things? 
		/*
		Direction key: 
		#define north 'w'
		#define south 's'
		#define west    'a'
		#define NW      'e'
		#define NE      'q'
		#define east   'd'


		*/
		//loads up direction from 
		//sscanf(num2, "%c", &direction);
		
		direction=getchar();

		switch(direction){

			case north :
			{
				go_straight(speed);
				//headlight=ON;
				//taillight=OFF;
				break;
			}

			case south: 
			{
				go_reverse(speed);
				//headlight=ON;
				//taillight=ON;
				break;
			}

			case west: 
			{
				turn_west(speed);
				break;
			}

			case east: 
				{
					turn_east(speed);
					break;
				}

			case NW: 
				{
					turn_NW(speed);
					break;

				}

			case NE: 
				{ 
					turn_NE(speed);
					break;
					}

			default: 
				{
					stop();
					direction='x';
					break;
				}

		}
	direction='0'; //reset direction so it stops if no direction selected. 

		



	
	 // motor_control(speed, direction);

	  //New Architecture
	  //Speed remains constant until updated
	  //Direction is continually checked 


		//Check if numbers are greater than 100, throw error if so. 
	/*	
		if(speed>100||direction>100){
				printf("Error: Numbers need to be between 0 and 100, please enter again. \n");
				speed=0;
				direction=0;
				}*/		
		
		//printf("Speed: %i, Direction: %i \n", speed, direction); 
		
		
		
		
		


	}
}