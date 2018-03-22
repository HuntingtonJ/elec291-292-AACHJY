//  Project 2 
//motor drive.c: Uses timer 2 interrupt to generate a square wave in pin
//  P2.0 and a 75% duty cycle wave in pin P2.1
//  Copyright (c) 2010-2018 Jesus Calvino-Fraga
//  ~C51~

#include <stdio.h>
#include <stdlib.h>
#include <EFM8LB1.h>

// ~C51~  

#define SYSCLK 72000000L
#define BAUDRATE 115200L

#define Mot1_forward P1_6
#define Mot1_reverse P1_7
#define Mot2_forward P1_3
#define Mot2_reverse P1_4

#define north 'w'
#define south 's'
#define west    'a'
#define east   'd'
#define NW      'e'
#define NE      'q'

#define CHARS_PER_LINE 16

//LCD Parameters
#define LCD_RS P2_6
// #define LCD_RW Px_x // Not used in this code.  Connect to GND
#define LCD_E  P2_5
#define LCD_D4 P2_4
#define LCD_D5 P2_3
#define LCD_D6 P2_2
#define LCD_D7 P2_1


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

void LCD_pulse (void)
{
	LCD_E=1;
	Timer3us(40);
	LCD_E=0;
}

void LCD_byte (unsigned char x)
{
	// The accumulator in the C8051Fxxx is bit addressable!
	ACC=x; //Send high nible
	LCD_D7=ACC_7;
	LCD_D6=ACC_6;
	LCD_D5=ACC_5;
	LCD_D4=ACC_4;
	LCD_pulse();
	Timer3us(40);
	ACC=x; //Send low nible
	LCD_D7=ACC_3;
	LCD_D6=ACC_2;
	LCD_D5=ACC_1;
	LCD_D4=ACC_0;
	LCD_pulse();
}

void WriteData (unsigned char x)
{
	LCD_RS=1;
	LCD_byte(x);
	waitms(2);
}

void WriteCommand (unsigned char x)
{
	LCD_RS=0;
	LCD_byte(x);
	waitms(5);
}

void LCD_4BIT (void)
{
	LCD_E=0; // Resting state of LCD's enable is zero
	// LCD_RW=0; // We are only writing to the LCD in this program
	waitms(20);
	// First make sure the LCD is in 8-bit mode and then change to 4-bit mode
	WriteCommand(0x33);
	WriteCommand(0x33);
	WriteCommand(0x32); // Change to 4-bit mode

	// Configure the LCD
	WriteCommand(0x28);
	WriteCommand(0x0c);
	WriteCommand(0x01); // Clear screen command (takes some time)
	waitms(20); // Wait for clear screen command to finsih.
}

void LCDprint(char * string, unsigned char line, bit clear)
{
	int j;

	WriteCommand(line==2?0xc0:0x80);
	waitms(5);
	for(j=0; string[j]!=0; j++)	WriteData(string[j]);// Write the message
	if(clear) for(; j<CHARS_PER_LINE; j++) WriteData(' '); // Clear the rest of the line
}

void LCDprint_inv(char * string, unsigned char line, bit clear)
{
	int j;
	int length=0;

	WriteCommand(line==2?0xc0:0x80);
	waitms(5);
	for(j=0; string[j]!=0; j++)	length++;
	for(j=length-1; j>=0; j--) WriteData(string[j]);// Write the message
	if(clear) for(; j<CHARS_PER_LINE; j++) WriteData(' '); // Clear the rest of the line
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
				break;
			}

			case south: 
			{
				go_reverse(speed);
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