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

// ~C51~  

//#include "EFM8core.h"
#include <EFM8LB1.h>

#define SYSCLK 72000000L
#define BAUDRATE 115200L


#define Mot1_forward P1_6
#define Mot1_reverse P1_7
#define Mot2_forward P1_3
#define Mot2_reverse P1_4

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
#define SW  0b01100 //'n'//01101

//50 to 70 
#define SEE 0b01110 //'o'//01110
#define SWW 0b01111 //'p'//01111

//#define 
//#define 

#define headlight //pin?;
#define taillight //pin?

#define TRANSMISSION_SIZE 4

//#define CHARS_PER_LINE 16
extern volatile bit offset_flag;


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
	waitms(1);
	 
	I2C_start();
	I2C_write(0xA4);
	I2C_write(0xFB);
	I2C_write(0x00);
	I2C_stop();
	waitms(1);

	// Read the extension type from the register block.  For the original Nunchuk it should be
	// 00 00 a4 20 00 00.
	I2C_start();
	I2C_write(0xA4);
	I2C_write(0xFA); // extension type register
	I2C_stop();
	waitms(3); // 3 ms required to complete acquisition

	I2C_start();
	I2C_write(0xA5);
	
	// Receive values
	for(i=0; i<CHARS_PER_LINE; i++)
	{
		buf[i]=I2C_read();
	}
	ACK=0;
	I2C_stop();
	waitms(3);
	
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
	waitms(1);

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
	waitms(1);

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
	waitms(1);

	I2C_start();
	I2C_write(0xA4);
	I2C_write(0x40);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_stop();
	waitms(1);
}

void nunchuck_getdata(unsigned char * s)
{
	unsigned char i;

	// Start measurement
	I2C_start();
	I2C_write(0xA4);
	I2C_write(0x00);
	I2C_stop();
	waitms(3); 	// 3 ms required to complete acquisition

	// Request values
	I2C_start();
	I2C_write(0xA5);
	
	// Receive values
	for(i=0; i<CHARS_PER_LINE; i++)
	{
		s[i]=(I2C_read()^0x17)+0x17; // Read and decrypt
	}
	ACK=0;
	I2C_stop();
}




char get_speed(char x_ax, char y_ax){
		char spd;
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

char get_direction(char x_axis, char y_axis){

			char direction=north;

			//FORWARD DIRECTION
			if(y_axis>0){
				//If distance is less than 10 from 0, go straight;
				if ((x_axis<10)&&(x_axis>-10)){

					//if y_axis is not significantly differnet than zero-stop
					if(y_axis>5&&y_axis>-5){
						 direction=north;
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
					 direction=south;
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



bit read_nunchuck(char * direction, char * speed, char * rbuf, int off_x, int off_y)
{
	//unsigned char rbuf[6];
 	char joy_x, joy_y;
 	bit Z_but, but2;
 //	char num1[ARRAY_SIZE];
	// int speed;
	// char direction;
	//char display[ARRAY_SIZE*2];
	// waitms(200);
	// nunchuck_init(1);
	// waitms(100);


	// printf("\x1b[2J\x1b[1;1H"); // Clear screen using ANSI escape sequence.
	// printf("\n\nEFM8LB1 WII Nunchuck I2C Reader\n");


//	while(1)
	
		nunchuck_getdata(rbuf);

	//	printf("rbuf0: %i, rbuf1: %i \n\r", (int) rbuf[0], (int) rbuf[1]);
		

		joy_x=(int)rbuf[0]-128-off_x;
		joy_y=(int)rbuf[1]-128-off_y;
		// acc_x=rbuf[2]*4; 
		// acc_y=rbuf[3]*4;
		// acc_z=rbuf[4]*4;

		Z_but=(rbuf[5] & 0x01)?1:0;
		but2=(rbuf[5] & 0x02)?1:0;
		// if (rbuf[5] & 0x04) acc_x+=2;
		// if (rbuf[5] & 0x08) acc_x+=1;
		// if (rbuf[5] & 0x10) acc_y+=2;
		// if (rbuf[5] & 0x20) acc_y+=1;
		// if (rbuf[5] & 0x40) acc_z+=2;
		// if (rbuf[5] & 0x80) acc_z+=1;
		
	//	printf("Buttons(Z:%c, C:%c) Joystick(%4d, %4d)\r",
	//		   Z_but?'1':'0', but2?'1':'0', joy_x, joy_y);
		waitms(100); //determine if we want to change this length
	

		//

		*direction=get_direction(joy_x, joy_y);
		*speed = get_speed(joy_x, joy_y);
		
		return Z_but;

   }

