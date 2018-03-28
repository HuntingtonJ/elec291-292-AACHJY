#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <EFM8LB1.h>

#include "Tcom.h"
#include "EFM8LCDlib.h"
#include "Nunchuck_reader.h"

#define BAUDRATE      115200L  // Baud rate of UART in bps
#define VDD 3.3122 // The measured value of VDD in volts

volatile unsigned bit offset_flag=1;
volatile unsigned bit speedbit=1;

char _c51_external_startup (void)
{
	// Disable Watchdog with key sequence
	
	SFRPAGE = 0x00;
	WDTCN = 0xDE; //First key
	WDTCN = 0xAD; //Second key
  
	VDM0CN |= 0x80;  // enable VDD mon
	RSTSRC = 0x02;

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

			#if (((SYSCLK/BAUDRATE)/(2L*12L))>0xFFL)
		#error Timer 0 reload value is incorrect because (SYSCLK/BAUDRATE)/(2L*12L) > 0xFF
	#endif
	

	// Configure Uart 0
	SCON0 = 0x10;
	CKCON0 |= 0b_0000_0000 ; // Timer 1 uses the system clock divided by 12.
	TH1 = 0x100-((SYSCLK/BAUDRATE)/(2L*12L));
	TL1 = TH1;      // Init Timer1
	TMOD &= ~0xf0;  // TMOD: timer 1 in 8-bit auto-reload
	TMOD |=  0x20;                       
	TR1 = 1; // START Timer1
	TI = 1;  // Indicate TX0 ready

	P0MDOUT |= 0x14; // Enable UART0 TX as push-pull output and UART1 Tx (pin 0.2)
	P1MDOUT |= 0xff; // Enable Push/Pull on port 1
	//P2MDOUT |= 0x01; //Push pull on pin 0
	XBR0     = 0b_0000_0101; // Enable UART0 on P0.4(TX) and P0.5(RX) and SMB0 I/O on (0.0 SDA) and (0.1 SCL)               
	XBR1     = 0x00; // Enable T0 on P0.0
	XBR2     = 0x41; // Enable crossbar and weak pull-ups .... (page 110) may need to set BIT0 to enable UART1 IO (0.2 Tx) and 0.3 RX

	Timer0_init();

	EA = 1;

		// Configure and enable SMBus
	SMB0CF = 0b_0101_1100; //INH | EXTHOLD | SMBTOE | SMBFTE ;
	SMB0CF |= 0b_1000_0000;  // Enable SMBus
	
	
	return 0;
}


int getsn (char * buff, int len){

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
	buff[j]=0;
	return len;
}

void main(void) {
	unsigned char buffer[6];
	char speed;
	char direction;
	int off_x=0;
	int off_y=0;
	offset_flag=1;


	Tcom_init(110L); //enter baudrate for UART1
	LCD_4BIT();


	waitms(200);
	nunchuck_init(1);
	waitms(100);

	if(offset_flag){
		nunchuck_getdata(buffer);
		off_x=(int)buffer[0]-128;
		off_y=(int)buffer[1]-128;
		printf("Offset_X:%4d Offset_Y:%4d\n\n", off_x, off_y);
		offset_flag=0; //clear offset flag, so not to re-get offset. 
	}

	waitms(500);
	//printf("\x1b[2J"); // Clear screen using ANSI escape sequence.
	printf("LAB 6 Microcontroller\r\nWith extra features\r\n\n");
	waitms(500);     
	//LCDprint("Duty cycle:", 1, 1);


	// printf("\x1b[2J\x1b[1;1H"); // Clear screen using ANSI escape sequence.
	// printf("\n\nEFM8LB1 WII Nunchuck I2C Reader\n");
while(1) {
		//sprintf(buffer, "%d%c %d%c", duty_cycle0, '%', duty_cycle1, '%');
		//LCDprint(buffer, 2, 1);
	

	// 	sprintf(buffer, "Test print");
	// 	LCDprint(buffer, 2, 1);

		
	//	printf("Enter command: \r\n");
	//	getsn(buffer, CHARS_PER_LINE);
	//	getCommand(buffer); //after use, is clear, only used within functions


		read_nunchuck(&direction, &speed, buffer, off_x, off_y);

		if(speedbit){
			sendCommand(SPEED_OP, speed);
			speedbit=0;
			}

		else {
		sendCommand(DIRECTION_OP, direction);
			speedbit=1;
		//printf("3\n\r");
		}

		printf("direction: %c   speed: %c \n", direction, speed);
	}	
}