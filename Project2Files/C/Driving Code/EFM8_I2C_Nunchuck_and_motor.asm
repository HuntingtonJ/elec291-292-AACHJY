;--------------------------------------------------------
; File Created by C51
; Version 1.0.0 #1069 (Apr 23 2015) (MSVC)
; This file was generated Thu Mar 22 19:16:06 2018
;--------------------------------------------------------
$name EFM8_I2C_Nunchuck_and_motor
$optc51 --model-small
	R_DSEG    segment data
	R_CSEG    segment code
	R_BSEG    segment bit
	R_XSEG    segment xdata
	R_PSEG    segment xdata
	R_ISEG    segment idata
	R_OSEG    segment data overlay
	BIT_BANK  segment data overlay
	R_HOME    segment code
	R_GSINIT  segment code
	R_IXSEG   segment xdata
	R_CONST   segment code
	R_XINIT   segment code
	R_DINIT   segment code

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	public _main
	public _get_direction
	public _get_speed
	public _stop
	public _turn_NWW
	public _turn_NEE
	public _turn_NNW
	public _turn_NNE
	public _turn_NE
	public _turn_NW
	public _turn_east
	public _turn_west
	public _go_reverse
	public _go_straight
	public _Timer2_ISR
	public _getsn
	public _waitms
	public _Timer3us
	public _nunchuck_getdata
	public _nunchuck_init
	public _I2C_stop
	public _I2C_start
	public _I2C_read
	public _I2C_write
	public _Timer4ms
	public __c51_external_startup
	public _nunchuck_init_PARM_1
	public _get_direction_PARM_2
	public _getsn_PARM_2
	public _number4
	public _number3
	public _number2
	public _number1
	public _pwm_count
;--------------------------------------------------------
; Special Function Registers
;--------------------------------------------------------
_ACC            DATA 0xe0
_ADC0ASAH       DATA 0xb6
_ADC0ASAL       DATA 0xb5
_ADC0ASCF       DATA 0xa1
_ADC0ASCT       DATA 0xc7
_ADC0CF0        DATA 0xbc
_ADC0CF1        DATA 0xb9
_ADC0CF2        DATA 0xdf
_ADC0CN0        DATA 0xe8
_ADC0CN1        DATA 0xb2
_ADC0CN2        DATA 0xb3
_ADC0GTH        DATA 0xc4
_ADC0GTL        DATA 0xc3
_ADC0H          DATA 0xbe
_ADC0L          DATA 0xbd
_ADC0LTH        DATA 0xc6
_ADC0LTL        DATA 0xc5
_ADC0MX         DATA 0xbb
_B              DATA 0xf0
_CKCON0         DATA 0x8e
_CKCON1         DATA 0xa6
_CLEN0          DATA 0xc6
_CLIE0          DATA 0xc7
_CLIF0          DATA 0xe8
_CLKSEL         DATA 0xa9
_CLOUT0         DATA 0xd1
_CLU0CF         DATA 0xb1
_CLU0FN         DATA 0xaf
_CLU0MX         DATA 0x84
_CLU1CF         DATA 0xb3
_CLU1FN         DATA 0xb2
_CLU1MX         DATA 0x85
_CLU2CF         DATA 0xb6
_CLU2FN         DATA 0xb5
_CLU2MX         DATA 0x91
_CLU3CF         DATA 0xbf
_CLU3FN         DATA 0xbe
_CLU3MX         DATA 0xae
_CMP0CN0        DATA 0x9b
_CMP0CN1        DATA 0x99
_CMP0MD         DATA 0x9d
_CMP0MX         DATA 0x9f
_CMP1CN0        DATA 0xbf
_CMP1CN1        DATA 0xac
_CMP1MD         DATA 0xab
_CMP1MX         DATA 0xaa
_CRC0CN0        DATA 0xce
_CRC0CN1        DATA 0x86
_CRC0CNT        DATA 0xd3
_CRC0DAT        DATA 0xcb
_CRC0FLIP       DATA 0xcf
_CRC0IN         DATA 0xca
_CRC0ST         DATA 0xd2
_DAC0CF0        DATA 0x91
_DAC0CF1        DATA 0x92
_DAC0H          DATA 0x85
_DAC0L          DATA 0x84
_DAC1CF0        DATA 0x93
_DAC1CF1        DATA 0x94
_DAC1H          DATA 0x8a
_DAC1L          DATA 0x89
_DAC2CF0        DATA 0x95
_DAC2CF1        DATA 0x96
_DAC2H          DATA 0x8c
_DAC2L          DATA 0x8b
_DAC3CF0        DATA 0x9a
_DAC3CF1        DATA 0x9c
_DAC3H          DATA 0x8e
_DAC3L          DATA 0x8d
_DACGCF0        DATA 0x88
_DACGCF1        DATA 0x98
_DACGCF2        DATA 0xa2
_DERIVID        DATA 0xad
_DEVICEID       DATA 0xb5
_DPH            DATA 0x83
_DPL            DATA 0x82
_EIE1           DATA 0xe6
_EIE2           DATA 0xf3
_EIP1           DATA 0xbb
_EIP1H          DATA 0xee
_EIP2           DATA 0xed
_EIP2H          DATA 0xf6
_EMI0CN         DATA 0xe7
_FLKEY          DATA 0xb7
_HFO0CAL        DATA 0xc7
_HFO1CAL        DATA 0xd6
_HFOCN          DATA 0xef
_I2C0ADM        DATA 0xff
_I2C0CN0        DATA 0xba
_I2C0DIN        DATA 0xbc
_I2C0DOUT       DATA 0xbb
_I2C0FCN0       DATA 0xad
_I2C0FCN1       DATA 0xab
_I2C0FCT        DATA 0xf5
_I2C0SLAD       DATA 0xbd
_I2C0STAT       DATA 0xb9
_IE             DATA 0xa8
_IP             DATA 0xb8
_IPH            DATA 0xf2
_IT01CF         DATA 0xe4
_LFO0CN         DATA 0xb1
_P0             DATA 0x80
_P0MASK         DATA 0xfe
_P0MAT          DATA 0xfd
_P0MDIN         DATA 0xf1
_P0MDOUT        DATA 0xa4
_P0SKIP         DATA 0xd4
_P1             DATA 0x90
_P1MASK         DATA 0xee
_P1MAT          DATA 0xed
_P1MDIN         DATA 0xf2
_P1MDOUT        DATA 0xa5
_P1SKIP         DATA 0xd5
_P2             DATA 0xa0
_P2MASK         DATA 0xfc
_P2MAT          DATA 0xfb
_P2MDIN         DATA 0xf3
_P2MDOUT        DATA 0xa6
_P2SKIP         DATA 0xcc
_P3             DATA 0xb0
_P3MDIN         DATA 0xf4
_P3MDOUT        DATA 0x9c
_PCA0CENT       DATA 0x9e
_PCA0CLR        DATA 0x9c
_PCA0CN0        DATA 0xd8
_PCA0CPH0       DATA 0xfc
_PCA0CPH1       DATA 0xea
_PCA0CPH2       DATA 0xec
_PCA0CPH3       DATA 0xf5
_PCA0CPH4       DATA 0x85
_PCA0CPH5       DATA 0xde
_PCA0CPL0       DATA 0xfb
_PCA0CPL1       DATA 0xe9
_PCA0CPL2       DATA 0xeb
_PCA0CPL3       DATA 0xf4
_PCA0CPL4       DATA 0x84
_PCA0CPL5       DATA 0xdd
_PCA0CPM0       DATA 0xda
_PCA0CPM1       DATA 0xdb
_PCA0CPM2       DATA 0xdc
_PCA0CPM3       DATA 0xae
_PCA0CPM4       DATA 0xaf
_PCA0CPM5       DATA 0xcc
_PCA0H          DATA 0xfa
_PCA0L          DATA 0xf9
_PCA0MD         DATA 0xd9
_PCA0POL        DATA 0x96
_PCA0PWM        DATA 0xf7
_PCON0          DATA 0x87
_PCON1          DATA 0xcd
_PFE0CN         DATA 0xc1
_PRTDRV         DATA 0xf6
_PSCTL          DATA 0x8f
_PSTAT0         DATA 0xaa
_PSW            DATA 0xd0
_REF0CN         DATA 0xd1
_REG0CN         DATA 0xc9
_REVID          DATA 0xb6
_RSTSRC         DATA 0xef
_SBCON1         DATA 0x94
_SBRLH1         DATA 0x96
_SBRLL1         DATA 0x95
_SBUF           DATA 0x99
_SBUF0          DATA 0x99
_SBUF1          DATA 0x92
_SCON           DATA 0x98
_SCON0          DATA 0x98
_SCON1          DATA 0xc8
_SFRPAGE        DATA 0xa7
_SFRPGCN        DATA 0xbc
_SFRSTACK       DATA 0xd7
_SMB0ADM        DATA 0xd6
_SMB0ADR        DATA 0xd7
_SMB0CF         DATA 0xc1
_SMB0CN0        DATA 0xc0
_SMB0DAT        DATA 0xc2
_SMB0FCN0       DATA 0xc3
_SMB0FCN1       DATA 0xc4
_SMB0FCT        DATA 0xef
_SMB0RXLN       DATA 0xc5
_SMB0TC         DATA 0xac
_SMOD1          DATA 0x93
_SP             DATA 0x81
_SPI0CFG        DATA 0xa1
_SPI0CKR        DATA 0xa2
_SPI0CN0        DATA 0xf8
_SPI0DAT        DATA 0xa3
_SPI0FCN0       DATA 0x9a
_SPI0FCN1       DATA 0x9b
_SPI0FCT        DATA 0xf7
_SPI0PCF        DATA 0xdf
_TCON           DATA 0x88
_TH0            DATA 0x8c
_TH1            DATA 0x8d
_TL0            DATA 0x8a
_TL1            DATA 0x8b
_TMOD           DATA 0x89
_TMR2CN0        DATA 0xc8
_TMR2CN1        DATA 0xfd
_TMR2H          DATA 0xcf
_TMR2L          DATA 0xce
_TMR2RLH        DATA 0xcb
_TMR2RLL        DATA 0xca
_TMR3CN0        DATA 0x91
_TMR3CN1        DATA 0xfe
_TMR3H          DATA 0x95
_TMR3L          DATA 0x94
_TMR3RLH        DATA 0x93
_TMR3RLL        DATA 0x92
_TMR4CN0        DATA 0x98
_TMR4CN1        DATA 0xff
_TMR4H          DATA 0xa5
_TMR4L          DATA 0xa4
_TMR4RLH        DATA 0xa3
_TMR4RLL        DATA 0xa2
_TMR5CN0        DATA 0xc0
_TMR5CN1        DATA 0xf1
_TMR5H          DATA 0xd5
_TMR5L          DATA 0xd4
_TMR5RLH        DATA 0xd3
_TMR5RLL        DATA 0xd2
_UART0PCF       DATA 0xd9
_UART1FCN0      DATA 0x9d
_UART1FCN1      DATA 0xd8
_UART1FCT       DATA 0xfa
_UART1LIN       DATA 0x9e
_UART1PCF       DATA 0xda
_VDM0CN         DATA 0xff
_WDTCN          DATA 0x97
_XBR0           DATA 0xe1
_XBR1           DATA 0xe2
_XBR2           DATA 0xe3
_XOSC0CN        DATA 0x86
_DPTR           DATA 0x8382
_TMR2RL         DATA 0xcbca
_TMR3RL         DATA 0x9392
_TMR4RL         DATA 0xa3a2
_TMR5RL         DATA 0xd3d2
_TMR0           DATA 0x8c8a
_TMR1           DATA 0x8d8b
_TMR2           DATA 0xcfce
_TMR3           DATA 0x9594
_TMR4           DATA 0xa5a4
_TMR5           DATA 0xd5d4
_SBRL1          DATA 0x9695
_PCA0           DATA 0xfaf9
_PCA0CP0        DATA 0xfcfb
_PCA0CP1        DATA 0xeae9
_PCA0CP2        DATA 0xeceb
_PCA0CP3        DATA 0xf5f4
_PCA0CP4        DATA 0x8584
_PCA0CP5        DATA 0xdedd
_ADC0ASA        DATA 0xb6b5
_ADC0GT         DATA 0xc4c3
_ADC0           DATA 0xbebd
_ADC0LT         DATA 0xc6c5
_DAC0           DATA 0x8584
_DAC1           DATA 0x8a89
_DAC2           DATA 0x8c8b
_DAC3           DATA 0x8e8d
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
_ACC_0          BIT 0xe0
_ACC_1          BIT 0xe1
_ACC_2          BIT 0xe2
_ACC_3          BIT 0xe3
_ACC_4          BIT 0xe4
_ACC_5          BIT 0xe5
_ACC_6          BIT 0xe6
_ACC_7          BIT 0xe7
_TEMPE          BIT 0xe8
_ADGN0          BIT 0xe9
_ADGN1          BIT 0xea
_ADWINT         BIT 0xeb
_ADBUSY         BIT 0xec
_ADINT          BIT 0xed
_IPOEN          BIT 0xee
_ADEN           BIT 0xef
_B_0            BIT 0xf0
_B_1            BIT 0xf1
_B_2            BIT 0xf2
_B_3            BIT 0xf3
_B_4            BIT 0xf4
_B_5            BIT 0xf5
_B_6            BIT 0xf6
_B_7            BIT 0xf7
_C0FIF          BIT 0xe8
_C0RIF          BIT 0xe9
_C1FIF          BIT 0xea
_C1RIF          BIT 0xeb
_C2FIF          BIT 0xec
_C2RIF          BIT 0xed
_C3FIF          BIT 0xee
_C3RIF          BIT 0xef
_D1SRC0         BIT 0x88
_D1SRC1         BIT 0x89
_D1AMEN         BIT 0x8a
_D01REFSL       BIT 0x8b
_D3SRC0         BIT 0x8c
_D3SRC1         BIT 0x8d
_D3AMEN         BIT 0x8e
_D23REFSL       BIT 0x8f
_D0UDIS         BIT 0x98
_D1UDIS         BIT 0x99
_D2UDIS         BIT 0x9a
_D3UDIS         BIT 0x9b
_EX0            BIT 0xa8
_ET0            BIT 0xa9
_EX1            BIT 0xaa
_ET1            BIT 0xab
_ES0            BIT 0xac
_ET2            BIT 0xad
_ESPI0          BIT 0xae
_EA             BIT 0xaf
_PX0            BIT 0xb8
_PT0            BIT 0xb9
_PX1            BIT 0xba
_PT1            BIT 0xbb
_PS0            BIT 0xbc
_PT2            BIT 0xbd
_PSPI0          BIT 0xbe
_P0_0           BIT 0x80
_P0_1           BIT 0x81
_P0_2           BIT 0x82
_P0_3           BIT 0x83
_P0_4           BIT 0x84
_P0_5           BIT 0x85
_P0_6           BIT 0x86
_P0_7           BIT 0x87
_P1_0           BIT 0x90
_P1_1           BIT 0x91
_P1_2           BIT 0x92
_P1_3           BIT 0x93
_P1_4           BIT 0x94
_P1_5           BIT 0x95
_P1_6           BIT 0x96
_P1_7           BIT 0x97
_P2_0           BIT 0xa0
_P2_1           BIT 0xa1
_P2_2           BIT 0xa2
_P2_3           BIT 0xa3
_P2_4           BIT 0xa4
_P2_5           BIT 0xa5
_P2_6           BIT 0xa6
_P3_0           BIT 0xb0
_P3_1           BIT 0xb1
_P3_2           BIT 0xb2
_P3_3           BIT 0xb3
_P3_4           BIT 0xb4
_P3_7           BIT 0xb7
_CCF0           BIT 0xd8
_CCF1           BIT 0xd9
_CCF2           BIT 0xda
_CCF3           BIT 0xdb
_CCF4           BIT 0xdc
_CCF5           BIT 0xdd
_CR             BIT 0xde
_CF             BIT 0xdf
_PARITY         BIT 0xd0
_F1             BIT 0xd1
_OV             BIT 0xd2
_RS0            BIT 0xd3
_RS1            BIT 0xd4
_F0             BIT 0xd5
_AC             BIT 0xd6
_CY             BIT 0xd7
_RI             BIT 0x98
_TI             BIT 0x99
_RB8            BIT 0x9a
_TB8            BIT 0x9b
_REN            BIT 0x9c
_CE             BIT 0x9d
_SMODE          BIT 0x9e
_RI1            BIT 0xc8
_TI1            BIT 0xc9
_RBX1           BIT 0xca
_TBX1           BIT 0xcb
_REN1           BIT 0xcc
_PERR1          BIT 0xcd
_OVR1           BIT 0xce
_SI             BIT 0xc0
_ACK            BIT 0xc1
_ARBLOST        BIT 0xc2
_ACKRQ          BIT 0xc3
_STO            BIT 0xc4
_STA            BIT 0xc5
_TXMODE         BIT 0xc6
_MASTER         BIT 0xc7
_SPIEN          BIT 0xf8
_TXNF           BIT 0xf9
_NSSMD0         BIT 0xfa
_NSSMD1         BIT 0xfb
_RXOVRN         BIT 0xfc
_MODF           BIT 0xfd
_WCOL           BIT 0xfe
_SPIF           BIT 0xff
_IT0            BIT 0x88
_IE0            BIT 0x89
_IT1            BIT 0x8a
_IE1            BIT 0x8b
_TR0            BIT 0x8c
_TF0            BIT 0x8d
_TR1            BIT 0x8e
_TF1            BIT 0x8f
_T2XCLK0        BIT 0xc8
_T2XCLK1        BIT 0xc9
_TR2            BIT 0xca
_T2SPLIT        BIT 0xcb
_TF2CEN         BIT 0xcc
_TF2LEN         BIT 0xcd
_TF2L           BIT 0xce
_TF2H           BIT 0xcf
_T4XCLK0        BIT 0x98
_T4XCLK1        BIT 0x99
_TR4            BIT 0x9a
_T4SPLIT        BIT 0x9b
_TF4CEN         BIT 0x9c
_TF4LEN         BIT 0x9d
_TF4L           BIT 0x9e
_TF4H           BIT 0x9f
_T5XCLK0        BIT 0xc0
_T5XCLK1        BIT 0xc1
_TR5            BIT 0xc2
_T5SPLIT        BIT 0xc3
_TF5CEN         BIT 0xc4
_TF5LEN         BIT 0xc5
_TF5L           BIT 0xc6
_TF5H           BIT 0xc7
_RIE            BIT 0xd8
_RXTO0          BIT 0xd9
_RXTO1          BIT 0xda
_RFRQ           BIT 0xdb
_TIE            BIT 0xdc
_TXHOLD         BIT 0xdd
_TXNF1          BIT 0xde
_TFRQ           BIT 0xdf
;--------------------------------------------------------
; overlayable register banks
;--------------------------------------------------------
	rbank0 segment data overlay
;--------------------------------------------------------
; internal ram data
;--------------------------------------------------------
	rseg R_DSEG
_pwm_count:
	ds 1
_number1:
	ds 1
_number2:
	ds 1
_number3:
	ds 1
_number4:
	ds 1
_nunchuck_init_buf_1_56:
	ds 6
_nunchuck_init_sloc0_1_0:
	ds 2
_nunchuck_init_sloc1_1_0:
	ds 2
_nunchuck_init_sloc2_1_0:
	ds 2
_getsn_PARM_2:
	ds 2
_getsn_buff_1_67:
	ds 3
_getsn_sloc0_1_0:
	ds 2
_get_direction_PARM_2:
	ds 2
_main_rbuf_1_112:
	ds 6
_main_joy_x_1_112:
	ds 2
_main_off_x_1_112:
	ds 2
_main_off_y_1_112:
	ds 2
_main_acc_x_1_112:
	ds 2
_main_acc_y_1_112:
	ds 2
_main_acc_z_1_112:
	ds 2
_main_sloc0_1_0:
	ds 1
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
	rseg	R_OSEG
	rseg	R_OSEG
	rseg	R_OSEG
	rseg	R_OSEG
	rseg	R_OSEG
	rseg	R_OSEG
	rseg	R_OSEG
	rseg	R_OSEG
	rseg	R_OSEG
	rseg	R_OSEG
	rseg	R_OSEG
	rseg	R_OSEG
	rseg	R_OSEG
	rseg	R_OSEG
	rseg	R_OSEG
;--------------------------------------------------------
; indirectly addressable internal ram data
;--------------------------------------------------------
	rseg R_ISEG
;--------------------------------------------------------
; absolute internal ram data
;--------------------------------------------------------
	DSEG
;--------------------------------------------------------
; bit data
;--------------------------------------------------------
	rseg R_BSEG
_nunchuck_init_PARM_1:
	DBIT	1
_Timer2_ISR_sloc0_1_0:
	DBIT	1
_main_but1_1_112:
	DBIT	1
_main_but2_1_112:
	DBIT	1
;--------------------------------------------------------
; paged external ram data
;--------------------------------------------------------
	rseg R_PSEG
;--------------------------------------------------------
; external ram data
;--------------------------------------------------------
	rseg R_XSEG
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	XSEG
;--------------------------------------------------------
; external initialized ram data
;--------------------------------------------------------
	rseg R_IXSEG
	rseg R_HOME
	rseg R_GSINIT
	rseg R_CSEG
;--------------------------------------------------------
; Reset entry point and interrupt vectors
;--------------------------------------------------------
	CSEG at 0x0000
	ljmp	_crt0
	CSEG at 0x002b
	ljmp	_Timer2_ISR
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	rseg R_HOME
	rseg R_GSINIT
	rseg R_GSINIT
;--------------------------------------------------------
; data variables initialization
;--------------------------------------------------------
	rseg R_DINIT
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:61: volatile unsigned char pwm_count=0;
	mov	_pwm_count,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:62: volatile unsigned char number1=0;
	mov	_number1,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:63: volatile unsigned char number2=0; 
	mov	_number2,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:64: volatile unsigned char number3=0;
	mov	_number3,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:65: volatile unsigned char number4=0; 
	mov	_number4,#0x00
	; The linker places a 'ret' at the end of segment R_DINIT.
;--------------------------------------------------------
; code
;--------------------------------------------------------
	rseg R_CSEG
;------------------------------------------------------------
;Allocation info for local variables in function '_c51_external_startup'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:67: char _c51_external_startup (void)
;	-----------------------------------------
;	 function _c51_external_startup
;	-----------------------------------------
__c51_external_startup:
	using	0
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:70: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:71: WDTCN = 0xDE; //First key
	mov	_WDTCN,#0xDE
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:72: WDTCN = 0xAD; //Second key
	mov	_WDTCN,#0xAD
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:74: VDM0CN=0x80;       // enable VDD monitor
	mov	_VDM0CN,#0x80
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:75: RSTSRC=0x02|0x04;  // Enable reset on missing clock detector and VDD
	mov	_RSTSRC,#0x06
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:82: SFRPAGE = 0x10;
	mov	_SFRPAGE,#0x10
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:83: PFE0CN  = 0x20; // SYSCLK < 75 MHz.
	mov	_PFE0CN,#0x20
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:84: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:105: CLKSEL = 0x00;
	mov	_CLKSEL,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:106: CLKSEL = 0x00;
	mov	_CLKSEL,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:107: while ((CLKSEL & 0x80) == 0);
L002001?:
	mov	a,_CLKSEL
	jnb	acc.7,L002001?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:108: CLKSEL = 0x03;
	mov	_CLKSEL,#0x03
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:109: CLKSEL = 0x03;
	mov	_CLKSEL,#0x03
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:110: while ((CLKSEL & 0x80) == 0);
L002004?:
	mov	a,_CLKSEL
	jnb	acc.7,L002004?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:119: SCON0 = 0x10;
	mov	_SCON0,#0x10
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:120: TH1 = 0x100-((SYSCLK/BAUDRATE)/(12L*2L));
	mov	_TH1,#0xE6
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:121: TL1 = TH1;      // Init Timer1
	mov	_TL1,_TH1
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:122: TMOD &= ~0xf0;  // TMOD: timer 1 in 8-bit auto-reload
	anl	_TMOD,#0x0F
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:123: TMOD |=  0x20;                       
	orl	_TMOD,#0x20
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:124: TR1 = 1; // START Timer1
	setb	_TR1
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:125: TI = 1;  // Indicate TX0 ready
	setb	_TI
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:128: P0MDOUT |= 0x10; // Enable UART0 TX as push-pull output
	orl	_P0MDOUT,#0x10
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:129: XBR0 = 0b_0000_0101; // Enable SMBus pins and UART pins P0.4(TX) and P0.5(RX)
	mov	_XBR0,#0x05
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:130: XBR1 = 0X00;
	mov	_XBR1,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:131: XBR2 = 0x40; // Enable crossbar and weak pull-ups
	mov	_XBR2,#0x40
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:134: CKCON0 |= 0b_0000_0100; // Timer0 clock source = SYSCLK
	orl	_CKCON0,#0x04
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:135: TMOD &= 0xf0;  // Mask out timer 1 bits
	anl	_TMOD,#0xF0
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:136: TMOD |= 0x02;  // Timer0 in 8-bit auto-reload mode
	orl	_TMOD,#0x02
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:138: TL0 = TH0 = 256-(SYSCLK/SMB_FREQUENCY/3);
	mov	_TH0,#0x10
	mov	_TL0,#0x10
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:139: TR0 = 1; // Enable timer 0
	setb	_TR0
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:142: TMR2CN0=0x00;   // Stop Timer2; Clear TF2;
	mov	_TMR2CN0,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:143: CKCON0|=0b_0001_0000; // Timer 2 uses the system clock
	orl	_CKCON0,#0x10
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:144: TMR2RL=(0x10000L-(SYSCLK/10000L)); // Initialize reload value ....Timer overflow rate (FREQ) found by SYSCLK/(2^16-TMR2RL)
	mov	_TMR2RL,#0xE0
	mov	(_TMR2RL >> 8),#0xE3
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:145: TMR2=0xffff;   // Set to reload immediately
	mov	_TMR2,#0xFF
	mov	(_TMR2 >> 8),#0xFF
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:146: ET2=1;         // Enable Timer2 interrupts
	setb	_ET2
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:147: TR2=1;         // Start Timer2 (TMR2CN is bit addressable)
	setb	_TR2
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:149: EA=1; // Enable interrupts
	setb	_EA
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:154: SMB0CF = 0b_0101_1100; //INH | EXTHOLD | SMBTOE | SMBFTE ;
	mov	_SMB0CF,#0x5C
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:155: SMB0CF |= 0b_1000_0000;  // Enable SMBus
	orl	_SMB0CF,#0x80
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:157: return 0;
	mov	dpl,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Timer4ms'
;------------------------------------------------------------
;ms                        Allocated to registers r2 
;i                         Allocated to registers r4 
;k                         Allocated to registers r3 
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:161: void Timer4ms(unsigned char ms)
;	-----------------------------------------
;	 function Timer4ms
;	-----------------------------------------
_Timer4ms:
	mov	r2,dpl
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:166: k=SFRPAGE;
	mov	r3,_SFRPAGE
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:167: SFRPAGE=0x10;
	mov	_SFRPAGE,#0x10
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:169: CKCON1|=0b_0000_0001;
	orl	_CKCON1,#0x01
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:171: TMR4RL = 65536-(SYSCLK/1000L); // Set Timer4 to overflow in 1 ms.
	mov	_TMR4RL,#0xC0
	mov	(_TMR4RL >> 8),#0xE6
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:172: TMR4 = TMR4RL;                 // Initialize Timer4 for first overflow
	mov	_TMR4,_TMR4RL
	mov	(_TMR4 >> 8),(_TMR4RL >> 8)
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:174: TF4H=0; // Clear overflow flag
	clr	_TF4H
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:175: TR4=1;  // Start Timer4
	setb	_TR4
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:176: for (i = 0; i < ms; i++)       // Count <ms> overflows
	mov	r4,#0x00
L003004?:
	clr	c
	mov	a,r4
	subb	a,r2
	jnc	L003007?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:178: while (!TF4H);  // Wait for overflow
L003001?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:179: TF4H=0;         // Clear overflow indicator
	jbc	_TF4H,L003015?
	sjmp	L003001?
L003015?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:176: for (i = 0; i < ms; i++)       // Count <ms> overflows
	inc	r4
	sjmp	L003004?
L003007?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:181: TR4=0; // Stop Timer4
	clr	_TR4
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:182: SFRPAGE=k;	
	mov	_SFRPAGE,r3
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'I2C_write'
;------------------------------------------------------------
;output_data               Allocated to registers 
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:185: void I2C_write (unsigned char output_data)
;	-----------------------------------------
;	 function I2C_write
;	-----------------------------------------
_I2C_write:
	mov	_SMB0DAT,dpl
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:188: SI = 0;
	clr	_SI
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:189: while (!SI); // Wait until done with send
L004001?:
	jnb	_SI,L004001?
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'I2C_read'
;------------------------------------------------------------
;input_data                Allocated to registers 
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:192: unsigned char I2C_read (void)
;	-----------------------------------------
;	 function I2C_read
;	-----------------------------------------
_I2C_read:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:196: SI = 0;
	clr	_SI
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:197: while (!SI); // Wait until we have data to read
L005001?:
	jnb	_SI,L005001?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:198: input_data = SMB0DAT; // Read the data
	mov	dpl,_SMB0DAT
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:200: return input_data;
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'I2C_start'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:203: void I2C_start (void)
;	-----------------------------------------
;	 function I2C_start
;	-----------------------------------------
_I2C_start:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:205: ACK = 1;
	setb	_ACK
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:206: STA = 1;     // Send I2C start
	setb	_STA
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:207: STO = 0;
	clr	_STO
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:208: SI = 0;
	clr	_SI
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:209: while (!SI); // Wait until start sent
L006001?:
	jnb	_SI,L006001?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:210: STA = 0;     // Reset I2C start
	clr	_STA
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'I2C_stop'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:213: void I2C_stop(void)
;	-----------------------------------------
;	 function I2C_stop
;	-----------------------------------------
_I2C_stop:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:215: STO = 1;  	// Perform I2C stop
	setb	_STO
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:216: SI = 0;	// Clear SI
	clr	_SI
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'nunchuck_init'
;------------------------------------------------------------
;i                         Allocated to registers r2 
;buf                       Allocated with name '_nunchuck_init_buf_1_56'
;sloc0                     Allocated with name '_nunchuck_init_sloc0_1_0'
;sloc1                     Allocated with name '_nunchuck_init_sloc1_1_0'
;sloc2                     Allocated with name '_nunchuck_init_sloc2_1_0'
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:220: void nunchuck_init(bit print_extension_type)
;	-----------------------------------------
;	 function nunchuck_init
;	-----------------------------------------
_nunchuck_init:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:225: I2C_start();
	lcall	_I2C_start
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:226: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:227: I2C_write(0xF0);
	mov	dpl,#0xF0
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:228: I2C_write(0x55);
	mov	dpl,#0x55
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:229: I2C_stop();
	lcall	_I2C_stop
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:230: Timer4ms(1);
	mov	dpl,#0x01
	lcall	_Timer4ms
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:232: I2C_start();
	lcall	_I2C_start
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:233: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:234: I2C_write(0xFB);
	mov	dpl,#0xFB
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:235: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:236: I2C_stop();
	lcall	_I2C_stop
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:237: Timer4ms(1);
	mov	dpl,#0x01
	lcall	_Timer4ms
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:241: I2C_start();
	lcall	_I2C_start
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:242: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:243: I2C_write(0xFA); // extension type register
	mov	dpl,#0xFA
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:244: I2C_stop();
	lcall	_I2C_stop
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:245: Timer4ms(3); // 3 ms required to complete acquisition
	mov	dpl,#0x03
	lcall	_Timer4ms
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:247: I2C_start();
	lcall	_I2C_start
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:248: I2C_write(0xA5);
	mov	dpl,#0xA5
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:251: for(i=0; i<6; i++)
	mov	r2,#0x00
L008003?:
	cjne	r2,#0x06,L008013?
L008013?:
	jnc	L008006?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:253: buf[i]=I2C_read();
	mov	a,r2
	add	a,#_nunchuck_init_buf_1_56
	mov	r0,a
	push	ar2
	push	ar0
	lcall	_I2C_read
	mov	a,dpl
	pop	ar0
	pop	ar2
	mov	@r0,a
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:251: for(i=0; i<6; i++)
	inc	r2
	sjmp	L008003?
L008006?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:255: ACK=0;
	clr	_ACK
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:256: I2C_stop();
	lcall	_I2C_stop
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:257: Timer4ms(3);
	mov	dpl,#0x03
	lcall	_Timer4ms
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:259: if(print_extension_type)
	jnb	_nunchuck_init_PARM_1,L008002?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:262: buf[0],  buf[1], buf[2], buf[3], buf[4], buf[5]);
	mov	r2,(_nunchuck_init_buf_1_56 + 0x0005)
	mov	r3,#0x00
	mov	r4,(_nunchuck_init_buf_1_56 + 0x0004)
	mov	r5,#0x00
	mov	_nunchuck_init_sloc0_1_0,(_nunchuck_init_buf_1_56 + 0x0003)
	mov	(_nunchuck_init_sloc0_1_0 + 1),#0x00
	mov	_nunchuck_init_sloc1_1_0,(_nunchuck_init_buf_1_56 + 0x0002)
	mov	(_nunchuck_init_sloc1_1_0 + 1),#0x00
	mov	_nunchuck_init_sloc2_1_0,(_nunchuck_init_buf_1_56 + 0x0001)
	mov	(_nunchuck_init_sloc2_1_0 + 1),#0x00
	mov	r6,_nunchuck_init_buf_1_56
	mov	r7,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:261: printf("Extension type: %02x  %02x  %02x  %02x  %02x  %02x\n", 
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	push	_nunchuck_init_sloc0_1_0
	push	(_nunchuck_init_sloc0_1_0 + 1)
	push	_nunchuck_init_sloc1_1_0
	push	(_nunchuck_init_sloc1_1_0 + 1)
	push	_nunchuck_init_sloc2_1_0
	push	(_nunchuck_init_sloc2_1_0 + 1)
	push	ar6
	push	ar7
	mov	a,#__str_0
	push	acc
	mov	a,#(__str_0 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	mov	a,sp
	add	a,#0xf1
	mov	sp,a
L008002?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:267: I2C_start();
	lcall	_I2C_start
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:268: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:269: I2C_write(0xF0);
	mov	dpl,#0xF0
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:270: I2C_write(0xAA);
	mov	dpl,#0xAA
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:271: I2C_stop();
	lcall	_I2C_stop
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:272: Timer4ms(1);
	mov	dpl,#0x01
	lcall	_Timer4ms
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:274: I2C_start();
	lcall	_I2C_start
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:275: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:276: I2C_write(0x40);
	mov	dpl,#0x40
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:277: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:278: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:279: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:280: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:281: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:282: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:283: I2C_stop();
	lcall	_I2C_stop
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:284: Timer4ms(1);
	mov	dpl,#0x01
	lcall	_Timer4ms
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:286: I2C_start();
	lcall	_I2C_start
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:287: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:288: I2C_write(0x40);
	mov	dpl,#0x40
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:289: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:290: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:291: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:292: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:293: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:294: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:295: I2C_stop();
	lcall	_I2C_stop
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:296: Timer4ms(1);
	mov	dpl,#0x01
	lcall	_Timer4ms
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:298: I2C_start();
	lcall	_I2C_start
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:299: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:300: I2C_write(0x40);
	mov	dpl,#0x40
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:301: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:302: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:303: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:304: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:305: I2C_stop();
	lcall	_I2C_stop
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:306: Timer4ms(1);
	mov	dpl,#0x01
	ljmp	_Timer4ms
;------------------------------------------------------------
;Allocation info for local variables in function 'nunchuck_getdata'
;------------------------------------------------------------
;s                         Allocated to registers r2 r3 r4 
;i                         Allocated to registers r5 
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:309: void nunchuck_getdata(unsigned char * s)
;	-----------------------------------------
;	 function nunchuck_getdata
;	-----------------------------------------
_nunchuck_getdata:
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:314: I2C_start();
	push	ar2
	push	ar3
	push	ar4
	lcall	_I2C_start
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:315: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:316: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:317: I2C_stop();
	lcall	_I2C_stop
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:318: Timer4ms(3); 	// 3 ms required to complete acquisition
	mov	dpl,#0x03
	lcall	_Timer4ms
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:321: I2C_start();
	lcall	_I2C_start
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:322: I2C_write(0xA5);
	mov	dpl,#0xA5
	lcall	_I2C_write
	pop	ar4
	pop	ar3
	pop	ar2
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:325: for(i=0; i<6; i++)
	mov	r5,#0x00
L009001?:
	cjne	r5,#0x06,L009010?
L009010?:
	jnc	L009004?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:327: s[i]=(I2C_read()^0x17)+0x17; // Read and decrypt
	mov	a,r5
	add	a,r2
	mov	r6,a
	clr	a
	addc	a,r3
	mov	r7,a
	mov	ar0,r4
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	push	ar6
	push	ar7
	push	ar0
	lcall	_I2C_read
	mov	a,dpl
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar5
	pop	ar4
	pop	ar3
	pop	ar2
	xrl	a,#0x17
	add	a,#0x17
	mov	r1,a
	mov	dpl,r6
	mov	dph,r7
	mov	b,r0
	lcall	__gptrput
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:325: for(i=0; i<6; i++)
	inc	r5
	sjmp	L009001?
L009004?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:329: ACK=0;
	clr	_ACK
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:330: I2C_stop();
	ljmp	_I2C_stop
;------------------------------------------------------------
;Allocation info for local variables in function 'Timer3us'
;------------------------------------------------------------
;us                        Allocated to registers r2 
;i                         Allocated to registers r3 
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:334: void Timer3us(unsigned char us)
;	-----------------------------------------
;	 function Timer3us
;	-----------------------------------------
_Timer3us:
	mov	r2,dpl
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:339: CKCON0|=0b_0100_0000;
	orl	_CKCON0,#0x40
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:341: TMR3RL = (-(SYSCLK)/1000000L); // Set Timer3 to overflow in 1us.
	mov	_TMR3RL,#0xB8
	mov	(_TMR3RL >> 8),#0xFF
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:342: TMR3 = TMR3RL;                 // Initialize Timer3 for first overflow
	mov	_TMR3,_TMR3RL
	mov	(_TMR3 >> 8),(_TMR3RL >> 8)
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:344: TMR3CN0 = 0x04;                 // Sart Timer3 and clear overflow flag
	mov	_TMR3CN0,#0x04
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:345: for (i = 0; i < us; i++)       // Count <us> overflows
	mov	r3,#0x00
L010004?:
	clr	c
	mov	a,r3
	subb	a,r2
	jnc	L010007?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:347: while (!(TMR3CN0 & 0x80));  // Wait for overflow
L010001?:
	mov	a,_TMR3CN0
	jnb	acc.7,L010001?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:348: TMR3CN0 &= ~(0x80);         // Clear overflow indicator
	anl	_TMR3CN0,#0x7F
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:345: for (i = 0; i < us; i++)       // Count <us> overflows
	inc	r3
	sjmp	L010004?
L010007?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:350: TMR3CN0 = 0 ;                   // Stop Timer3 and clear overflow flag
	mov	_TMR3CN0,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'waitms'
;------------------------------------------------------------
;ms                        Allocated to registers r2 r3 
;j                         Allocated to registers r4 r5 
;k                         Allocated to registers r6 
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:353: void waitms (unsigned int ms)
;	-----------------------------------------
;	 function waitms
;	-----------------------------------------
_waitms:
	mov	r2,dpl
	mov	r3,dph
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:357: for(j=0; j<ms; j++)
	mov	r4,#0x00
	mov	r5,#0x00
L011005?:
	clr	c
	mov	a,r4
	subb	a,r2
	mov	a,r5
	subb	a,r3
	jnc	L011009?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:358: for (k=0; k<4; k++) Timer3us(250);
	mov	r6,#0x00
L011001?:
	cjne	r6,#0x04,L011018?
L011018?:
	jnc	L011007?
	mov	dpl,#0xFA
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	push	ar6
	lcall	_Timer3us
	pop	ar6
	pop	ar5
	pop	ar4
	pop	ar3
	pop	ar2
	inc	r6
	sjmp	L011001?
L011007?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:357: for(j=0; j<ms; j++)
	inc	r4
	cjne	r4,#0x00,L011005?
	inc	r5
	sjmp	L011005?
L011009?:
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'getsn'
;------------------------------------------------------------
;len                       Allocated with name '_getsn_PARM_2'
;buff                      Allocated with name '_getsn_buff_1_67'
;j                         Allocated with name '_getsn_sloc0_1_0'
;c                         Allocated to registers r3 
;sloc0                     Allocated with name '_getsn_sloc0_1_0'
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:361: int getsn (char * buff, int len)
;	-----------------------------------------
;	 function getsn
;	-----------------------------------------
_getsn:
	mov	_getsn_buff_1_67,dpl
	mov	(_getsn_buff_1_67 + 1),dph
	mov	(_getsn_buff_1_67 + 2),b
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:366: for(j=0; j<(len-1); j++)
	clr	a
	mov	_getsn_sloc0_1_0,a
	mov	(_getsn_sloc0_1_0 + 1),a
	mov	a,_getsn_PARM_2
	add	a,#0xff
	mov	r7,a
	mov	a,(_getsn_PARM_2 + 1)
	addc	a,#0xff
	mov	r0,a
	mov	r1,#0x00
	mov	r2,#0x00
L012005?:
	clr	c
	mov	a,r1
	subb	a,r7
	mov	a,r2
	xrl	a,#0x80
	mov	b,r0
	xrl	b,#0x80
	subb	a,b
	jnc	L012008?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:368: c=getchar();
	push	ar2
	push	ar7
	push	ar0
	push	ar1
	lcall	_getchar
	mov	r3,dpl
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar2
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:369: if ( (c=='\n') || (c=='\r') )
	cjne	r3,#0x0A,L012015?
	sjmp	L012001?
L012015?:
	cjne	r3,#0x0D,L012002?
L012001?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:371: buff[j]=0;
	mov	a,_getsn_sloc0_1_0
	add	a,_getsn_buff_1_67
	mov	r4,a
	mov	a,(_getsn_sloc0_1_0 + 1)
	addc	a,(_getsn_buff_1_67 + 1)
	mov	r5,a
	mov	r6,(_getsn_buff_1_67 + 2)
	mov	dpl,r4
	mov	dph,r5
	mov	b,r6
	clr	a
	lcall	__gptrput
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:372: return j;
	mov	dpl,_getsn_sloc0_1_0
	mov	dph,(_getsn_sloc0_1_0 + 1)
	ret
L012002?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:376: buff[j]=c;
	mov	a,r1
	add	a,_getsn_buff_1_67
	mov	r4,a
	mov	a,r2
	addc	a,(_getsn_buff_1_67 + 1)
	mov	r5,a
	mov	r6,(_getsn_buff_1_67 + 2)
	mov	dpl,r4
	mov	dph,r5
	mov	b,r6
	mov	a,r3
	lcall	__gptrput
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:366: for(j=0; j<(len-1); j++)
	inc	r1
	cjne	r1,#0x00,L012018?
	inc	r2
L012018?:
	mov	_getsn_sloc0_1_0,r1
	mov	(_getsn_sloc0_1_0 + 1),r2
	sjmp	L012005?
L012008?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:379: buff[j]='\0';
	mov	a,_getsn_sloc0_1_0
	add	a,_getsn_buff_1_67
	mov	r2,a
	mov	a,(_getsn_sloc0_1_0 + 1)
	addc	a,(_getsn_buff_1_67 + 1)
	mov	r3,a
	mov	r4,(_getsn_buff_1_67 + 2)
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	clr	a
	lcall	__gptrput
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:380: return len;
	mov	dpl,_getsn_PARM_2
	mov	dph,(_getsn_PARM_2 + 1)
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Timer2_ISR'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:383: void Timer2_ISR (void) interrupt 5
;	-----------------------------------------
;	 function Timer2_ISR
;	-----------------------------------------
_Timer2_ISR:
	push	acc
	push	psw
	mov	psw,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:385: TF2H = 0; // Clear Timer2 interrupt flag
	clr	_TF2H
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:387: pwm_count++;
	inc	_pwm_count
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:388: if(pwm_count>100) pwm_count=0;
	mov	a,_pwm_count
	add	a,#0xff - 0x64
	jnc	L013002?
	mov	_pwm_count,#0x00
L013002?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:391: Mot1_forward=pwm_count>number1?0:1;
	clr	c
	mov	a,_number1
	subb	a,_pwm_count
	mov  _Timer2_ISR_sloc0_1_0,c
	cpl	c
	mov	_P1_6,c
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:393: Mot1_reverse=pwm_count>number2?0:1;
	clr	c
	mov	a,_number2
	subb	a,_pwm_count
	mov  _Timer2_ISR_sloc0_1_0,c
	cpl	c
	mov	_P1_7,c
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:395: Mot2_forward=pwm_count>number3?0:1;
	clr	c
	mov	a,_number3
	subb	a,_pwm_count
	mov  _Timer2_ISR_sloc0_1_0,c
	cpl	c
	mov	_P1_3,c
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:396: Mot2_reverse=pwm_count>number4?0:1;
	clr	c
	mov	a,_number4
	subb	a,_pwm_count
	mov  _Timer2_ISR_sloc0_1_0,c
	cpl	c
	mov	_P1_4,c
	pop	psw
	pop	acc
	reti
;	eliminated unneeded push/pop dpl
;	eliminated unneeded push/pop dph
;	eliminated unneeded push/pop b
;------------------------------------------------------------
;Allocation info for local variables in function 'go_straight'
;------------------------------------------------------------
;speed                     Allocated to registers r2 
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:411: void go_straight(char speed){
;	-----------------------------------------
;	 function go_straight
;	-----------------------------------------
_go_straight:
	mov	r2,dpl
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:413: number1=speed;
	mov	_number1,r2
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:414: number3=speed;
	mov	_number3,r2
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:415: number2=0;
	mov	_number2,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:416: number4=0;
	mov	_number4,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'go_reverse'
;------------------------------------------------------------
;speed                     Allocated to registers r2 
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:420: void go_reverse(char speed){
;	-----------------------------------------
;	 function go_reverse
;	-----------------------------------------
_go_reverse:
	mov	r2,dpl
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:422: number1=0;
	mov	_number1,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:423: number3=0;
	mov	_number3,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:424: number2=speed;
	mov	_number2,r2
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:425: number4=speed;
	mov	_number4,r2
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'turn_west'
;------------------------------------------------------------
;speed                     Allocated to registers r2 
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:429: void turn_west(char speed ){
;	-----------------------------------------
;	 function turn_west
;	-----------------------------------------
_turn_west:
	mov	r2,dpl
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:432: number1=0;
	mov	_number1,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:433: number3=speed;
	mov	_number3,r2
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:434: number2=speed;
	mov	_number2,r2
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:435: number4=0;
	mov	_number4,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'turn_east'
;------------------------------------------------------------
;speed                     Allocated to registers r2 
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:438: void turn_east(char speed){
;	-----------------------------------------
;	 function turn_east
;	-----------------------------------------
_turn_east:
	mov	r2,dpl
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:440: number1=speed;
	mov	_number1,r2
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:441: number3=0;
	mov	_number3,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:442: number2=0;
	mov	_number2,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:443: number4=speed;
	mov	_number4,r2
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'turn_NW'
;------------------------------------------------------------
;speed                     Allocated to registers r2 
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:447: void turn_NW(char speed){
;	-----------------------------------------
;	 function turn_NW
;	-----------------------------------------
_turn_NW:
	mov	r2,dpl
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:449: number1=speed/2;
	clr	F0
	mov	b,#0x02
	mov	a,r2
	jnb	acc.7,L018003?
	cpl	F0
	cpl	a
	inc	a
L018003?:
	div	ab
	jnb	F0,L018004?
	cpl	a
	inc	a
L018004?:
	mov	_number1,a
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:450: number3=speed;
	mov	_number3,r2
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:451: number2=0;
	mov	_number2,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:452: number4=0;
	mov	_number4,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'turn_NE'
;------------------------------------------------------------
;speed                     Allocated to registers r2 
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:456: void turn_NE(char speed){
;	-----------------------------------------
;	 function turn_NE
;	-----------------------------------------
_turn_NE:
	mov	r2,dpl
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:458: number1=speed;
	mov	_number1,r2
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:459: number3=speed/2;
	clr	F0
	mov	b,#0x02
	mov	a,r2
	jnb	acc.7,L019003?
	cpl	F0
	cpl	a
	inc	a
L019003?:
	div	ab
	jnb	F0,L019004?
	cpl	a
	inc	a
L019004?:
	mov	_number3,a
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:460: number2=0;
	mov	_number2,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:461: number4=0;
	mov	_number4,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'turn_NNE'
;------------------------------------------------------------
;speed                     Allocated to registers r2 
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:464: void turn_NNE(char speed){
;	-----------------------------------------
;	 function turn_NNE
;	-----------------------------------------
_turn_NNE:
	mov	r2,dpl
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:465: number1=speed;
	mov	_number1,r2
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:466: number3=speed/4;
	clr	F0
	mov	b,#0x04
	mov	a,r2
	jnb	acc.7,L020003?
	cpl	F0
	cpl	a
	inc	a
L020003?:
	div	ab
	jnb	F0,L020004?
	cpl	a
	inc	a
L020004?:
	mov	_number3,a
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:467: number2=0;
	mov	_number2,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:468: number4=0;
	mov	_number4,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'turn_NNW'
;------------------------------------------------------------
;speed                     Allocated to registers r2 
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:471: void turn_NNW(char speed){
;	-----------------------------------------
;	 function turn_NNW
;	-----------------------------------------
_turn_NNW:
	mov	r2,dpl
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:472: number1=speed/4;
	clr	F0
	mov	b,#0x04
	mov	a,r2
	jnb	acc.7,L021003?
	cpl	F0
	cpl	a
	inc	a
L021003?:
	div	ab
	jnb	F0,L021004?
	cpl	a
	inc	a
L021004?:
	mov	_number1,a
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:473: number3=speed;
	mov	_number3,r2
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:474: number2=0;
	mov	_number2,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:475: number4=0;
	mov	_number4,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'turn_NEE'
;------------------------------------------------------------
;speed                     Allocated to registers r2 
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:478: void turn_NEE(char speed){
;	-----------------------------------------
;	 function turn_NEE
;	-----------------------------------------
_turn_NEE:
	mov	r2,dpl
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:479: number1=speed;
	mov	_number1,r2
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:480: number3=speed/8;
	clr	F0
	mov	b,#0x08
	mov	a,r2
	jnb	acc.7,L022003?
	cpl	F0
	cpl	a
	inc	a
L022003?:
	div	ab
	jnb	F0,L022004?
	cpl	a
	inc	a
L022004?:
	mov	_number3,a
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:481: number2=0;
	mov	_number2,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:482: number4=0;
	mov	_number4,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'turn_NWW'
;------------------------------------------------------------
;speed                     Allocated to registers r2 
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:485: void turn_NWW(char speed){
;	-----------------------------------------
;	 function turn_NWW
;	-----------------------------------------
_turn_NWW:
	mov	r2,dpl
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:486: number1=speed/8;
	clr	F0
	mov	b,#0x08
	mov	a,r2
	jnb	acc.7,L023003?
	cpl	F0
	cpl	a
	inc	a
L023003?:
	div	ab
	jnb	F0,L023004?
	cpl	a
	inc	a
L023004?:
	mov	_number1,a
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:487: number3=speed;
	mov	_number3,r2
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:488: number2=0;
	mov	_number2,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:489: number4=0;
	mov	_number4,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'stop'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:494: void stop(){
;	-----------------------------------------
;	 function stop
;	-----------------------------------------
_stop:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:496: number1=0;
	mov	_number1,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:497: number2=0;
	mov	_number2,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:498: number3=0;
	mov	_number3,#0x00
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:499: number4=0;
	mov	_number4,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'get_speed'
;------------------------------------------------------------
;y_ax                      Allocated to registers r2 r3 
;spd                       Allocated to registers r4 r5 
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:502: int get_speed(int y_ax){
;	-----------------------------------------
;	 function get_speed
;	-----------------------------------------
_get_speed:
	mov	r2,dpl
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:505: if(y_ax>=0){
	mov	a,dph
	mov	r3,a
	jb	acc.7,L025002?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:506: spd= y_ax; 
	mov	ar4,r2
	mov	ar5,r3
	sjmp	L025003?
L025002?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:508: else spd=-y_ax;
	clr	c
	clr	a
	subb	a,r2
	mov	r4,a
	clr	a
	subb	a,r3
	mov	r5,a
L025003?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:510: return spd;
	mov	dpl,r4
	mov	dph,r5
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'get_direction'
;------------------------------------------------------------
;y_axis                    Allocated with name '_get_direction_PARM_2'
;x_axis                    Allocated to registers r2 r3 
;direction                 Allocated to registers r4 
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:513: char get_direction(int x_axis, int y_axis){
;	-----------------------------------------
;	 function get_direction
;	-----------------------------------------
_get_direction:
	mov	r2,dpl
	mov	r3,dph
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:515: char direction=north;
	mov	r4,#0x61
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:519: if ((x_axis<10)&&(x_axis>-10)){
	clr	c
	mov	a,r2
	subb	a,#0x0A
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x80
	jnc	L026043?
	clr	c
	mov	a,#0xF6
	subb	a,r2
	mov	a,#(0xFF ^ 0x80)
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	L026043?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:522: if(y_axis>5&&y_axis>-5){
	clr	c
	mov	a,#0x05
	subb	a,_get_direction_PARM_2
	clr	a
	xrl	a,#0x80
	mov	b,(_get_direction_PARM_2 + 1)
	xrl	b,#0x80
	subb	a,b
	clr	a
	rlc	a
	mov	r5,a
	jz	L026007?
	clr	c
	mov	a,#0xFB
	subb	a,_get_direction_PARM_2
	mov	a,#(0xFF ^ 0x80)
	mov	b,(_get_direction_PARM_2 + 1)
	xrl	b,#0x80
	subb	a,b
	jnc	L026007?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:523: stop(); 
	push	ar4
	lcall	_stop
	pop	ar4
	ljmp	L026044?
L026007?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:525: else if((y_axis>5))
	mov	a,r5
	jz	L026004?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:526: direction=north;
	mov	r4,#0x61
	ljmp	L026044?
L026004?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:527: else if(y_axis<-5){
	clr	c
	mov	a,_get_direction_PARM_2
	subb	a,#0xFB
	mov	a,(_get_direction_PARM_2 + 1)
	xrl	a,#0x80
	subb	a,#0x7f
	jc	L026075?
	ljmp	L026044?
L026075?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:528: direction=south;
	mov	r4,#0x62
	ljmp	L026044?
L026043?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:533: else if(x_axis>10&&x_axis<=30){
	clr	c
	mov	a,#0x0A
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	L026039?
	clr	c
	mov	a,#0x1E
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jc	L026039?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:534: direction=NNE;
	mov	r4,#0x63
	ljmp	L026044?
L026039?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:536: else if(x_axis>30&&x_axis<=50){
	clr	c
	mov	a,#0x1E
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	L026035?
	clr	c
	mov	a,#0x32
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jc	L026035?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:537: direction=NE;
	mov	r4,#0x65
	ljmp	L026044?
L026035?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:539: else if(x_axis>50&&x_axis<=70){
	clr	c
	mov	a,#0x32
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	L026031?
	clr	c
	mov	a,#0x46
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jc	L026031?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:540: direction=NEE;
	mov	r4,#0x67
	ljmp	L026044?
L026031?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:542: else if(x_axis>70&&x_axis<=90){
	clr	c
	mov	a,#0x46
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	L026027?
	clr	c
	mov	a,#0x5A
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jc	L026027?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:543: direction=east;
	mov	r4,#0x69
	sjmp	L026044?
L026027?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:546: else if(x_axis<-10&&x_axis>=-30){
	clr	c
	mov	a,r2
	subb	a,#0xF6
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x7f
	jnc	L026023?
	clr	c
	mov	a,r2
	subb	a,#0xE2
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x7f
	jc	L026023?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:547: direction=NNW;
	mov	r4,#0x64
	sjmp	L026044?
L026023?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:549: else if(x_axis<-30&&x_axis>=-50){
	clr	c
	mov	a,r2
	subb	a,#0xE2
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x7f
	jnc	L026019?
	clr	c
	mov	a,r2
	subb	a,#0xCE
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x7f
	jc	L026019?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:550: direction=NW;
	mov	r4,#0x66
	sjmp	L026044?
L026019?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:552: else if(x_axis<-50&&x_axis>=-70){
	clr	c
	mov	a,r2
	subb	a,#0xCE
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x7f
	jnc	L026015?
	clr	c
	mov	a,r2
	subb	a,#0xBA
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x7f
	jc	L026015?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:553: direction=NWW;
	mov	r4,#0x68
	sjmp	L026044?
L026015?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:555: else if(x_axis<-70&&x_axis>=-90){
	clr	c
	mov	a,r2
	subb	a,#0xBA
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x7f
	jnc	L026011?
	clr	c
	mov	a,r2
	subb	a,#0xA6
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x7f
	jc	L026011?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:556: direction=west;
	mov	r4,#0x6A
	sjmp	L026044?
L026011?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:559: direction=north;
	mov	r4,#0x61
L026044?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:562: return direction;
	mov	dpl,r4
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;rbuf                      Allocated with name '_main_rbuf_1_112'
;joy_x                     Allocated with name '_main_joy_x_1_112'
;joy_y                     Allocated to registers r4 r5 
;off_x                     Allocated with name '_main_off_x_1_112'
;off_y                     Allocated with name '_main_off_y_1_112'
;acc_x                     Allocated with name '_main_acc_x_1_112'
;acc_y                     Allocated with name '_main_acc_y_1_112'
;acc_z                     Allocated with name '_main_acc_z_1_112'
;speed                     Allocated to registers r2 r3 
;direction                 Allocated to registers r4 
;sloc0                     Allocated with name '_main_sloc0_1_0'
;------------------------------------------------------------
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:567: void main (void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:579: printf("\x1b[2J\x1b[1;1H"); // Clear screen using ANSI escape sequence.
	mov	a,#__str_1
	push	acc
	mov	a,#(__str_1 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:580: printf("\n\nEFM8LB1 WII Nunchuck I2C Reader\n");
	mov	a,#__str_2
	push	acc
	mov	a,#(__str_2 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:582: Timer4ms(200);
	mov	dpl,#0xC8
	lcall	_Timer4ms
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:583: nunchuck_init(1);
	setb	_nunchuck_init_PARM_1
	lcall	_nunchuck_init
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:584: Timer4ms(100);
	mov	dpl,#0x64
	lcall	_Timer4ms
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:586: nunchuck_getdata(rbuf);
	mov	dptr,#_main_rbuf_1_112
	mov	b,#0x40
	lcall	_nunchuck_getdata
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:588: off_x=(int)rbuf[0]-128;
	mov	r2,_main_rbuf_1_112
	mov	r3,#0x00
	mov	a,r2
	add	a,#0x80
	mov	_main_off_x_1_112,a
	mov	a,r3
	addc	a,#0xff
	mov	(_main_off_x_1_112 + 1),a
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:589: off_y=(int)rbuf[1]-128;
	mov	r4,(_main_rbuf_1_112 + 0x0001)
	mov	r5,#0x00
	mov	a,r4
	add	a,#0x80
	mov	_main_off_y_1_112,a
	mov	a,r5
	addc	a,#0xff
	mov	(_main_off_y_1_112 + 1),a
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:590: printf("Offset_X:%4d Offset_Y:%4d\n\n", off_x, off_y);
	push	_main_off_y_1_112
	push	(_main_off_y_1_112 + 1)
	push	_main_off_x_1_112
	push	(_main_off_x_1_112 + 1)
	mov	a,#__str_3
	push	acc
	mov	a,#(__str_3 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	mov	a,sp
	add	a,#0xf9
	mov	sp,a
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:592: while(1)
L027026?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:594: nunchuck_getdata(rbuf);
	mov	dptr,#_main_rbuf_1_112
	mov	b,#0x40
	lcall	_nunchuck_getdata
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:596: joy_x=(int)rbuf[0]-128-off_x;
	mov	r6,_main_rbuf_1_112
	mov	r7,#0x00
	mov	a,r6
	add	a,#0x80
	mov	r6,a
	mov	a,r7
	addc	a,#0xff
	mov	r7,a
	mov	a,r6
	clr	c
	subb	a,_main_off_x_1_112
	mov	_main_joy_x_1_112,a
	mov	a,r7
	subb	a,(_main_off_x_1_112 + 1)
	mov	(_main_joy_x_1_112 + 1),a
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:597: joy_y=(int)rbuf[1]-128-off_y;
	mov	r4,(_main_rbuf_1_112 + 0x0001)
	mov	r5,#0x00
	mov	a,r4
	add	a,#0x80
	mov	r4,a
	mov	a,r5
	addc	a,#0xff
	mov	r5,a
	mov	a,r4
	clr	c
	subb	a,_main_off_y_1_112
	mov	r4,a
	mov	a,r5
	subb	a,(_main_off_y_1_112 + 1)
	mov	r5,a
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:598: acc_x=rbuf[2]*4; 
	mov	a,(_main_rbuf_1_112 + 0x0002)
	mov	b,#0x04
	mul	ab
	mov	_main_acc_x_1_112,a
	mov	(_main_acc_x_1_112 + 1),b
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:599: acc_y=rbuf[3]*4;
	mov	a,(_main_rbuf_1_112 + 0x0003)
	mov	b,#0x04
	mul	ab
	mov	_main_acc_y_1_112,a
	mov	(_main_acc_y_1_112 + 1),b
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:600: acc_z=rbuf[4]*4;
	mov	a,(_main_rbuf_1_112 + 0x0004)
	mov	b,#0x04
	mul	ab
	mov	_main_acc_z_1_112,a
	mov	(_main_acc_z_1_112 + 1),b
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:602: but1=(rbuf[5] & 0x01)?1:0;
	mov	a,(_main_rbuf_1_112 + 0x0005)
	rrc	a
	mov	_main_but1_1_112,c
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:603: but2=(rbuf[5] & 0x02)?1:0;
	mov	a,(_main_rbuf_1_112 + 0x0005)
	mov	c,acc.1
	mov	_main_but2_1_112,c
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:604: if (rbuf[5] & 0x04) acc_x+=2;
	mov	a,(_main_rbuf_1_112 + 0x0005)
	jnb	acc.2,L027002?
	mov	a,#0x02
	add	a,_main_acc_x_1_112
	mov	_main_acc_x_1_112,a
	clr	a
	addc	a,(_main_acc_x_1_112 + 1)
	mov	(_main_acc_x_1_112 + 1),a
L027002?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:605: if (rbuf[5] & 0x08) acc_x+=1;
	mov	a,(_main_rbuf_1_112 + 0x0005)
	jnb	acc.3,L027004?
	inc	_main_acc_x_1_112
	clr	a
	cjne	a,_main_acc_x_1_112,L027047?
	inc	(_main_acc_x_1_112 + 1)
L027047?:
L027004?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:606: if (rbuf[5] & 0x10) acc_y+=2;
	mov	a,(_main_rbuf_1_112 + 0x0005)
	jnb	acc.4,L027006?
	mov	a,#0x02
	add	a,_main_acc_y_1_112
	mov	_main_acc_y_1_112,a
	clr	a
	addc	a,(_main_acc_y_1_112 + 1)
	mov	(_main_acc_y_1_112 + 1),a
L027006?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:607: if (rbuf[5] & 0x20) acc_y+=1;
	mov	a,(_main_rbuf_1_112 + 0x0005)
	jnb	acc.5,L027008?
	inc	_main_acc_y_1_112
	clr	a
	cjne	a,_main_acc_y_1_112,L027050?
	inc	(_main_acc_y_1_112 + 1)
L027050?:
L027008?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:608: if (rbuf[5] & 0x40) acc_z+=2;
	mov	a,(_main_rbuf_1_112 + 0x0005)
	jnb	acc.6,L027010?
	mov	a,#0x02
	add	a,_main_acc_z_1_112
	mov	_main_acc_z_1_112,a
	clr	a
	addc	a,(_main_acc_z_1_112 + 1)
	mov	(_main_acc_z_1_112 + 1),a
L027010?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:609: if (rbuf[5] & 0x80) acc_z+=1;
	mov	a,(_main_rbuf_1_112 + 0x0005)
	jnb	acc.7,L027012?
	inc	_main_acc_z_1_112
	clr	a
	cjne	a,_main_acc_z_1_112,L027053?
	inc	(_main_acc_z_1_112 + 1)
L027053?:
L027012?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:612: but1?'1':'0', but2?'1':'0', joy_x, joy_y, acc_x, acc_y, acc_z);
	jnb	_main_but2_1_112,L027030?
	mov	r6,#0x31
	sjmp	L027031?
L027030?:
	mov	r6,#0x30
L027031?:
	mov	a,r6
	rlc	a
	subb	a,acc
	mov	r7,a
	jnb	_main_but1_1_112,L027032?
	mov	_main_sloc0_1_0,#0x31
	sjmp	L027033?
L027032?:
	mov	_main_sloc0_1_0,#0x30
L027033?:
	mov	a,_main_sloc0_1_0
	mov	r2,a
	rlc	a
	subb	a,acc
	mov	r3,a
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:611: printf("Buttons(Z:%c, C:%c) Joystick(%4d, %4d) Accelerometer(%3d, %3d, %3d)\x1b[0J\r",
	push	ar4
	push	ar5
	push	_main_acc_z_1_112
	push	(_main_acc_z_1_112 + 1)
	push	_main_acc_y_1_112
	push	(_main_acc_y_1_112 + 1)
	push	_main_acc_x_1_112
	push	(_main_acc_x_1_112 + 1)
	push	ar4
	push	ar5
	push	_main_joy_x_1_112
	push	(_main_joy_x_1_112 + 1)
	push	ar6
	push	ar7
	push	ar2
	push	ar3
	mov	a,#__str_4
	push	acc
	mov	a,#(__str_4 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	mov	a,sp
	add	a,#0xef
	mov	sp,a
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:613: Timer4ms(100);
	mov	dpl,#0x64
	lcall	_Timer4ms
	pop	ar5
	pop	ar4
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:620: speed = get_speed(joy_y);
	mov	dpl,r4
	mov	dph,r5
	push	ar4
	push	ar5
	lcall	_get_speed
	mov	r2,dpl
	mov	r3,dph
	pop	ar5
	pop	ar4
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:627: direction=get_direction(joy_x, joy_y);
	mov	_get_direction_PARM_2,r4
	mov	(_get_direction_PARM_2 + 1),r5
	mov	dpl,_main_joy_x_1_112
	mov	dph,(_main_joy_x_1_112 + 1)
	push	ar2
	push	ar3
	lcall	_get_direction
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:628: printf("direction: %c", direction);
	mov	a,dpl
	mov	r4,a
	mov	r5,a
	rlc	a
	subb	a,acc
	mov	r6,a
	push	ar4
	push	ar5
	push	ar6
	mov	a,#__str_5
	push	acc
	mov	a,#(__str_5 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	mov	a,sp
	add	a,#0xfb
	mov	sp,a
	pop	ar4
	pop	ar3
	pop	ar2
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:630: switch(direction){
	clr	c
	mov	a,r4
	xrl	a,#0x80
	subb	a,#0xe1
	jnc	L027056?
	ljmp	L027023?
L027056?:
	clr	c
	mov	a,#(0x6A ^ 0x80)
	mov	b,r4
	xrl	b,#0x80
	subb	a,b
	jc	L027023?
	mov	a,r4
	add	a,#0x9f
	mov	r4,a
	add	a,acc
	add	a,r4
	mov	dptr,#L027058?
	jmp	@a+dptr
L027058?:
	ljmp	L027013?
	ljmp	L027014?
	ljmp	L027018?
	ljmp	L027019?
	ljmp	L027020?
	ljmp	L027017?
	ljmp	L027021?
	ljmp	L027022?
	ljmp	L027016?
	ljmp	L027015?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:632: case north :
L027013?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:634: go_straight(speed);
	mov	dpl,r2
	lcall	_go_straight
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:637: break;
	ljmp	L027026?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:640: case south: 
L027014?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:642: go_reverse(speed);
	mov	dpl,r2
	lcall	_go_reverse
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:645: break;
	ljmp	L027026?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:648: case west: 
L027015?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:650: turn_west(speed);
	mov	dpl,r2
	lcall	_turn_west
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:651: break;
	ljmp	L027026?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:654: case east: 
L027016?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:656: turn_east(speed);
	mov	dpl,r2
	lcall	_turn_east
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:657: break;
	ljmp	L027026?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:660: case NW: 
L027017?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:662: turn_NW(speed);
	mov	dpl,r2
	lcall	_turn_NW
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:663: break;
	ljmp	L027026?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:667: case NNE: 
L027018?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:669: turn_NNE(speed);
	mov	dpl,r2
	lcall	_turn_NNE
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:670: break;
	ljmp	L027026?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:673: case NNW: 
L027019?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:675: turn_NNW(speed);
	mov	dpl,r2
	lcall	_turn_NNW
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:676: break;
	ljmp	L027026?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:679: case NE: 
L027020?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:681: turn_NE(speed);
	mov	dpl,r2
	lcall	_turn_NE
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:682: break;
	ljmp	L027026?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:685: case NEE: 
L027021?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:687: turn_NEE(speed);
	mov	dpl,r2
	lcall	_turn_NEE
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:688: break;
	ljmp	L027026?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:691: case NWW: 
L027022?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:693: turn_NWW(speed);
	mov	dpl,r2
	lcall	_turn_NWW
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:694: break;
	ljmp	L027026?
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:697: default: 
L027023?:
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:699: stop();
	lcall	_stop
;	C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c:705: direction='0'; //reset direction so it stops if no direction selected. 
	ljmp	L027026?
	rseg R_CSEG

	rseg R_XINIT

	rseg R_CONST
__str_0:
	db 'Extension type: %02x  %02x  %02x  %02x  %02x  %02x'
	db 0x0A
	db 0x00
__str_1:
	db 0x1B
	db '[2J'
	db 0x1B
	db '[1;1H'
	db 0x00
__str_2:
	db 0x0A
	db 0x0A
	db 'EFM8LB1 WII Nunchuck I2C Reader'
	db 0x0A
	db 0x00
__str_3:
	db 'Offset_X:%4d Offset_Y:%4d'
	db 0x0A
	db 0x0A
	db 0x00
__str_4:
	db 'Buttons(Z:%c, C:%c) Joystick(%4d, %4d) Accelerometer(%3d, %3'
	db 'd, %3d)'
	db 0x1B
	db '[0J'
	db 0x0D
	db 0x00
__str_5:
	db 'direction: %c'
	db 0x00

	CSEG

end
