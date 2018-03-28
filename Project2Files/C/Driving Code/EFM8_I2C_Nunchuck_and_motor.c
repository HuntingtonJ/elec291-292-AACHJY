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

//-10 to 10
#define north 'a'//00000
#define south 'b'//00001
//10 to 30 
#define NNE 'c'//00010
#define NNW 'd'//00011
//parameters to change motor driving ratios 
#define NNnum 

//30 to 50
#define NE 	'e'//00100
#define NW  'f'//00101
//parameters to change motor driving ratios 
#define midnum 2
#define middenom 3

//50 to 70 
#define NEE 'g'//00110
#define NWW 'h'//00111
//#define 

//70 to 90
#define east 'i'//01000
#define west 'j'//01001

//south directions: 
//10 to 30 
#define SSE 'k'//01010
#define SSW 'l'//01011
//30 to 50
#define SE 	'm'//01100
#define SW  'n'//01101

//50 to 70 
#define SEE 'o'//01110
#define SWW 'p'//01111


//SPEED CONSTANTS to SEND: 

#define speed0 'a' //00000
#define speed1 'b' //00001
#define speed2 'c' //00010
#define speed3 'd' //00011
#define speed4 'e' //00100
#define speed5 'f' //00101
#define speed6 'g' //00110
#define speed7 'h' //00111
#define speed8 'i' //01000
#define speed9 'j' //01001
#define speed10 'k' //01010
#define speed11 'l' //01011
#define speed12 'm' //01100
#define speed13 'n' //01101
#define speed14 'o' //01110
#define speed15 'p' //01111
#define speed16 'q' //10000

#define TRANSMISSION_SIZE 4

//#define 
//#define 

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

	#if ( ((SYSCLK/BAUDRATE)/(12L*2L)) > 0x100)
		#error Can not configure baudrate using timer 1 
	#endif
	// Configure Uart 0
	SCON0 = 0x10;
	TH1 = 0x100-((SYSCLK/BAUDRATE)/(12L*2L));
	TL1 = TH1;      // Init Timer1
	TMOD &= ~0xf0;  // TMOD: timer 1 in 8-bit auto-reload
	TMOD |=  0x20;                       
	TR1 = 1; // START Timer1
	TI = 1;  // Indicate TX0 ready


	P0MDOUT |= 0x10; // Enable UART0 TX as push-pull output
	XBR0 = 0b_0000_0101; // Enable SMBus pins and UART pins P0.4(TX) and P0.5(RX)
	XBR1 = 0X00;
	XBR2 = 0x40; // Enable crossbar and weak pull-ups

	// Configure Timer 0 as the I2C clock source
	CKCON0 |= 0b_0000_0100; // Timer0 clock source = SYSCLK
	TMOD &= 0xf0;  // Mask out timer 1 bits
	TMOD |= 0x02;  // Timer0 in 8-bit auto-reload mode
	// Timer 0 configured to overflow at 1/3 the rate defined by SMB_FREQUENCY
	TL0 = TH0 = 256-(SYSCLK/SMB_FREQUENCY/3);
	TR0 = 1; // Enable timer 0
	
		// Initialize timer 2 for periodic interrupts
	TMR2CN0=0x00;   // Stop Timer2; Clear TF2;
	CKCON0|=0b_0001_0000; // Timer 2 uses the system clock
	TMR2RL=(0x10000L-(SYSCLK/10000L)); // Initialize reload value ....Timer overflow rate (FREQ) found by SYSCLK/(2^16-TMR2RL)
	TMR2=0xffff;   // Set to reload immediately
	ET2=1;         // Enable Timer2 interrupts
	TR2=1;         // Start Timer2 (TMR2CN is bit addressable)

	EA=1; // Enable interrupts

  	
	
	// Configure and enable SMBus
	SMB0CF = 0b_0101_1100; //INH | EXTHOLD | SMBTOE | SMBFTE ;
	SMB0CF |= 0b_1000_0000;  // Enable SMBus

	return 0;
}

// Uses Timer4 to delay <ms> mili-seconds. 
void Timer4ms(unsigned char ms)
{
	unsigned char i;// usec counter
	unsigned char k;
	
	k=SFRPAGE;
	SFRPAGE=0x10;
	// The input for Timer 4 is selected as SYSCLK by setting bit 0 of CKCON1:
	CKCON1|=0b_0000_0001;
	
	TMR4RL = 65536-(SYSCLK/1000L); // Set Timer4 to overflow in 1 ms.
	TMR4 = TMR4RL;                 // Initialize Timer4 for first overflow
	
	TF4H=0; // Clear overflow flag
	TR4=1;  // Start Timer4
	for (i = 0; i < ms; i++)       // Count <ms> overflows
	{
		while (!TF4H);  // Wait for overflow
		TF4H=0;         // Clear overflow indicator
	}
	TR4=0; // Stop Timer4
	SFRPAGE=k;	
}

void I2C_write (unsigned char output_data)
{
	SMB0DAT = output_data; // Put data into buffer
	SI = 0;
	while (!SI); // Wait until done with send
}

unsigned char I2C_read (void)
{
	unsigned char input_data;

	SI = 0;
	while (!SI); // Wait until we have data to read
	input_data = SMB0DAT; // Read the data

	return input_data;
}

void I2C_start (void)
{
	ACK = 1;
	STA = 1;     // Send I2C start
	STO = 0;
	SI = 0;
	while (!SI); // Wait until start sent
	STA = 0;     // Reset I2C start
}

void I2C_stop(void)
{
	STO = 1;  	// Perform I2C stop
	SI = 0;	// Clear SI
	//while (!SI);	   // Wait until stop complete (Doesn't work???)
}

void nunchuck_init(bit print_extension_type)
{
	unsigned char i, buf[6];
	
	// Newer initialization format that works for all nunchucks
	I2C_start();
	I2C_write(0xA4);
	I2C_write(0xF0);
	I2C_write(0x55);
	I2C_stop();
	Timer4ms(1);
	 
	I2C_start();
	I2C_write(0xA4);
	I2C_write(0xFB);
	I2C_write(0x00);
	I2C_stop();
	Timer4ms(1);

	// Read the extension type from the register block.  For the original Nunchuk it should be
	// 00 00 a4 20 00 00.
	I2C_start();
	I2C_write(0xA4);
	I2C_write(0xFA); // extension type register
	I2C_stop();
	Timer4ms(3); // 3 ms required to complete acquisition

	I2C_start();
	I2C_write(0xA5);
	
	// Receive values
	for(i=0; i<6; i++)
	{
		buf[i]=I2C_read();
	}
	ACK=0;
	I2C_stop();
	Timer4ms(3);
	
	if(print_extension_type)
	{
		printf("Extension type: %02x  %02x  %02x  %02x  %02x  %02x\n", 
			buf[0],  buf[1], buf[2], buf[3], buf[4], buf[5]);
	}

	// Send the crypto key (zeros), in 3 blocks of 6, 6 & 4.

	I2C_start();
	I2C_write(0xA4);
	I2C_write(0xF0);
	I2C_write(0xAA);
	I2C_stop();
	Timer4ms(1);

	I2C_start();
	I2C_write(0xA4);
	I2C_write(0x40);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_stop();
	Timer4ms(1);

	I2C_start();
	I2C_write(0xA4);
	I2C_write(0x40);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_stop();
	Timer4ms(1);

	I2C_start();
	I2C_write(0xA4);
	I2C_write(0x40);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_stop();
	Timer4ms(1);
}

void nunchuck_getdata(unsigned char * s)
{
	unsigned char i;

	// Start measurement
	I2C_start();
	I2C_write(0xA4);
	I2C_write(0x00);
	I2C_stop();
	Timer4ms(3); 	// 3 ms required to complete acquisition

	// Request values
	I2C_start();
	I2C_write(0xA5);
	
	// Receive values
	for(i=0; i<6; i++)
	{
		s[i]=(I2C_read()^0x17)+0x17; // Read and decrypt
	}
	ACK=0;
	I2C_stop();
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
	
	//if pwm count> number {then output 0} else output 1
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

	void turn_west(char speed ){
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
		 			number1=speed/3;
			 		number3=speed*2;
			 		number2=0;
			 		number4=0;
			
		 		}

	void turn_NE(char speed){
					//Let the speed will become the duty of both motors equally
		 			number1=speed*2;
			 		number3=speed/3;
			 		number2=0;
			 		number4=0;
		 		}

	void turn_NNE(char speed){
					number1=speed;
			 		number3=speed/2;
			 		number2=0;
			 		number4=0;
				}

	void turn_NNW(char speed){
					number1=speed/2;
			 		number3=speed;
			 		number2=0;
			 		number4=0;
				}

	void turn_NEE(char speed){
					number1=speed;
			 		number3=speed/5;
			 		number2=0;
			 		number4=0;
				}

	void turn_NWW(char speed){
					number1=speed/5;
			 		number3=speed;
			 		number2=0;
			 		number4=0;
				}

	void turn_SW(char speed){
	//Let the speed will become the duty of both motors equally
		number1=0;
		number3=0;
		number2=speed/3;
		number4=speed;

	}


void turn_SE(char speed){
				//Let the speed will become the duty of both motors equally
	 			number1=0;
		 		number3=0;
		 		number2=speed;
		 		number4=speed/3;
	 		}

void turn_SSE(char speed){
				number1=0;
		 		number3=0;
		 		number2=speed;
		 		number4=speed/2;
			}

void turn_SSW(char speed){
				number1=0;
		 		number3=0;
		 		number2=speed/2;
		 		number4=speed;
			}

void turn_SEE(char speed){
				number1=0;
		 		number3=0;
		 		number2=speed;
		 		number4=speed/5;
			}

void turn_SWW(char speed){
				number1=0;
		 		number3=0;
		 		number2=speed/5;
		 		number4=speed;
			}




	void stop(){

			number1=0;
			number2=0;
			number3=0;
			number4=0;
			}

	char get_speed(int y_ax, int x_ax){
		char spd=0;
		y_ax=abs(y_ax);
		x_ax=abs(x_ax);
		
		if(y_ax>x_ax){
			spd=y_ax;
			if(y_ax>85)
				spd=100;
		}
		else spd=x_ax;

		return spd/TRANSMISSION_SIZE;
	}

	char get_direction(int x_axis, int y_axis){

			char direction=north;

			//FORWARD DIRECTION
			if(y_axis>0){
				//If distance is less than 10 from 0, go straight;
				if ((x_axis<10)&&(x_axis>-10)){

					//if y_axis is not significantly differnet than zero-stop
					if(y_axis>5&&y_axis>-5){
						 stop();
						}
					else direction=north;

				}

				else if(x_axis>10&&x_axis<=30){
					direction=NNE;
				}
				else if(x_axis>30&&x_axis<=50){
					direction=NE;
				}
				else if(x_axis>50&&x_axis<=70){
					direction=NEE;
				}
				else if(x_axis>70&&x_axis<=100){
					direction=east;
				}

				else if(x_axis<-10&&x_axis>=-30){
					direction=NNW;
				}
				else if(x_axis<-30&&x_axis>=-50){
					direction=NW;
				}
				else if(x_axis<-50&&x_axis>=-70){
					direction=NWW;
				}
				else if(x_axis<-70&&x_axis>=-110){
					direction=west;
				}
				else
					direction=north;
			}

			//SOUTH DIRECTIONs
		else if (y_axis<0){

			if ((x_axis<10)&&(x_axis>-10)){

				//if y_axis is not significantly differnet than zero-stop
				if(y_axis>5&&y_axis>-5){
					 stop();
					}
					else direction=south;

			}

			else if(x_axis>10&&x_axis<=30){
				direction=SSE;
			}
			else if(x_axis>30&&x_axis<=50){
				direction=SE;
			}
			else if(x_axis>50&&x_axis<=70){
				direction=SEE;
			}
			else if(x_axis>70&&x_axis<=100){
				direction=east;
			}

			else if(x_axis<-10&&x_axis>=-30){
				direction=SSW;
			}
			else if(x_axis<-30&&x_axis>=-50){
				direction=SW;
			}
			else if(x_axis<-50&&x_axis>=-80){
				direction=SWW;
			}
			else if(x_axis<-80&&x_axis>=-110){
				direction=west;
			}
			else
				direction=north;
		

		}
				

		return direction;
		}



void main (void)
{
	unsigned char rbuf[6];
 	int joy_x, joy_y, off_x, off_y, acc_x, acc_y, acc_z;
 	bit but1, but2;
 //	char num1[ARRAY_SIZE];
	char speed;
	char direction;
	//char display[ARRAY_SIZE*2];



	printf("\x1b[2J\x1b[1;1H"); // Clear screen using ANSI escape sequence.
	printf("\n\nEFM8LB1 WII Nunchuck I2C Reader\n");

	Timer4ms(200);
	nunchuck_init(1);
	Timer4ms(100);

	nunchuck_getdata(rbuf);

	off_x=(int)rbuf[0]-128;
	off_y=(int)rbuf[1]-128;
	printf("Offset_X:%4d Offset_Y:%4d\n\n", off_x, off_y);

	while(1)
	{
		nunchuck_getdata(rbuf);

		joy_x=(int)rbuf[0]-128-off_x;
		joy_y=(int)rbuf[1]-128-off_y;
		acc_x=rbuf[2]*4; 
		acc_y=rbuf[3]*4;
		acc_z=rbuf[4]*4;

		but1=(rbuf[5] & 0x01)?1:0;
		but2=(rbuf[5] & 0x02)?1:0;
		if (rbuf[5] & 0x04) acc_x+=2;
		if (rbuf[5] & 0x08) acc_x+=1;
		if (rbuf[5] & 0x10) acc_y+=2;
		if (rbuf[5] & 0x20) acc_y+=1;
		if (rbuf[5] & 0x40) acc_z+=2;
		if (rbuf[5] & 0x80) acc_z+=1;
		
//		printf("Buttons(Z:%c, C:%c) Joystick(%4d, %4d) Accelerometer(%3d, %3d, %3d)\x1b[0J\r",
		//	   but1?'1':'0', but2?'1':'0', joy_x, joy_y, acc_x, acc_y, acc_z);
		Timer4ms(100);


//Gets speed and direction from terminal 
	// get_param(*num1, *num2, ARRAY_SIZE);
	
	
		speed = get_speed(joy_y, joy_x);

	printf("speed: %i\n", speed);

		//loads up direction from 
		//sscanf(num2, "%c", &direction);
		
		direction=get_direction(joy_x, joy_y);
		printf("direction: %c", direction);

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

			case NNE: 
				{ 
					turn_NNE(speed);
					break;
					}

			case NNW: 
				{ 
					turn_NNW(speed);
					break;
					}

			case NE: 
				{ 
					turn_NE(speed);
					break;
					}

			case NEE: 
				{ 
					turn_NEE(speed);
					break;
					}

			case NWW: 
				{ 
					turn_NWW(speed);
					break;
					}


			case SW: 
				{
					turn_SW(speed);
					break;

				}

			case SSE: 
				{ 
					turn_SSE(speed);
					break;
					}

			case SSW: 
				{ 
					turn_SSW(speed);
					break;
					}

			case SE: 
				{ 
					turn_SE(speed);
					break;
					}

			case SEE: 
				{ 
					turn_SEE(speed);
					break;
					}

			case SWW: 
				{ 
					turn_SWW(speed);
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

		


   }
}
