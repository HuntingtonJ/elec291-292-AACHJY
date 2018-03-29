;--------------------------------------------------------
; File Created by C51
; Version 1.0.0 #1069 (Apr 23 2015) (MSVC)
<<<<<<< HEAD
; This file was generated Thu Mar 29 15:05:40 2018
=======
; This file was generated Thu Mar 29 14:01:35 2018
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
;--------------------------------------------------------
$name Transmitter_src
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
	public _get_direction_PARM_2
	public _main
	public _getsn
	public __c51_external_startup
	public _read_nunchuck
	public _get_direction
	public _get_speed
	public _nunchuck_getdata
	public _nunchuck_init
	public _I2C_stop
	public _I2C_start
	public _I2C_read
	public _I2C_write
	public _LCDprint
	public _LCD_4BIT
	public _WriteCommand
	public _WriteData
	public _LCD_byte
	public _LCD_pulse
	public _waitms
	public _Timer2us
	public _Tcom_init
	public _getCommand
	public _PWMon
	public _PWMoff
	public _setReload
	public _setFrequency
	public _reloadToFrequency
	public _frequencyToReload
	public _sendCommandS
	public _sendCommand
	public _Timer4_ISR
	public _Timer4_init
	public _Timer2_ISR
	public _Timer2_init
	public _Timer0_ISR
	public _Timer0_init
	public _getchar1
	public _putchar1
	public _UART1_Init
<<<<<<< HEAD
	public _Z_but
=======
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	public _speedbit
	public _offset_flag
	public _nunchuck_init_PARM_1
	public _LCDprint_PARM_3
	public _reload_flag
	public _getsn_PARM_2
	public _mode
	public _read_nunchuck_PARM_5
	public _read_nunchuck_PARM_4
	public _read_nunchuck_PARM_3
	public _read_nunchuck_PARM_2
	public _get_speed_PARM_2
	public _LCDprint_PARM_2
	public _sendCommand_PARM_2
	public _reload4
	public _freq4
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
_freq4:
	ds 2
_reload4:
	ds 2
_sendCommand_PARM_2:
	ds 1
_sendCommandS_op_1_88:
	ds 1
_sendCommandS_d_1_88:
	ds 1
_LCDprint_PARM_2:
	ds 1
_nunchuck_init_buf_1_134:
	ds 6
_nunchuck_init_sloc0_1_0:
	ds 2
_nunchuck_init_sloc1_1_0:
	ds 2
_nunchuck_init_sloc2_1_0:
	ds 2
_get_speed_PARM_2:
	ds 1
_read_nunchuck_PARM_2:
	ds 3
_read_nunchuck_PARM_3:
	ds 3
_read_nunchuck_PARM_4:
	ds 2
_read_nunchuck_PARM_5:
	ds 2
_read_nunchuck_direction_1_167:
	ds 3
<<<<<<< HEAD
=======
_read_nunchuck_joy_x_1_168:
	ds 1
_read_nunchuck_joy_y_1_168:
	ds 1
_read_nunchuck_sloc0_1_0:
	ds 1
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
_mode:
	ds 1
_getsn_PARM_2:
	ds 2
_getsn_buff_1_171:
	ds 3
_getsn_sloc0_1_0:
	ds 2
_main_buffer_1_177:
	ds 6
_main_speed_1_177:
	ds 1
_main_direction_1_177:
	ds 1
_main_off_y_1_177:
	ds 2
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
	rseg	R_OSEG
	rseg	R_OSEG
	rseg	R_OSEG
	rseg	R_OSEG
	rseg	R_OSEG
	rseg	R_OSEG
_get_direction_PARM_2:
	ds 1
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
_reload_flag:
	DBIT	1
_LCDprint_PARM_3:
	DBIT	1
_nunchuck_init_PARM_1:
	DBIT	1
<<<<<<< HEAD
_read_nunchuck_Z_but_1_168:
=======
_read_nunchuck_but1_1_168:
	DBIT	1
_read_nunchuck_but2_1_168:
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	DBIT	1
_offset_flag:
	DBIT	1
_speedbit:
	DBIT	1
<<<<<<< HEAD
_Z_but:
	DBIT	1
=======
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
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
	CSEG at 0x000b
	ljmp	_Timer0_ISR
	CSEG at 0x002b
	ljmp	_Timer2_ISR
	CSEG at 0x008b
	ljmp	_Timer4_ISR
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
;	Tcom.h:29: unsigned int freq4 = 15000;
	mov	_freq4,#0x98
	mov	(_freq4 + 1),#0x3A
;	Tcom.h:30: unsigned int reload4 = 65109;
	mov	_reload4,#0x55
	mov	(_reload4 + 1),#0xFE
<<<<<<< HEAD
;	Transmitter_src.c:17: volatile unsigned char mode = 1;
=======
;	Transmitter_src.c:16: volatile unsigned char mode = 1;
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	_mode,#0x01
;	Tcom.h:28: volatile bit reload_flag = 0;
	clr	_reload_flag
;	Transmitter_src.c:13: volatile unsigned bit offset_flag=1;
	setb	_offset_flag
;	Transmitter_src.c:14: volatile unsigned bit speedbit=1;
	setb	_speedbit
<<<<<<< HEAD
;	Transmitter_src.c:15: volatile unsigned bit  Z_but=0;
	clr	_Z_but
=======
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	; The linker places a 'ret' at the end of segment R_DINIT.
;--------------------------------------------------------
; code
;--------------------------------------------------------
	rseg R_CSEG
;------------------------------------------------------------
;Allocation info for local variables in function 'UART1_Init'
;------------------------------------------------------------
;baudrate                  Allocated to registers r2 r3 r4 r5 
;------------------------------------------------------------
;	EFM8UART1lib.h:11: void UART1_Init (unsigned long baudrate)
;	-----------------------------------------
;	 function UART1_Init
;	-----------------------------------------
_UART1_Init:
	using	0
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
;	EFM8UART1lib.h:13: SFRPAGE = 0x20;
	mov	_SFRPAGE,#0x20
;	EFM8UART1lib.h:14: SMOD1 = 0x0C; // no parity, 8 data bits, 1 stop bit
	mov	_SMOD1,#0x0C
;	EFM8UART1lib.h:15: SCON1 = 0x10; //Receive fifo overrun flag = 0; Parity Error Flag = 0; 0; Receive enable flag = 1; TBX = 0; RBX = 0; Transmit Interrupt Flag = 0; Receive Interrupt FLag = 0;
	mov	_SCON1,#0x10
;	EFM8UART1lib.h:16: SBCON1 =0x00;   // disable baud rate generator
	mov	_SBCON1,#0x00
;	EFM8UART1lib.h:17: SBRL1 = 0x10000L-((SYSCLK/baudrate)/(12L*2L));  //Baud rate reload
	mov	__divulong_PARM_2,r2
	mov	(__divulong_PARM_2 + 1),r3
	mov	(__divulong_PARM_2 + 2),r4
	mov	(__divulong_PARM_2 + 3),r5
	mov	dptr,#0xA200
	mov	b,#0x4A
	mov	a,#0x04
	lcall	__divulong
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	mov	__divulong_PARM_2,#0x18
	clr	a
	mov	(__divulong_PARM_2 + 1),a
	mov	(__divulong_PARM_2 + 2),a
	mov	(__divulong_PARM_2 + 3),a
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	mov	a,r5
	lcall	__divulong
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	clr	a
	clr	c
	subb	a,r2
	mov	r2,a
	clr	a
	subb	a,r3
	mov	r3,a
	mov	a,#0x01
	subb	a,r4
	clr	a
	subb	a,r5
	mov	_SBRL1,r2
	mov	(_SBRL1 >> 8),r3
;	EFM8UART1lib.h:18: TI1 = 1; // indicate ready for TX
	setb	_TI1
;	EFM8UART1lib.h:19: SBCON1 |= 0x40;   // enable baud rate generator
	orl	_SBCON1,#0x40
;	EFM8UART1lib.h:20: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'putchar1'
;------------------------------------------------------------
;c                         Allocated to registers r2 
;------------------------------------------------------------
;	EFM8UART1lib.h:23: void putchar1 (char c) 
;	-----------------------------------------
;	 function putchar1
;	-----------------------------------------
_putchar1:
	mov	r2,dpl
;	EFM8UART1lib.h:25: SFRPAGE = 0x20;
	mov	_SFRPAGE,#0x20
;	EFM8UART1lib.h:26: if (c == '\n') 
	cjne	r2,#0x0A,L003006?
;	EFM8UART1lib.h:28: while (!TI1);
L003001?:
;	EFM8UART1lib.h:29: TI1=0;
	jbc	_TI1,L003017?
	sjmp	L003001?
L003017?:
;	EFM8UART1lib.h:30: SBUF1 = '\r';
	mov	_SBUF1,#0x0D
;	EFM8UART1lib.h:32: while (!TI1);
L003006?:
;	EFM8UART1lib.h:33: TI1=0;
	jbc	_TI1,L003018?
	sjmp	L003006?
L003018?:
;	EFM8UART1lib.h:34: SBUF1 = c;
	mov	_SBUF1,r2
;	EFM8UART1lib.h:35: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'getchar1'
;------------------------------------------------------------
;c                         Allocated to registers 
;------------------------------------------------------------
;	EFM8UART1lib.h:38: char getchar1 (void)
;	-----------------------------------------
;	 function getchar1
;	-----------------------------------------
_getchar1:
;	EFM8UART1lib.h:41: SFRPAGE = 0x20;
	mov	_SFRPAGE,#0x20
;	EFM8UART1lib.h:42: while (!RI1);
L004001?:
;	EFM8UART1lib.h:43: RI1=0;
	jbc	_RI1,L004008?
	sjmp	L004001?
L004008?:
;	EFM8UART1lib.h:45: SCON1&=0b_0011_1111;
	anl	_SCON1,#0x3F
;	EFM8UART1lib.h:46: c = SBUF1;
	mov	dpl,_SBUF1
;	EFM8UART1lib.h:47: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
;	EFM8UART1lib.h:48: return (c);
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Timer0_init'
;------------------------------------------------------------
;------------------------------------------------------------
;	Tcom.h:34: void Timer0_init(void){
;	-----------------------------------------
;	 function Timer0_init
;	-----------------------------------------
_Timer0_init:
;	Tcom.h:37: CKCON0 |= 0b_0000_0100; // Timer0 clock source = SYSCLK/12
	orl	_CKCON0,#0x04
;	Tcom.h:38: TMOD &= 0xf0;  // Mask out timer 1 bits
	anl	_TMOD,#0xF0
;	Tcom.h:39: TMOD |= 0x02;  // Timer0 in 8-bit auto-reload mode
	orl	_TMOD,#0x02
;	Tcom.h:41: TL0 = TH0 = 256-(SYSCLK/SMB_FREQUENCY/3);
	mov	_TH0,#0x10
	mov	_TL0,#0x10
;	Tcom.h:42: TR0 = 1; // Enable timer 0
	setb	_TR0
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Timer0_ISR'
;------------------------------------------------------------
;------------------------------------------------------------
;	Tcom.h:47: void Timer0_ISR (void) interrupt INTERRUPT_TIMER0 {
;	-----------------------------------------
;	 function Timer0_ISR
;	-----------------------------------------
_Timer0_ISR:
;	Tcom.h:48: TF0 = 0;
	clr	_TF0
;	Tcom.h:49: SI=0;
	clr	_SI
	reti
;	eliminated unneeded push/pop psw
;	eliminated unneeded push/pop dpl
;	eliminated unneeded push/pop dph
;	eliminated unneeded push/pop b
;	eliminated unneeded push/pop acc
;------------------------------------------------------------
;Allocation info for local variables in function 'Timer2_init'
;------------------------------------------------------------
;------------------------------------------------------------
;	Tcom.h:54: void Timer2_init(void) {
;	-----------------------------------------
;	 function Timer2_init
;	-----------------------------------------
_Timer2_init:
;	Tcom.h:55: TMR2CN0=0b_0000_0000;   // Stop Timer2; Clear TF2; T2XCLK uses Sysclk/12
	mov	_TMR2CN0,#0x00
;	Tcom.h:56: CKCON0|=0b_0000_0000; // Timer 2 uses the system clock; Timer2 uses T2XCLK
	mov	_CKCON0,_CKCON0
;	Tcom.h:57: TMR2RL=64936; //Initilizes reload value for 100hz;
	mov	_TMR2RL,#0xA8
	mov	(_TMR2RL >> 8),#0xFD
;	Tcom.h:58: TMR2=0xffff;   // Set to reload immediately
	mov	_TMR2,#0xFF
	mov	(_TMR2 >> 8),#0xFF
;	Tcom.h:59: ET2=0;         // Enable Timer2 interrupts
	clr	_ET2
;	Tcom.h:60: TR2=1;         // Start Timer2 (TMR2CN is bit addressable)
	setb	_TR2
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Timer2_ISR'
;------------------------------------------------------------
;------------------------------------------------------------
;	Tcom.h:63: void Timer2_ISR (void) interrupt 5 {
;	-----------------------------------------
;	 function Timer2_ISR
;	-----------------------------------------
_Timer2_ISR:
;	Tcom.h:64: SFRPAGE=0x00;
	mov	_SFRPAGE,#0x00
;	Tcom.h:66: TF2H = 0; // Clear Timer2 interrupt flag
	clr	_TF2H
	reti
;	eliminated unneeded push/pop psw
;	eliminated unneeded push/pop dpl
;	eliminated unneeded push/pop dph
;	eliminated unneeded push/pop b
;	eliminated unneeded push/pop acc
;------------------------------------------------------------
;Allocation info for local variables in function 'Timer4_init'
;------------------------------------------------------------
;------------------------------------------------------------
;	Tcom.h:88: void Timer4_init(void) {
;	-----------------------------------------
;	 function Timer4_init
;	-----------------------------------------
_Timer4_init:
;	Tcom.h:89: SFRPAGE=0x10;
	mov	_SFRPAGE,#0x10
;	Tcom.h:90: TMR4CN0=0b_0000_0000;
	mov	_TMR4CN0,#0x00
;	Tcom.h:91: TMR4CN1=0b_0110_0000;
	mov	_TMR4CN1,#0x60
;	Tcom.h:93: TMR4RL=reload4; //reload = 2^16 - (SYSCLK/12)/(F*2); 15kHz
	mov	_TMR4RL,_reload4
	mov	(_TMR4RL >> 8),(_reload4 + 1)
;	Tcom.h:94: TMR4=0xffff;
	mov	_TMR4,#0xFF
	mov	(_TMR4 >> 8),#0xFF
;	Tcom.h:96: EIE2|=0b_0000_0100;
	orl	_EIE2,#0x04
;	Tcom.h:97: TR4=1;
	setb	_TR4
;	Tcom.h:98: SFRPAGE=0x00;
	mov	_SFRPAGE,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Timer4_ISR'
;------------------------------------------------------------
;------------------------------------------------------------
;	Tcom.h:102: void Timer4_ISR(void) interrupt INTERRUPT_TIMER4 {
;	-----------------------------------------
;	 function Timer4_ISR
;	-----------------------------------------
_Timer4_ISR:
;	Tcom.h:103: reload_flag = 1;
	setb	_reload_flag
;	Tcom.h:104: TF4H = 0; //interrupt flag
	clr	_TF4H
;	Tcom.h:106: OUT0 = !OUT0;
	cpl	_P2_0
;	Tcom.h:107: reload_flag = 0;
	clr	_reload_flag
	reti
;	eliminated unneeded push/pop psw
;	eliminated unneeded push/pop dpl
;	eliminated unneeded push/pop dph
;	eliminated unneeded push/pop b
;	eliminated unneeded push/pop acc
;------------------------------------------------------------
;Allocation info for local variables in function 'sendCommand'
;------------------------------------------------------------
;value                     Allocated with name '_sendCommand_PARM_2'
;op                        Allocated to registers r2 
;------------------------------------------------------------
;	Tcom.h:110: void sendCommand(unsigned char op, unsigned char value) {
;	-----------------------------------------
;	 function sendCommand
;	-----------------------------------------
_sendCommand:
	mov	r2,dpl
;	Tcom.h:111: if (op < 0b_1000 && value < 0b_100000) {
	cjne	r2,#0x08,L011009?
L011009?:
	jnc	L011002?
	mov	a,#0x100 - 0x20
	add	a,_sendCommand_PARM_2
	jc	L011002?
<<<<<<< HEAD
;	Tcom.h:112: putchar1(op*0b_100000 + value); // This code is problematic as it multiplies 32 by our value..... Temporary fix is to subtract 31 from our direction on receiver side. 
=======
;	Tcom.h:112: putchar1(op*0b_100000 + value);
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	a,r2
	swap	a
	rl	a
	anl	a,#0xe0
	mov	r3,a
	mov	a,_sendCommand_PARM_2
	add	a,r3
	mov	dpl,a
	push	ar2
	lcall	_putchar1
	pop	ar2
;	Tcom.h:113: printf("Sent: %d\r\n", op*0b_100000 + value);
	mov	a,r2
	mov	b,#0x20
	mul	ab
	mov	r2,a
	mov	r3,b
	mov	r4,_sendCommand_PARM_2
	mov	r5,#0x00
	mov	a,r4
	add	a,r2
	mov	r2,a
	mov	a,r5
	addc	a,r3
	mov	r3,a
	push	ar2
	push	ar3
	mov	a,#__str_0
	push	acc
	mov	a,#(__str_0 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	mov	a,sp
	add	a,#0xfb
	mov	sp,a
	ret
L011002?:
;	Tcom.h:115: printf("c err\r\n");
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
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'sendCommandS'
;------------------------------------------------------------
;input                     Allocated to registers r2 r3 r4 
;op                        Allocated with name '_sendCommandS_op_1_88'
;d                         Allocated with name '_sendCommandS_d_1_88'
;------------------------------------------------------------
;	Tcom.h:119: void sendCommandS(char* input) {
;	-----------------------------------------
;	 function sendCommandS
;	-----------------------------------------
_sendCommandS:
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
;	Tcom.h:123: sscanf(input, "%*s %c %c", &op, &d);
	mov	a,#_sendCommandS_d_1_88
	push	acc
	mov	a,#(_sendCommandS_d_1_88 >> 8)
	push	acc
	mov	a,#0x40
	push	acc
	mov	a,#_sendCommandS_op_1_88
	push	acc
	mov	a,#(_sendCommandS_op_1_88 >> 8)
	push	acc
	mov	a,#0x40
	push	acc
	mov	a,#__str_2
	push	acc
	mov	a,#(__str_2 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	push	ar2
	push	ar3
	push	ar4
	lcall	_sscanf
	mov	a,sp
	add	a,#0xf4
	mov	sp,a
;	Tcom.h:125: switch(op) {
	mov	r2,_sendCommandS_op_1_88
	cjne	r2,#0x66,L012011?
	sjmp	L012002?
L012011?:
	mov	ar3,r2
	cjne	r3,#0x72,L012012?
	sjmp	L012003?
L012012?:
	cjne	r2,#0x73,L012004?
;	Tcom.h:127: op = 0;
	mov	_sendCommandS_op_1_88,#0x00
;	Tcom.h:128: break;
;	Tcom.h:129: case 'f':
	sjmp	L012005?
L012002?:
;	Tcom.h:130: op = 0b_001;
	mov	_sendCommandS_op_1_88,#0x01
;	Tcom.h:131: break;
;	Tcom.h:132: case 'r':
	sjmp	L012005?
L012003?:
;	Tcom.h:133: op = 0b_010;
	mov	_sendCommandS_op_1_88,#0x02
;	Tcom.h:134: break;
;	Tcom.h:135: default:
	sjmp	L012005?
L012004?:
;	Tcom.h:136: return;
;	Tcom.h:137: }
	ret
L012005?:
;	Tcom.h:138: sendCommand(op, d);
	mov	_sendCommand_PARM_2,_sendCommandS_d_1_88
	mov	dpl,_sendCommandS_op_1_88
	ljmp	_sendCommand
;------------------------------------------------------------
;Allocation info for local variables in function 'frequencyToReload'
;------------------------------------------------------------
;freq                      Allocated to registers r2 r3 
;------------------------------------------------------------
;	Tcom.h:157: unsigned int frequencyToReload(unsigned int freq) {
;	-----------------------------------------
;	 function frequencyToReload
;	-----------------------------------------
_frequencyToReload:
	mov	r2,dpl
;	Tcom.h:158: return 65536 - ((SYSCLK/12)/(freq*2));
	mov	a,dph
	xch	a,r2
	add	a,acc
	xch	a,r2
	rlc	a
	mov	r3,a
	mov	__divslong_PARM_2,r2
	mov	(__divslong_PARM_2 + 1),r3
	mov	(__divslong_PARM_2 + 2),#0x00
	mov	(__divslong_PARM_2 + 3),#0x00
	mov	dptr,#0x8D80
	mov	b,#0x5B
	clr	a
	lcall	__divslong
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	clr	a
	clr	c
	subb	a,r2
	mov	r2,a
	clr	a
	subb	a,r3
	mov	r3,a
	mov	a,#0x01
	subb	a,r4
	clr	a
	subb	a,r5
	mov	dpl,r2
	mov	dph,r3
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'reloadToFrequency'
;------------------------------------------------------------
;reload                    Allocated to registers r2 r3 
;------------------------------------------------------------
;	Tcom.h:161: unsigned int reloadToFrequency(unsigned int reload) {
;	-----------------------------------------
;	 function reloadToFrequency
;	-----------------------------------------
_reloadToFrequency:
	mov	r2,dpl
	mov	r3,dph
;	Tcom.h:162: return ((SYSCLK/12)/(65536 - reload))/2;
	mov	r4,#0x00
	clr	a
	mov	r5,a
	clr	c
	subb	a,r2
	mov	__divslong_PARM_2,a
	clr	a
	subb	a,r3
	mov	(__divslong_PARM_2 + 1),a
	mov	a,#0x01
	subb	a,r4
	mov	(__divslong_PARM_2 + 2),a
	clr	a
	subb	a,r5
	mov	(__divslong_PARM_2 + 3),a
	mov	dptr,#0x8D80
	mov	b,#0x5B
	clr	a
	lcall	__divslong
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	mov	__divslong_PARM_2,#0x02
	clr	a
	mov	(__divslong_PARM_2 + 1),a
	mov	(__divslong_PARM_2 + 2),a
	mov	(__divslong_PARM_2 + 3),a
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	mov	a,r5
	ljmp	__divslong
;------------------------------------------------------------
;Allocation info for local variables in function 'setFrequency'
;------------------------------------------------------------
;input                     Allocated to registers r2 r3 r4 
;------------------------------------------------------------
;	Tcom.h:165: void setFrequency(char* input) {
;	-----------------------------------------
;	 function setFrequency
;	-----------------------------------------
_setFrequency:
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
;	Tcom.h:166: sscanf(input, "%*s %u", &freq4);
	mov	a,#_freq4
	push	acc
	mov	a,#(_freq4 >> 8)
	push	acc
	mov	a,#0x40
	push	acc
	mov	a,#__str_3
	push	acc
	mov	a,#(__str_3 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	push	ar2
	push	ar3
	push	ar4
	lcall	_sscanf
	mov	a,sp
	add	a,#0xf7
	mov	sp,a
;	Tcom.h:167: while(reload_flag != 0);
L015001?:
	jb	_reload_flag,L015001?
;	Tcom.h:168: reload4 = frequencyToReload(freq4);
	mov	dpl,_freq4
	mov	dph,(_freq4 + 1)
	lcall	_frequencyToReload
	mov	_reload4,dpl
	mov	(_reload4 + 1),dph
;	Tcom.h:169: SFRPAGE = 0x10;
	mov	_SFRPAGE,#0x10
;	Tcom.h:170: TMR4RL = reload4;
	mov	_TMR4RL,_reload4
	mov	(_TMR4RL >> 8),(_reload4 + 1)
;	Tcom.h:171: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
;	Tcom.h:172: printf("Set timer4 freq to: %d\r\n", freq4);
	push	_freq4
	push	(_freq4 + 1)
	mov	a,#__str_4
	push	acc
	mov	a,#(__str_4 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	mov	a,sp
	add	a,#0xfb
	mov	sp,a
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'setReload'
;------------------------------------------------------------
;input                     Allocated to registers r2 r3 r4 
;------------------------------------------------------------
;	Tcom.h:175: void setReload(char* input) {
;	-----------------------------------------
;	 function setReload
;	-----------------------------------------
_setReload:
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
;	Tcom.h:176: sscanf(input, "%*s %u", &reload4);
	mov	a,#_reload4
	push	acc
	mov	a,#(_reload4 >> 8)
	push	acc
	mov	a,#0x40
	push	acc
	mov	a,#__str_3
	push	acc
	mov	a,#(__str_3 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	push	ar2
	push	ar3
	push	ar4
	lcall	_sscanf
	mov	a,sp
	add	a,#0xf7
	mov	sp,a
;	Tcom.h:177: while(reload_flag != 0);
L016001?:
	jb	_reload_flag,L016001?
;	Tcom.h:178: freq4 = reloadToFrequency(reload4);
	mov	dpl,_reload4
	mov	dph,(_reload4 + 1)
	lcall	_reloadToFrequency
	mov	_freq4,dpl
	mov	(_freq4 + 1),dph
;	Tcom.h:179: SFRPAGE = 0x10;
	mov	_SFRPAGE,#0x10
;	Tcom.h:180: TMR4RL = reload4;
	mov	_TMR4RL,_reload4
	mov	(_TMR4RL >> 8),(_reload4 + 1)
;	Tcom.h:181: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
;	Tcom.h:182: printf("Set timer4 reload to: %d\r\n", reload4);
	push	_reload4
	push	(_reload4 + 1)
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
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'PWMoff'
;------------------------------------------------------------
;------------------------------------------------------------
;	Tcom.h:200: void PWMoff() {
;	-----------------------------------------
;	 function PWMoff
;	-----------------------------------------
_PWMoff:
;	Tcom.h:201: OUT0 = 0;
	clr	_P2_0
;	Tcom.h:202: OUT1 = 0;
	clr	_P1_6
;	Tcom.h:203: TR2 = 0;
	clr	_TR2
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'PWMon'
;------------------------------------------------------------
;------------------------------------------------------------
;	Tcom.h:206: void PWMon() {
;	-----------------------------------------
;	 function PWMon
;	-----------------------------------------
_PWMon:
;	Tcom.h:207: TR2 = 1;
	setb	_TR2
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'getCommand'
;------------------------------------------------------------
;input                     Allocated to registers r2 r3 r4 
;------------------------------------------------------------
;	Tcom.h:210: void getCommand(char* input) {
;	-----------------------------------------
;	 function getCommand
;	-----------------------------------------
_getCommand:
;	Tcom.h:212: if (input[0] == '-') {
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	lcall	__gptrget
	mov	r5,a
	cjne	r5,#0x2D,L019031?
	sjmp	L019032?
L019031?:
	ljmp	L019016?
L019032?:
;	Tcom.h:213: switch(input[1]) {
	mov	a,#0x01
	add	a,r2
	mov	r5,a
	clr	a
	addc	a,r3
	mov	r6,a
	mov	ar7,r4
	mov	dpl,r5
	mov	dph,r6
	mov	b,r7
	lcall	__gptrget
	mov	r5,a
	cjne	r5,#0x2F,L019033?
	sjmp	L019001?
L019033?:
	cjne	r5,#0x66,L019034?
	sjmp	L019002?
L019034?:
	cjne	r5,#0x68,L019035?
	sjmp	L019003?
L019035?:
	cjne	r5,#0x69,L019036?
	sjmp	L019004?
L019036?:
	cjne	r5,#0x6F,L019037?
	sjmp	L019005?
L019037?:
	cjne	r5,#0x72,L019038?
	sjmp	L019008?
L019038?:
	cjne	r5,#0x73,L019039?
	ljmp	L019009?
L019039?:
	cjne	r5,#0x74,L019040?
	ljmp	L019012?
L019040?:
	ljmp	L019013?
;	Tcom.h:214: case '/':
L019001?:
;	Tcom.h:215: sendCommandS(input);
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	lcall	_sendCommandS
;	Tcom.h:216: break;
	ljmp	L019017?
;	Tcom.h:217: case 'f':
L019002?:
;	Tcom.h:218: setFrequency(input);
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	lcall	_setFrequency
;	Tcom.h:219: break;
	ljmp	L019017?
;	Tcom.h:220: case 'h':
L019003?:
;	Tcom.h:221: printf("Help Menu\r\nList of Commands: \r\n-cw [duty value]\r\n-ccw [duty value]\r\n-f [freq value]\r\n-r [reload value]\r\n-o\r\n-s\r\n-i\r\n\n");
	mov	a,#__str_6
	push	acc
	mov	a,#(__str_6 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	Tcom.h:222: break;
	ljmp	L019017?
;	Tcom.h:223: case 'i':
L019004?:
;	Tcom.h:224: printf("Reload: %u, Freq: %d \r\n", reload4, freq4);
	push	_freq4
	push	(_freq4 + 1)
	push	_reload4
	push	(_reload4 + 1)
	mov	a,#__str_7
	push	acc
	mov	a,#(__str_7 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	mov	a,sp
	add	a,#0xf9
	mov	sp,a
;	Tcom.h:225: break;
	ljmp	L019017?
;	Tcom.h:226: case 'o':
L019005?:
;	Tcom.h:227: if (input[2] == 0)
	mov	a,#0x02
	add	a,r2
	mov	r5,a
	clr	a
	addc	a,r3
	mov	r6,a
	mov	ar7,r4
	mov	dpl,r5
	mov	dph,r6
	mov	b,r7
	lcall	__gptrget
	jnz	L019017?
;	Tcom.h:228: PWMoff();
	lcall	_PWMoff
;	Tcom.h:229: break;	
;	Tcom.h:230: case 'r':
	sjmp	L019017?
L019008?:
;	Tcom.h:231: setReload(input);
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	lcall	_setReload
;	Tcom.h:232: break;
;	Tcom.h:233: case 's':
	sjmp	L019017?
L019009?:
;	Tcom.h:234: if (input[2] == 0)
	mov	a,#0x02
	add	a,r2
	mov	r5,a
	clr	a
	addc	a,r3
	mov	r6,a
	mov	ar7,r4
	mov	dpl,r5
	mov	dph,r6
	mov	b,r7
	lcall	__gptrget
	jnz	L019017?
;	Tcom.h:235: PWMon();
	lcall	_PWMon
;	Tcom.h:236: break;
;	Tcom.h:237: case 't':
	sjmp	L019017?
L019012?:
;	Tcom.h:238: putchar1(0b_1010_1010);
	mov	dpl,#0xAA
	lcall	_putchar1
;	Tcom.h:239: break;
;	Tcom.h:240: default:
	sjmp	L019017?
L019013?:
;	Tcom.h:241: printf("\"%s\" invalid command\r\n", input);
	push	ar2
	push	ar3
	push	ar4
	mov	a,#__str_8
	push	acc
	mov	a,#(__str_8 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	mov	a,sp
	add	a,#0xfa
	mov	sp,a
;	Tcom.h:243: }
	sjmp	L019017?
L019016?:
;	Tcom.h:245: printf("Not Valid input\r\n");
	mov	a,#__str_9
	push	acc
	mov	a,#(__str_9 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
L019017?:
;	Tcom.h:247: return;
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Tcom_init'
;------------------------------------------------------------
;baudrate                  Allocated to registers r2 r3 r4 r5 
;------------------------------------------------------------
;	Tcom.h:250: void Tcom_init(unsigned long baudrate) {
;	-----------------------------------------
;	 function Tcom_init
;	-----------------------------------------
_Tcom_init:
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
;	Tcom.h:256: Timer4_init(); //used for frequency-resolution interrupts
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	lcall	_Timer4_init
	pop	ar5
	pop	ar4
	pop	ar3
	pop	ar2
;	Tcom.h:259: UART1_Init(baudrate);
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	mov	a,r5
	ljmp	_UART1_Init
;------------------------------------------------------------
;Allocation info for local variables in function 'Timer2us'
;------------------------------------------------------------
;us                        Allocated to registers r2 
;i                         Allocated to registers r3 
;------------------------------------------------------------
;	EFM8core.h:9: void Timer2us(unsigned char us)
;	-----------------------------------------
;	 function Timer2us
;	-----------------------------------------
_Timer2us:
	mov	r2,dpl
;	EFM8core.h:13: SFRPAGE=0x00;
	mov	_SFRPAGE,#0x00
;	EFM8core.h:15: CKCON0|=0b_0001_0000;
	orl	_CKCON0,#0x10
;	EFM8core.h:17: TMR2RL = (-(SYSCLK)/1000000L); // Set Timer3 to overflow in 1us.
	mov	_TMR2RL,#0xB8
	mov	(_TMR2RL >> 8),#0xFF
;	EFM8core.h:18: TMR2 = TMR2RL;                 // Initialize Timer3 for first overflow
	mov	_TMR2,_TMR2RL
	mov	(_TMR2 >> 8),(_TMR2RL >> 8)
;	EFM8core.h:20: TMR2CN0 = 0x04;                 // Start Timer3 and clear overflow flag
	mov	_TMR2CN0,#0x04
;	EFM8core.h:22: for (i = 0; i < us; i++)       // Count <us> overflows
	mov	r3,#0x00
L021004?:
	clr	c
	mov	a,r3
	subb	a,r2
	jnc	L021007?
;	EFM8core.h:24: while (!(TMR2CN0 & 0x80));  // Wait for overflow
L021001?:
	mov	a,_TMR2CN0
	jnb	acc.7,L021001?
;	EFM8core.h:26: TMR2CN0 &= ~(0x80);         // Clear overflow indicator
	anl	_TMR2CN0,#0x7F
;	EFM8core.h:22: for (i = 0; i < us; i++)       // Count <us> overflows
	inc	r3
	sjmp	L021004?
L021007?:
;	EFM8core.h:29: TMR2CN0 = 0 ;                   // Stop Timer3 and clear overflow flag
	mov	_TMR2CN0,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'waitms'
;------------------------------------------------------------
;ms                        Allocated to registers r2 r3 
;j                         Allocated to registers r2 r3 
;------------------------------------------------------------
;	EFM8core.h:32: void waitms (unsigned int ms)
;	-----------------------------------------
;	 function waitms
;	-----------------------------------------
_waitms:
	mov	r2,dpl
	mov	r3,dph
;	EFM8core.h:35: for(j=ms; j!=0; j--)
L022001?:
	cjne	r2,#0x00,L022010?
	cjne	r3,#0x00,L022010?
	ret
L022010?:
;	EFM8core.h:37: Timer2us(249);
	mov	dpl,#0xF9
	push	ar2
	push	ar3
	lcall	_Timer2us
;	EFM8core.h:38: Timer2us(249);
	mov	dpl,#0xF9
	lcall	_Timer2us
;	EFM8core.h:39: Timer2us(249);
	mov	dpl,#0xF9
	lcall	_Timer2us
;	EFM8core.h:40: Timer2us(250);
	mov	dpl,#0xFA
	lcall	_Timer2us
	pop	ar3
	pop	ar2
;	EFM8core.h:35: for(j=ms; j!=0; j--)
	dec	r2
	cjne	r2,#0xff,L022011?
	dec	r3
L022011?:
	sjmp	L022001?
;------------------------------------------------------------
;Allocation info for local variables in function 'LCD_pulse'
;------------------------------------------------------------
;------------------------------------------------------------
;	EFM8LCDlib.h:15: void LCD_pulse (void)
;	-----------------------------------------
;	 function LCD_pulse
;	-----------------------------------------
_LCD_pulse:
;	EFM8LCDlib.h:17: LCD_E=1;
	setb	_P2_5
;	EFM8LCDlib.h:18: Timer2us(40);
	mov	dpl,#0x28
	lcall	_Timer2us
;	EFM8LCDlib.h:19: LCD_E=0;
	clr	_P2_5
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'LCD_byte'
;------------------------------------------------------------
;x                         Allocated to registers r2 
;------------------------------------------------------------
;	EFM8LCDlib.h:22: void LCD_byte (unsigned char x)
;	-----------------------------------------
;	 function LCD_byte
;	-----------------------------------------
_LCD_byte:
	mov	r2,dpl
;	EFM8LCDlib.h:25: ACC=x; //Send high nible
	mov	_ACC,r2
;	EFM8LCDlib.h:26: LCD_D7=ACC_7;
	mov	c,_ACC_7
	mov	_P2_1,c
;	EFM8LCDlib.h:27: LCD_D6=ACC_6;
	mov	c,_ACC_6
	mov	_P2_2,c
;	EFM8LCDlib.h:28: LCD_D5=ACC_5;
	mov	c,_ACC_5
	mov	_P2_3,c
;	EFM8LCDlib.h:29: LCD_D4=ACC_4;
	mov	c,_ACC_4
	mov	_P2_4,c
;	EFM8LCDlib.h:30: LCD_pulse();
	push	ar2
	lcall	_LCD_pulse
;	EFM8LCDlib.h:31: Timer2us(40);
	mov	dpl,#0x28
	lcall	_Timer2us
	pop	ar2
;	EFM8LCDlib.h:32: ACC=x; //Send low nible
	mov	_ACC,r2
;	EFM8LCDlib.h:33: LCD_D7=ACC_3;
	mov	c,_ACC_3
	mov	_P2_1,c
;	EFM8LCDlib.h:34: LCD_D6=ACC_2;
	mov	c,_ACC_2
	mov	_P2_2,c
;	EFM8LCDlib.h:35: LCD_D5=ACC_1;
	mov	c,_ACC_1
	mov	_P2_3,c
;	EFM8LCDlib.h:36: LCD_D4=ACC_0;
	mov	c,_ACC_0
	mov	_P2_4,c
;	EFM8LCDlib.h:37: LCD_pulse();
	ljmp	_LCD_pulse
;------------------------------------------------------------
;Allocation info for local variables in function 'WriteData'
;------------------------------------------------------------
;x                         Allocated to registers r2 
;------------------------------------------------------------
;	EFM8LCDlib.h:40: void WriteData (unsigned char x)
;	-----------------------------------------
;	 function WriteData
;	-----------------------------------------
_WriteData:
	mov	r2,dpl
;	EFM8LCDlib.h:42: LCD_RS=1;
	setb	_P2_6
;	EFM8LCDlib.h:43: LCD_byte(x);
	mov	dpl,r2
	lcall	_LCD_byte
;	EFM8LCDlib.h:44: waitms(2);
	mov	dptr,#0x0002
	ljmp	_waitms
;------------------------------------------------------------
;Allocation info for local variables in function 'WriteCommand'
;------------------------------------------------------------
;x                         Allocated to registers r2 
;------------------------------------------------------------
;	EFM8LCDlib.h:47: void WriteCommand (unsigned char x)
;	-----------------------------------------
;	 function WriteCommand
;	-----------------------------------------
_WriteCommand:
	mov	r2,dpl
;	EFM8LCDlib.h:49: LCD_RS=0;
	clr	_P2_6
;	EFM8LCDlib.h:50: LCD_byte(x);
	mov	dpl,r2
	lcall	_LCD_byte
;	EFM8LCDlib.h:51: waitms(5);
	mov	dptr,#0x0005
	ljmp	_waitms
;------------------------------------------------------------
;Allocation info for local variables in function 'LCD_4BIT'
;------------------------------------------------------------
;------------------------------------------------------------
;	EFM8LCDlib.h:54: void LCD_4BIT (void)
;	-----------------------------------------
;	 function LCD_4BIT
;	-----------------------------------------
_LCD_4BIT:
;	EFM8LCDlib.h:56: LCD_E=0; // Resting state of LCD's enable is zero
	clr	_P2_5
;	EFM8LCDlib.h:58: waitms(20);
	mov	dptr,#0x0014
	lcall	_waitms
;	EFM8LCDlib.h:60: WriteCommand(0x33);
	mov	dpl,#0x33
	lcall	_WriteCommand
;	EFM8LCDlib.h:61: WriteCommand(0x33);
	mov	dpl,#0x33
	lcall	_WriteCommand
;	EFM8LCDlib.h:62: WriteCommand(0x32); // Change to 4-bit mode
	mov	dpl,#0x32
	lcall	_WriteCommand
;	EFM8LCDlib.h:65: WriteCommand(0x28);
	mov	dpl,#0x28
	lcall	_WriteCommand
;	EFM8LCDlib.h:66: WriteCommand(0x0c);
	mov	dpl,#0x0C
	lcall	_WriteCommand
;	EFM8LCDlib.h:67: WriteCommand(0x01); // Clear screen command (takes some time)
	mov	dpl,#0x01
	lcall	_WriteCommand
;	EFM8LCDlib.h:68: waitms(20); // Wait for clear screen command to finsih.
	mov	dptr,#0x0014
	ljmp	_waitms
;------------------------------------------------------------
;Allocation info for local variables in function 'LCDprint'
;------------------------------------------------------------
;line                      Allocated with name '_LCDprint_PARM_2'
;string                    Allocated to registers r2 r3 r4 
;j                         Allocated to registers r5 r6 
;------------------------------------------------------------
;	EFM8LCDlib.h:71: void LCDprint(char * string, unsigned char line, bit clear)
;	-----------------------------------------
;	 function LCDprint
;	-----------------------------------------
_LCDprint:
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
;	EFM8LCDlib.h:75: WriteCommand(line==2?0xc0:0x80);
	mov	a,#0x02
	cjne	a,_LCDprint_PARM_2,L028013?
	mov	r5,#0xC0
	sjmp	L028014?
L028013?:
	mov	r5,#0x80
L028014?:
	mov	dpl,r5
	push	ar2
	push	ar3
	push	ar4
	lcall	_WriteCommand
;	EFM8LCDlib.h:76: waitms(5);
	mov	dptr,#0x0005
	lcall	_waitms
	pop	ar4
	pop	ar3
	pop	ar2
;	EFM8LCDlib.h:77: for(j=0; string[j]!=0; j++)	WriteData(string[j]);// Write the message
	mov	r5,#0x00
	mov	r6,#0x00
L028003?:
	mov	a,r5
	add	a,r2
	mov	r7,a
	mov	a,r6
	addc	a,r3
	mov	r0,a
	mov	ar1,r4
	mov	dpl,r7
	mov	dph,r0
	mov	b,r1
	lcall	__gptrget
	mov	r7,a
	jz	L028006?
	mov	dpl,r7
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	push	ar6
	lcall	_WriteData
	pop	ar6
	pop	ar5
	pop	ar4
	pop	ar3
	pop	ar2
	inc	r5
	cjne	r5,#0x00,L028003?
	inc	r6
	sjmp	L028003?
L028006?:
;	EFM8LCDlib.h:78: if(clear) for(; j<CHARS_PER_LINE; j++) WriteData(' '); // Clear the rest of the line
	jnb	_LCDprint_PARM_3,L028011?
	mov	ar2,r5
	mov	ar3,r6
L028007?:
	clr	c
	mov	a,r2
	subb	a,#0x10
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x80
	jnc	L028011?
	mov	dpl,#0x20
	push	ar2
	push	ar3
	lcall	_WriteData
	pop	ar3
	pop	ar2
	inc	r2
	cjne	r2,#0x00,L028007?
	inc	r3
	sjmp	L028007?
L028011?:
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'I2C_write'
;------------------------------------------------------------
;output_data               Allocated to registers 
;------------------------------------------------------------
;	Nunchuck_reader.h:83: void I2C_write (unsigned char output_data)
;	-----------------------------------------
;	 function I2C_write
;	-----------------------------------------
_I2C_write:
	mov	_SMB0DAT,dpl
;	Nunchuck_reader.h:87: SI = 0;
	clr	_SI
;	Nunchuck_reader.h:88: while (!SI); // Wait until done with send
L029001?:
	jnb	_SI,L029001?
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'I2C_read'
;------------------------------------------------------------
;input_data                Allocated to registers 
;------------------------------------------------------------
;	Nunchuck_reader.h:91: unsigned char I2C_read (void)
;	-----------------------------------------
;	 function I2C_read
;	-----------------------------------------
_I2C_read:
;	Nunchuck_reader.h:94: SI = 0;
	clr	_SI
;	Nunchuck_reader.h:95: while (!SI); // Wait until we have data to read
L030001?:
	jnb	_SI,L030001?
;	Nunchuck_reader.h:96: input_data = SMB0DAT; // Read the data
	mov	dpl,_SMB0DAT
;	Nunchuck_reader.h:98: return input_data;
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'I2C_start'
;------------------------------------------------------------
;------------------------------------------------------------
;	Nunchuck_reader.h:101: void I2C_start (void)
;	-----------------------------------------
;	 function I2C_start
;	-----------------------------------------
_I2C_start:
;	Nunchuck_reader.h:103: ACK = 1;
	setb	_ACK
;	Nunchuck_reader.h:104: STA = 1;     // Send I2C start
	setb	_STA
;	Nunchuck_reader.h:105: STO = 0;
	clr	_STO
;	Nunchuck_reader.h:106: SI = 0;
	clr	_SI
;	Nunchuck_reader.h:107: while (!SI); // Wait until start sent
L031001?:
	jnb	_SI,L031001?
;	Nunchuck_reader.h:108: STA = 0;     // Reset I2C start
	clr	_STA
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'I2C_stop'
;------------------------------------------------------------
;------------------------------------------------------------
;	Nunchuck_reader.h:111: void I2C_stop(void)
;	-----------------------------------------
;	 function I2C_stop
;	-----------------------------------------
_I2C_stop:
;	Nunchuck_reader.h:113: STO = 1;  	// Perform I2C stop
	setb	_STO
;	Nunchuck_reader.h:114: SI = 0;	// Clear SI
	clr	_SI
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'nunchuck_init'
;------------------------------------------------------------
;i                         Allocated to registers r2 
;buf                       Allocated with name '_nunchuck_init_buf_1_134'
;sloc0                     Allocated with name '_nunchuck_init_sloc0_1_0'
;sloc1                     Allocated with name '_nunchuck_init_sloc1_1_0'
;sloc2                     Allocated with name '_nunchuck_init_sloc2_1_0'
;------------------------------------------------------------
;	Nunchuck_reader.h:118: void nunchuck_init(bit print_extension_type)
;	-----------------------------------------
;	 function nunchuck_init
;	-----------------------------------------
_nunchuck_init:
;	Nunchuck_reader.h:124: I2C_start();
	lcall	_I2C_start
;	Nunchuck_reader.h:125: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	Nunchuck_reader.h:126: I2C_write(0xF0);
	mov	dpl,#0xF0
	lcall	_I2C_write
;	Nunchuck_reader.h:127: I2C_write(0x55);
	mov	dpl,#0x55
	lcall	_I2C_write
;	Nunchuck_reader.h:128: I2C_stop();
	lcall	_I2C_stop
;	Nunchuck_reader.h:129: waitms(1);
	mov	dptr,#0x0001
	lcall	_waitms
;	Nunchuck_reader.h:131: I2C_start();
	lcall	_I2C_start
;	Nunchuck_reader.h:132: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	Nunchuck_reader.h:133: I2C_write(0xFB);
	mov	dpl,#0xFB
	lcall	_I2C_write
;	Nunchuck_reader.h:134: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	Nunchuck_reader.h:135: I2C_stop();
	lcall	_I2C_stop
;	Nunchuck_reader.h:136: waitms(1);
	mov	dptr,#0x0001
	lcall	_waitms
;	Nunchuck_reader.h:140: I2C_start();
	lcall	_I2C_start
;	Nunchuck_reader.h:141: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	Nunchuck_reader.h:142: I2C_write(0xFA); // extension type register
	mov	dpl,#0xFA
	lcall	_I2C_write
;	Nunchuck_reader.h:143: I2C_stop();
	lcall	_I2C_stop
;	Nunchuck_reader.h:144: waitms(3); // 3 ms required to complete acquisition
	mov	dptr,#0x0003
	lcall	_waitms
;	Nunchuck_reader.h:146: I2C_start();
	lcall	_I2C_start
;	Nunchuck_reader.h:147: I2C_write(0xA5);
	mov	dpl,#0xA5
	lcall	_I2C_write
;	Nunchuck_reader.h:150: for(i=0; i<CHARS_PER_LINE; i++)
	mov	r2,#0x00
L033003?:
	cjne	r2,#0x10,L033013?
L033013?:
	jnc	L033006?
;	Nunchuck_reader.h:152: buf[i]=I2C_read();
	mov	a,r2
	add	a,#_nunchuck_init_buf_1_134
	mov	r0,a
	push	ar2
	push	ar0
	lcall	_I2C_read
	mov	a,dpl
	pop	ar0
	pop	ar2
	mov	@r0,a
;	Nunchuck_reader.h:150: for(i=0; i<CHARS_PER_LINE; i++)
	inc	r2
	sjmp	L033003?
L033006?:
;	Nunchuck_reader.h:154: ACK=0;
	clr	_ACK
;	Nunchuck_reader.h:155: I2C_stop();
	lcall	_I2C_stop
;	Nunchuck_reader.h:156: waitms(3);
	mov	dptr,#0x0003
	lcall	_waitms
;	Nunchuck_reader.h:158: if(print_extension_type)
	jnb	_nunchuck_init_PARM_1,L033002?
;	Nunchuck_reader.h:161: buf[0],  buf[1], buf[2], buf[3], buf[4], buf[5]);
	mov	r2,(_nunchuck_init_buf_1_134 + 0x0005)
	mov	r3,#0x00
	mov	r4,(_nunchuck_init_buf_1_134 + 0x0004)
	mov	r5,#0x00
	mov	_nunchuck_init_sloc0_1_0,(_nunchuck_init_buf_1_134 + 0x0003)
	mov	(_nunchuck_init_sloc0_1_0 + 1),#0x00
	mov	_nunchuck_init_sloc1_1_0,(_nunchuck_init_buf_1_134 + 0x0002)
	mov	(_nunchuck_init_sloc1_1_0 + 1),#0x00
	mov	_nunchuck_init_sloc2_1_0,(_nunchuck_init_buf_1_134 + 0x0001)
	mov	(_nunchuck_init_sloc2_1_0 + 1),#0x00
	mov	r6,_nunchuck_init_buf_1_134
	mov	r7,#0x00
;	Nunchuck_reader.h:160: printf("Extension type: %02x  %02x  %02x  %02x  %02x  %02x\n", 
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
	mov	a,#__str_10
	push	acc
	mov	a,#(__str_10 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	mov	a,sp
	add	a,#0xf1
	mov	sp,a
L033002?:
;	Nunchuck_reader.h:166: I2C_start();
	lcall	_I2C_start
;	Nunchuck_reader.h:167: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	Nunchuck_reader.h:168: I2C_write(0xF0);
	mov	dpl,#0xF0
	lcall	_I2C_write
;	Nunchuck_reader.h:169: I2C_write(0xAA);
	mov	dpl,#0xAA
	lcall	_I2C_write
;	Nunchuck_reader.h:170: I2C_stop();
	lcall	_I2C_stop
;	Nunchuck_reader.h:171: waitms(1);
	mov	dptr,#0x0001
	lcall	_waitms
;	Nunchuck_reader.h:173: I2C_start();
	lcall	_I2C_start
;	Nunchuck_reader.h:174: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	Nunchuck_reader.h:175: I2C_write(0x40);
	mov	dpl,#0x40
	lcall	_I2C_write
;	Nunchuck_reader.h:176: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	Nunchuck_reader.h:177: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	Nunchuck_reader.h:178: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	Nunchuck_reader.h:179: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	Nunchuck_reader.h:180: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	Nunchuck_reader.h:181: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	Nunchuck_reader.h:182: I2C_stop();
	lcall	_I2C_stop
;	Nunchuck_reader.h:183: waitms(1);
	mov	dptr,#0x0001
	lcall	_waitms
;	Nunchuck_reader.h:185: I2C_start();
	lcall	_I2C_start
;	Nunchuck_reader.h:186: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	Nunchuck_reader.h:187: I2C_write(0x40);
	mov	dpl,#0x40
	lcall	_I2C_write
;	Nunchuck_reader.h:188: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	Nunchuck_reader.h:189: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	Nunchuck_reader.h:190: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	Nunchuck_reader.h:191: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	Nunchuck_reader.h:192: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	Nunchuck_reader.h:193: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	Nunchuck_reader.h:194: I2C_stop();
	lcall	_I2C_stop
;	Nunchuck_reader.h:195: waitms(1);
	mov	dptr,#0x0001
	lcall	_waitms
;	Nunchuck_reader.h:197: I2C_start();
	lcall	_I2C_start
;	Nunchuck_reader.h:198: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	Nunchuck_reader.h:199: I2C_write(0x40);
	mov	dpl,#0x40
	lcall	_I2C_write
;	Nunchuck_reader.h:200: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	Nunchuck_reader.h:201: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	Nunchuck_reader.h:202: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	Nunchuck_reader.h:203: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	Nunchuck_reader.h:204: I2C_stop();
	lcall	_I2C_stop
;	Nunchuck_reader.h:205: waitms(1);
	mov	dptr,#0x0001
	ljmp	_waitms
;------------------------------------------------------------
;Allocation info for local variables in function 'nunchuck_getdata'
;------------------------------------------------------------
;s                         Allocated to registers r2 r3 r4 
;i                         Allocated to registers r5 
;------------------------------------------------------------
;	Nunchuck_reader.h:208: void nunchuck_getdata(unsigned char * s)
;	-----------------------------------------
;	 function nunchuck_getdata
;	-----------------------------------------
_nunchuck_getdata:
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
;	Nunchuck_reader.h:213: I2C_start();
	push	ar2
	push	ar3
	push	ar4
	lcall	_I2C_start
;	Nunchuck_reader.h:214: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	Nunchuck_reader.h:215: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	Nunchuck_reader.h:216: I2C_stop();
	lcall	_I2C_stop
;	Nunchuck_reader.h:217: waitms(3); 	// 3 ms required to complete acquisition
	mov	dptr,#0x0003
	lcall	_waitms
;	Nunchuck_reader.h:220: I2C_start();
	lcall	_I2C_start
;	Nunchuck_reader.h:221: I2C_write(0xA5);
	mov	dpl,#0xA5
	lcall	_I2C_write
	pop	ar4
	pop	ar3
	pop	ar2
;	Nunchuck_reader.h:224: for(i=0; i<CHARS_PER_LINE; i++)
	mov	r5,#0x00
L034001?:
	cjne	r5,#0x10,L034010?
L034010?:
	jnc	L034004?
;	Nunchuck_reader.h:226: s[i]=(I2C_read()^0x17)+0x17; // Read and decrypt
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
;	Nunchuck_reader.h:224: for(i=0; i<CHARS_PER_LINE; i++)
	inc	r5
	sjmp	L034001?
L034004?:
;	Nunchuck_reader.h:228: ACK=0;
	clr	_ACK
;	Nunchuck_reader.h:229: I2C_stop();
	ljmp	_I2C_stop
;------------------------------------------------------------
;Allocation info for local variables in function 'get_speed'
;------------------------------------------------------------
;y_ax                      Allocated with name '_get_speed_PARM_2'
;x_ax                      Allocated to registers r2 
;spd                       Allocated to registers r4 
;------------------------------------------------------------
;	Nunchuck_reader.h:235: char get_speed(char x_ax, char y_ax){
;	-----------------------------------------
;	 function get_speed
;	-----------------------------------------
_get_speed:
	mov	r2,dpl
;	Nunchuck_reader.h:237: y_ax=abs(y_ax);
	mov	a,_get_speed_PARM_2
	mov	r3,a
	rlc	a
	subb	a,acc
	mov	r4,a
	mov	dpl,r3
	mov	dph,r4
	push	ar2
	lcall	_abs
	mov	r3,dpl
	pop	ar2
;	Nunchuck_reader.h:238: x_ax=abs(x_ax);
	mov	a,r2
	mov	r4,a
	rlc	a
	subb	a,acc
	mov	r5,a
	mov	dpl,r4
	mov	dph,r5
	push	ar3
	lcall	_abs
	mov	r4,dpl
	mov	r5,dph
	pop	ar3
	mov	ar2,r4
;	Nunchuck_reader.h:240: if(y_ax>x_ax){
	clr	c
	mov	a,r2
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	L035004?
;	Nunchuck_reader.h:241: spd=y_ax;
	mov	ar4,r3
;	Nunchuck_reader.h:242: if(y_ax>85)
	clr	c
	mov	a,#(0x55 ^ 0x80)
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	L035005?
;	Nunchuck_reader.h:243: spd=100;
	mov	r4,#0x64
	sjmp	L035005?
L035004?:
;	Nunchuck_reader.h:245: else spd=x_ax;
	mov	ar4,r2
L035005?:
;	Nunchuck_reader.h:247: return spd/TRANSMISSION_SIZE;
	clr	F0
	mov	b,#0x04
	mov	a,r4
	jnb	acc.7,L035012?
	cpl	F0
	cpl	a
	inc	a
L035012?:
	div	ab
	jnb	F0,L035013?
	cpl	a
	inc	a
L035013?:
	mov	dpl,a
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'get_direction'
;------------------------------------------------------------
;y_axis                    Allocated with name '_get_direction_PARM_2'
;x_axis                    Allocated to registers r2 
;direction                 Allocated to registers r3 
;------------------------------------------------------------
;	Nunchuck_reader.h:250: char get_direction(char x_axis, char y_axis){
;	-----------------------------------------
;	 function get_direction
;	-----------------------------------------
_get_direction:
	mov	r2,dpl
;	Nunchuck_reader.h:252: char direction=north;
	mov	r3,#0x00
;	Nunchuck_reader.h:255: if(y_axis>0){
	clr	c
	clr	a
	xrl	a,#0x80
	mov	b,_get_direction_PARM_2
	xrl	b,#0x80
	subb	a,b
	jc	L036130?
	ljmp	L036084?
L036130?:
;	Nunchuck_reader.h:257: if ((x_axis<10)&&(x_axis>-10)){
	clr	c
	mov	a,r2
	xrl	a,#0x80
	subb	a,#0x8a
	jnc	L036038?
	clr	c
	mov	a,#(0xF6 ^ 0x80)
	mov	b,r2
	xrl	b,#0x80
	subb	a,b
	jnc	L036038?
;	Nunchuck_reader.h:260: if(y_axis>5&&y_axis>-5){
	clr	c
	mov	a,#(0x05 ^ 0x80)
	mov	b,_get_direction_PARM_2
	xrl	b,#0x80
	subb	a,b
	jnc	L036002?
	clr	c
	mov	a,#(0xFB ^ 0x80)
	mov	b,_get_direction_PARM_2
	xrl	b,#0x80
	subb	a,b
	jnc	L036002?
;	Nunchuck_reader.h:261: direction=north;
	mov	r3,#0x00
	ljmp	L036085?
L036002?:
;	Nunchuck_reader.h:263: else direction=north;
	mov	r3,#0x00
	ljmp	L036085?
L036038?:
;	Nunchuck_reader.h:267: else if(x_axis>10&&x_axis<=30){
	clr	c
	mov	a,#(0x0A ^ 0x80)
	mov	b,r2
	xrl	b,#0x80
	subb	a,b
	jnc	L036034?
	clr	c
	mov	a,#(0x1E ^ 0x80)
	mov	b,r2
	xrl	b,#0x80
	subb	a,b
	jc	L036034?
;	Nunchuck_reader.h:268: direction=NNE;
	mov	r3,#0x02
	ljmp	L036085?
L036034?:
;	Nunchuck_reader.h:270: else if(x_axis>30&&x_axis<=50){
	clr	c
	mov	a,#(0x1E ^ 0x80)
	mov	b,r2
	xrl	b,#0x80
	subb	a,b
	jnc	L036030?
	clr	c
	mov	a,#(0x32 ^ 0x80)
	mov	b,r2
	xrl	b,#0x80
	subb	a,b
	jc	L036030?
;	Nunchuck_reader.h:271: direction=NE;
	mov	r3,#0x04
	ljmp	L036085?
L036030?:
;	Nunchuck_reader.h:273: else if(x_axis>50&&x_axis<=70){
	clr	c
	mov	a,#(0x32 ^ 0x80)
	mov	b,r2
	xrl	b,#0x80
	subb	a,b
	jnc	L036026?
	clr	c
	mov	a,#(0x46 ^ 0x80)
	mov	b,r2
	xrl	b,#0x80
	subb	a,b
	jc	L036026?
;	Nunchuck_reader.h:274: direction=NEE;
	mov	r3,#0x06
	ljmp	L036085?
L036026?:
;	Nunchuck_reader.h:276: else if(x_axis>70&&x_axis<=100){
	clr	c
	mov	a,#(0x46 ^ 0x80)
	mov	b,r2
	xrl	b,#0x80
	subb	a,b
	jnc	L036022?
	clr	c
	mov	a,#(0x64 ^ 0x80)
	mov	b,r2
	xrl	b,#0x80
	subb	a,b
	jc	L036022?
;	Nunchuck_reader.h:277: direction=east;
	mov	r3,#0x08
	ljmp	L036085?
L036022?:
;	Nunchuck_reader.h:280: else if(x_axis<-10&&x_axis>=-30){
	clr	c
	mov	a,r2
	xrl	a,#0x80
	subb	a,#0x76
	jnc	L036018?
	clr	c
	mov	a,r2
	xrl	a,#0x80
	subb	a,#0x62
	jc	L036018?
;	Nunchuck_reader.h:281: direction=NNW;
	mov	r3,#0x03
	ljmp	L036085?
L036018?:
;	Nunchuck_reader.h:283: else if(x_axis<-30&&x_axis>=-50){
	clr	c
	mov	a,r2
	xrl	a,#0x80
	subb	a,#0x62
	jnc	L036014?
	clr	c
	mov	a,r2
	xrl	a,#0x80
	subb	a,#0x4e
	jc	L036014?
;	Nunchuck_reader.h:284: direction=NW;
	mov	r3,#0x05
	ljmp	L036085?
L036014?:
;	Nunchuck_reader.h:286: else if(x_axis<-50&&x_axis>=-70){
	clr	c
	mov	a,r2
	xrl	a,#0x80
	subb	a,#0x4e
	jnc	L036010?
	clr	c
	mov	a,r2
	xrl	a,#0x80
	subb	a,#0x3a
	jc	L036010?
;	Nunchuck_reader.h:287: direction=NWW;
	mov	r3,#0x07
	ljmp	L036085?
L036010?:
;	Nunchuck_reader.h:289: else if(x_axis<-70&&x_axis>=-110){
	clr	c
	mov	a,r2
	xrl	a,#0x80
	subb	a,#0x3a
	jnc	L036006?
	clr	c
	mov	a,r2
	xrl	a,#0x80
	subb	a,#0x12
	jc	L036006?
;	Nunchuck_reader.h:290: direction=west;
	mov	r3,#0x09
	ljmp	L036085?
L036006?:
;	Nunchuck_reader.h:293: direction=north;
	mov	r3,#0x00
	ljmp	L036085?
L036084?:
;	Nunchuck_reader.h:297: else if (y_axis<0){
	mov	a,_get_direction_PARM_2
	jb	acc.7,L036151?
	ljmp	L036085?
L036151?:
;	Nunchuck_reader.h:299: if ((x_axis<10)&&(x_axis>-10)){
	clr	c
	mov	a,r2
	xrl	a,#0x80
	subb	a,#0x8a
	jnc	L036078?
	clr	c
	mov	a,#(0xF6 ^ 0x80)
	mov	b,r2
	xrl	b,#0x80
	subb	a,b
	jnc	L036078?
;	Nunchuck_reader.h:302: if(y_axis>5&&y_axis>-5){
	clr	c
	mov	a,#(0x05 ^ 0x80)
	mov	b,_get_direction_PARM_2
	xrl	b,#0x80
	subb	a,b
	jnc	L036042?
	clr	c
	mov	a,#(0xFB ^ 0x80)
	mov	b,_get_direction_PARM_2
	xrl	b,#0x80
	subb	a,b
	jnc	L036042?
;	Nunchuck_reader.h:303: direction=south;
	mov	r3,#0x01
	ljmp	L036085?
L036042?:
;	Nunchuck_reader.h:305: else direction=south;
	mov	r3,#0x01
	ljmp	L036085?
L036078?:
;	Nunchuck_reader.h:309: else if(x_axis>10&&x_axis<=30){
	clr	c
	mov	a,#(0x0A ^ 0x80)
	mov	b,r2
	xrl	b,#0x80
	subb	a,b
	jnc	L036074?
	clr	c
	mov	a,#(0x1E ^ 0x80)
	mov	b,r2
	xrl	b,#0x80
	subb	a,b
	jc	L036074?
;	Nunchuck_reader.h:310: direction=SSE;
	mov	r3,#0x0A
	ljmp	L036085?
L036074?:
;	Nunchuck_reader.h:312: else if(x_axis>30&&x_axis<=50){
	clr	c
	mov	a,#(0x1E ^ 0x80)
	mov	b,r2
	xrl	b,#0x80
	subb	a,b
	jnc	L036070?
	clr	c
	mov	a,#(0x32 ^ 0x80)
	mov	b,r2
	xrl	b,#0x80
	subb	a,b
	jc	L036070?
;	Nunchuck_reader.h:313: direction=SE;
	mov	r3,#0x0C
	ljmp	L036085?
L036070?:
;	Nunchuck_reader.h:315: else if(x_axis>50&&x_axis<=70){
	clr	c
	mov	a,#(0x32 ^ 0x80)
	mov	b,r2
	xrl	b,#0x80
	subb	a,b
	jnc	L036066?
	clr	c
	mov	a,#(0x46 ^ 0x80)
	mov	b,r2
	xrl	b,#0x80
	subb	a,b
	jc	L036066?
;	Nunchuck_reader.h:316: direction=SEE;
	mov	r3,#0x0E
	ljmp	L036085?
L036066?:
;	Nunchuck_reader.h:318: else if(x_axis>70&&x_axis<=100){
	clr	c
	mov	a,#(0x46 ^ 0x80)
	mov	b,r2
	xrl	b,#0x80
	subb	a,b
	jnc	L036062?
	clr	c
	mov	a,#(0x64 ^ 0x80)
	mov	b,r2
	xrl	b,#0x80
	subb	a,b
	jc	L036062?
;	Nunchuck_reader.h:319: direction=east;
	mov	r3,#0x08
	sjmp	L036085?
L036062?:
;	Nunchuck_reader.h:322: else if(x_axis<-10&&x_axis>=-30){
	clr	c
	mov	a,r2
	xrl	a,#0x80
	subb	a,#0x76
	jnc	L036058?
	clr	c
	mov	a,r2
	xrl	a,#0x80
	subb	a,#0x62
	jc	L036058?
;	Nunchuck_reader.h:323: direction=SSW;
	mov	r3,#0x0B
	sjmp	L036085?
L036058?:
;	Nunchuck_reader.h:325: else if(x_axis<-30&&x_axis>=-50){
	clr	c
	mov	a,r2
	xrl	a,#0x80
	subb	a,#0x62
	jnc	L036054?
	clr	c
	mov	a,r2
	xrl	a,#0x80
	subb	a,#0x4e
	jc	L036054?
;	Nunchuck_reader.h:326: direction=SW;
	mov	r3,#0x0C
	sjmp	L036085?
L036054?:
;	Nunchuck_reader.h:328: else if(x_axis<-50&&x_axis>=-80){
	clr	c
	mov	a,r2
	xrl	a,#0x80
	subb	a,#0x4e
	jnc	L036050?
	clr	c
	mov	a,r2
	xrl	a,#0x80
	subb	a,#0x30
	jc	L036050?
;	Nunchuck_reader.h:329: direction=SWW;
	mov	r3,#0x0F
	sjmp	L036085?
L036050?:
;	Nunchuck_reader.h:331: else if(x_axis<-80&&x_axis>=-110){
	clr	c
	mov	a,r2
	xrl	a,#0x80
	subb	a,#0x30
	jnc	L036046?
	clr	c
	mov	a,r2
	xrl	a,#0x80
	subb	a,#0x12
	jc	L036046?
;	Nunchuck_reader.h:332: direction=west;
	mov	r3,#0x09
	sjmp	L036085?
L036046?:
;	Nunchuck_reader.h:335: direction=north;
	mov	r3,#0x00
L036085?:
;	Nunchuck_reader.h:341: return direction;
	mov	dpl,r3
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'read_nunchuck'
;------------------------------------------------------------
;speed                     Allocated with name '_read_nunchuck_PARM_2'
;rbuf                      Allocated with name '_read_nunchuck_PARM_3'
;off_x                     Allocated with name '_read_nunchuck_PARM_4'
;off_y                     Allocated with name '_read_nunchuck_PARM_5'
;direction                 Allocated with name '_read_nunchuck_direction_1_167'
<<<<<<< HEAD
;joy_x                     Allocated to registers r0 
;joy_y                     Allocated to registers r1 
;------------------------------------------------------------
;	Nunchuck_reader.h:346: bit read_nunchuck(char * direction, char * speed, char * rbuf, int off_x, int off_y)
=======
;joy_x                     Allocated with name '_read_nunchuck_joy_x_1_168'
;joy_y                     Allocated with name '_read_nunchuck_joy_y_1_168'
;sloc0                     Allocated with name '_read_nunchuck_sloc0_1_0'
;------------------------------------------------------------
;	Nunchuck_reader.h:346: void read_nunchuck(char * direction, char * speed, char * rbuf, int off_x, int off_y)
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
;	-----------------------------------------
;	 function read_nunchuck
;	-----------------------------------------
_read_nunchuck:
	mov	_read_nunchuck_direction_1_167,dpl
	mov	(_read_nunchuck_direction_1_167 + 1),dph
	mov	(_read_nunchuck_direction_1_167 + 2),b
;	Nunchuck_reader.h:366: nunchuck_getdata(rbuf);
	mov	r5,_read_nunchuck_PARM_3
	mov	r6,(_read_nunchuck_PARM_3 + 1)
	mov	r7,(_read_nunchuck_PARM_3 + 2)
	mov	dpl,r5
	mov	dph,r6
	mov	b,r7
	lcall	_nunchuck_getdata
;	Nunchuck_reader.h:371: joy_x=(int)rbuf[0]-128-off_x;
	mov	r5,_read_nunchuck_PARM_3
	mov	r6,(_read_nunchuck_PARM_3 + 1)
	mov	r7,(_read_nunchuck_PARM_3 + 2)
	mov	dpl,r5
	mov	dph,r6
	mov	b,r7
	lcall	__gptrget
	mov	r0,a
	rlc	a
	subb	a,acc
	mov	a,r0
	add	a,#0x80
<<<<<<< HEAD
	mov	r1,_read_nunchuck_PARM_4
	clr	c
	subb	a,r1
	mov	r0,a
=======
	mov	r0,a
	mov	r1,_read_nunchuck_PARM_4
	clr	c
	subb	a,r1
	mov	_read_nunchuck_joy_x_1_168,a
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
;	Nunchuck_reader.h:372: joy_y=(int)rbuf[1]-128-off_y;
	mov	a,#0x01
	add	a,r5
	mov	r1,a
	clr	a
	addc	a,r6
	mov	r2,a
	mov	ar3,r7
	mov	dpl,r1
	mov	dph,r2
	mov	b,r3
	lcall	__gptrget
	mov	r1,a
	rlc	a
	subb	a,acc
	mov	a,r1
	add	a,#0x80
<<<<<<< HEAD
	mov	r2,_read_nunchuck_PARM_5
	clr	c
	subb	a,r2
	mov	r1,a
;	Nunchuck_reader.h:377: Z_but=(rbuf[5] & 0x01)?1:0;
=======
	mov	r1,a
	mov	r2,_read_nunchuck_PARM_5
	clr	c
	subb	a,r2
	mov	_read_nunchuck_joy_y_1_168,a
;	Nunchuck_reader.h:377: but1=(rbuf[5] & 0x01)?1:0;
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	a,#0x05
	add	a,r5
	mov	r5,a
	clr	a
	addc	a,r6
	mov	r6,a
	mov	dpl,r5
	mov	dph,r6
	mov	b,r7
	lcall	__gptrget
<<<<<<< HEAD
	rrc	a
	mov	_read_nunchuck_Z_but_1_168,c
;	Nunchuck_reader.h:388: waitms(100); //determine if we want to change this length
	mov	dptr,#0x0064
	push	ar0
	push	ar1
	lcall	_waitms
	pop	ar1
	pop	ar0
;	Nunchuck_reader.h:393: *direction=get_direction(joy_x, joy_y);
	mov	_get_direction_PARM_2,r1
	mov	dpl,r0
	push	ar0
	push	ar1
	lcall	_get_direction
	mov	r2,dpl
	pop	ar1
	pop	ar0
=======
	mov	r5,a
	rrc	a
	mov	_read_nunchuck_but1_1_168,c
;	Nunchuck_reader.h:378: but2=(rbuf[5] & 0x02)?1:0;
	mov	a,r5
	mov	c,acc.1
	mov	_read_nunchuck_but2_1_168,c
;	Nunchuck_reader.h:387: but1?'1':'0', but2?'1':'0', joy_x, joy_y);
	mov	a,_read_nunchuck_joy_y_1_168
	mov	r3,a
	rlc	a
	subb	a,acc
	mov	r4,a
	mov	a,_read_nunchuck_joy_x_1_168
	mov	r5,a
	rlc	a
	subb	a,acc
	mov	r6,a
	jnb	_read_nunchuck_but2_1_168,L037003?
	mov	r7,#0x31
	sjmp	L037004?
L037003?:
	mov	r7,#0x30
L037004?:
	mov	a,r7
	rlc	a
	subb	a,acc
	mov	r1,a
	jnb	_read_nunchuck_but1_1_168,L037005?
	mov	_read_nunchuck_sloc0_1_0,#0x31
	sjmp	L037006?
L037005?:
	mov	_read_nunchuck_sloc0_1_0,#0x30
L037006?:
	mov	a,_read_nunchuck_sloc0_1_0
	mov	r2,a
	rlc	a
	subb	a,acc
	mov	r0,a
;	Nunchuck_reader.h:386: printf("Buttons(Z:%c, C:%c) Joystick(%4d, %4d)\r",
	push	ar3
	push	ar4
	push	ar5
	push	ar6
	push	ar7
	push	ar1
	push	ar2
	push	ar0
	mov	a,#__str_11
	push	acc
	mov	a,#(__str_11 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	mov	a,sp
	add	a,#0xf5
	mov	sp,a
;	Nunchuck_reader.h:388: waitms(100); //determine if we want to change this length
	mov	dptr,#0x0064
	lcall	_waitms
;	Nunchuck_reader.h:393: *direction=get_direction(joy_x, joy_y);
	mov	_get_direction_PARM_2,_read_nunchuck_joy_y_1_168
	mov	dpl,_read_nunchuck_joy_x_1_168
	lcall	_get_direction
	mov	r2,dpl
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	dpl,_read_nunchuck_direction_1_167
	mov	dph,(_read_nunchuck_direction_1_167 + 1)
	mov	b,(_read_nunchuck_direction_1_167 + 2)
	mov	a,r2
	lcall	__gptrput
;	Nunchuck_reader.h:394: *speed = get_speed(joy_x, joy_y);
	mov	r2,_read_nunchuck_PARM_2
	mov	r3,(_read_nunchuck_PARM_2 + 1)
	mov	r4,(_read_nunchuck_PARM_2 + 2)
<<<<<<< HEAD
	mov	_get_speed_PARM_2,r1
	mov	dpl,r0
=======
	mov	_get_speed_PARM_2,_read_nunchuck_joy_y_1_168
	mov	dpl,_read_nunchuck_joy_x_1_168
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	push	ar2
	push	ar3
	push	ar4
	lcall	_get_speed
	mov	r5,dpl
	pop	ar4
	pop	ar3
	pop	ar2
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	mov	a,r5
<<<<<<< HEAD
	lcall	__gptrput
;	Nunchuck_reader.h:396: return Z_but;
	mov	c,_read_nunchuck_Z_but_1_168
	ret
=======
	ljmp	__gptrput
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
;------------------------------------------------------------
;Allocation info for local variables in function '_c51_external_startup'
;------------------------------------------------------------
;------------------------------------------------------------
<<<<<<< HEAD
;	Transmitter_src.c:19: char _c51_external_startup (void)
=======
;	Transmitter_src.c:18: char _c51_external_startup (void)
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
;	-----------------------------------------
;	 function _c51_external_startup
;	-----------------------------------------
__c51_external_startup:
<<<<<<< HEAD
;	Transmitter_src.c:23: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
;	Transmitter_src.c:24: WDTCN = 0xDE; //First key
	mov	_WDTCN,#0xDE
;	Transmitter_src.c:25: WDTCN = 0xAD; //Second key
	mov	_WDTCN,#0xAD
;	Transmitter_src.c:27: VDM0CN |= 0x80;  // enable VDD mon
	orl	_VDM0CN,#0x80
;	Transmitter_src.c:28: RSTSRC = 0x02;
	mov	_RSTSRC,#0x02
;	Transmitter_src.c:35: SFRPAGE = 0x10;
	mov	_SFRPAGE,#0x10
;	Transmitter_src.c:36: PFE0CN  = 0x20; // SYSCLK < 75 MHz.
	mov	_PFE0CN,#0x20
;	Transmitter_src.c:37: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
;	Transmitter_src.c:58: CLKSEL = 0x00;
	mov	_CLKSEL,#0x00
;	Transmitter_src.c:59: CLKSEL = 0x00;
	mov	_CLKSEL,#0x00
;	Transmitter_src.c:60: while ((CLKSEL & 0x80) == 0);
L038001?:
	mov	a,_CLKSEL
	jnb	acc.7,L038001?
;	Transmitter_src.c:61: CLKSEL = 0x03;
	mov	_CLKSEL,#0x03
;	Transmitter_src.c:62: CLKSEL = 0x03;
	mov	_CLKSEL,#0x03
;	Transmitter_src.c:63: while ((CLKSEL & 0x80) == 0);
L038004?:
	mov	a,_CLKSEL
	jnb	acc.7,L038004?
;	Transmitter_src.c:74: SCON0 = 0x10;
	mov	_SCON0,#0x10
;	Transmitter_src.c:75: CKCON0 |= 0b_0000_0000 ; // Timer 1 uses the system clock divided by 12.
	mov	_CKCON0,_CKCON0
;	Transmitter_src.c:76: TH1 = 0x100-((SYSCLK/BAUDRATE)/(2L*12L));
	mov	_TH1,#0xE6
;	Transmitter_src.c:77: TL1 = TH1;      // Init Timer1
	mov	_TL1,_TH1
;	Transmitter_src.c:78: TMOD &= ~0xf0;  // TMOD: timer 1 in 8-bit auto-reload
	anl	_TMOD,#0x0F
;	Transmitter_src.c:79: TMOD |=  0x20;                       
	orl	_TMOD,#0x20
;	Transmitter_src.c:80: TR1 = 1; // START Timer1
	setb	_TR1
;	Transmitter_src.c:81: TI = 1;  // Indicate TX0 ready
	setb	_TI
;	Transmitter_src.c:83: P0MDOUT |= 0x14; // Enable UART0 TX as push-pull output and UART1 Tx (pin 0.2)
	orl	_P0MDOUT,#0x14
;	Transmitter_src.c:84: P1MDOUT |= 0xff; // Enable Push/Pull on port 1
	mov	a,_P1MDOUT
	mov	_P1MDOUT,#0xFF
;	Transmitter_src.c:86: XBR0     = 0b_0000_0101; // Enable UART0 on P0.4(TX) and P0.5(RX) and SMB0 I/O on (0.0 SDA) and (0.1 SCL)               
	mov	_XBR0,#0x05
;	Transmitter_src.c:87: XBR1     = 0x00; // Enable T0 on P0.0
	mov	_XBR1,#0x00
;	Transmitter_src.c:88: XBR2     = 0x41; // Enable crossbar and weak pull-ups .... (page 110) may need to set BIT0 to enable UART1 IO (0.2 Tx) and 0.3 RX
	mov	_XBR2,#0x41
;	Transmitter_src.c:90: Timer0_init();
	lcall	_Timer0_init
;	Transmitter_src.c:92: EA = 1;
	setb	_EA
;	Transmitter_src.c:95: SMB0CF = 0b_0101_1100; //INH | EXTHOLD | SMBTOE | SMBFTE ;
	mov	_SMB0CF,#0x5C
;	Transmitter_src.c:96: SMB0CF |= 0b_1000_0000;  // Enable SMBus
	orl	_SMB0CF,#0x80
;	Transmitter_src.c:99: return 0;
=======
;	Transmitter_src.c:22: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
;	Transmitter_src.c:23: WDTCN = 0xDE; //First key
	mov	_WDTCN,#0xDE
;	Transmitter_src.c:24: WDTCN = 0xAD; //Second key
	mov	_WDTCN,#0xAD
;	Transmitter_src.c:26: VDM0CN |= 0x80;  // enable VDD mon
	orl	_VDM0CN,#0x80
;	Transmitter_src.c:27: RSTSRC = 0x02;
	mov	_RSTSRC,#0x02
;	Transmitter_src.c:34: SFRPAGE = 0x10;
	mov	_SFRPAGE,#0x10
;	Transmitter_src.c:35: PFE0CN  = 0x20; // SYSCLK < 75 MHz.
	mov	_PFE0CN,#0x20
;	Transmitter_src.c:36: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
;	Transmitter_src.c:57: CLKSEL = 0x00;
	mov	_CLKSEL,#0x00
;	Transmitter_src.c:58: CLKSEL = 0x00;
	mov	_CLKSEL,#0x00
;	Transmitter_src.c:59: while ((CLKSEL & 0x80) == 0);
L038001?:
	mov	a,_CLKSEL
	jnb	acc.7,L038001?
;	Transmitter_src.c:60: CLKSEL = 0x03;
	mov	_CLKSEL,#0x03
;	Transmitter_src.c:61: CLKSEL = 0x03;
	mov	_CLKSEL,#0x03
;	Transmitter_src.c:62: while ((CLKSEL & 0x80) == 0);
L038004?:
	mov	a,_CLKSEL
	jnb	acc.7,L038004?
;	Transmitter_src.c:73: SCON0 = 0x10;
	mov	_SCON0,#0x10
;	Transmitter_src.c:74: CKCON0 |= 0b_0000_0000 ; // Timer 1 uses the system clock divided by 12.
	mov	_CKCON0,_CKCON0
;	Transmitter_src.c:75: TH1 = 0x100-((SYSCLK/BAUDRATE)/(2L*12L));
	mov	_TH1,#0xE6
;	Transmitter_src.c:76: TL1 = TH1;      // Init Timer1
	mov	_TL1,_TH1
;	Transmitter_src.c:77: TMOD &= ~0xf0;  // TMOD: timer 1 in 8-bit auto-reload
	anl	_TMOD,#0x0F
;	Transmitter_src.c:78: TMOD |=  0x20;                       
	orl	_TMOD,#0x20
;	Transmitter_src.c:79: TR1 = 1; // START Timer1
	setb	_TR1
;	Transmitter_src.c:80: TI = 1;  // Indicate TX0 ready
	setb	_TI
;	Transmitter_src.c:82: P0MDOUT |= 0x14; // Enable UART0 TX as push-pull output and UART1 Tx (pin 0.2)
	orl	_P0MDOUT,#0x14
;	Transmitter_src.c:83: P1MDOUT |= 0xff; // Enable Push/Pull on port 1
	mov	a,_P1MDOUT
	mov	_P1MDOUT,#0xFF
;	Transmitter_src.c:85: XBR0     = 0b_0000_0101; // Enable UART0 on P0.4(TX) and P0.5(RX) and SMB0 I/O on (0.0 SDA) and (0.1 SCL)               
	mov	_XBR0,#0x05
;	Transmitter_src.c:86: XBR1     = 0x00; // Enable T0 on P0.0
	mov	_XBR1,#0x00
;	Transmitter_src.c:87: XBR2     = 0x41; // Enable crossbar and weak pull-ups .... (page 110) may need to set BIT0 to enable UART1 IO (0.2 Tx) and 0.3 RX
	mov	_XBR2,#0x41
;	Transmitter_src.c:89: Timer0_init();
	lcall	_Timer0_init
;	Transmitter_src.c:91: EA = 1;
	setb	_EA
;	Transmitter_src.c:94: SMB0CF = 0b_0101_1100; //INH | EXTHOLD | SMBTOE | SMBFTE ;
	mov	_SMB0CF,#0x5C
;	Transmitter_src.c:95: SMB0CF |= 0b_1000_0000;  // Enable SMBus
	orl	_SMB0CF,#0x80
;	Transmitter_src.c:98: return 0;
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	dpl,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'getsn'
;------------------------------------------------------------
;len                       Allocated with name '_getsn_PARM_2'
;buff                      Allocated with name '_getsn_buff_1_171'
;j                         Allocated with name '_getsn_sloc0_1_0'
;c                         Allocated to registers r3 
;sloc0                     Allocated with name '_getsn_sloc0_1_0'
;------------------------------------------------------------
<<<<<<< HEAD
;	Transmitter_src.c:103: int getsn (char * buff, int len){
=======
;	Transmitter_src.c:102: int getsn (char * buff, int len){
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
;	-----------------------------------------
;	 function getsn
;	-----------------------------------------
_getsn:
	mov	_getsn_buff_1_171,dpl
	mov	(_getsn_buff_1_171 + 1),dph
	mov	(_getsn_buff_1_171 + 2),b
<<<<<<< HEAD
;	Transmitter_src.c:108: for(j=0; j<(len-1); j++)
=======
;	Transmitter_src.c:107: for(j=0; j<(len-1); j++)
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
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
L039005?:
	clr	c
	mov	a,r1
	subb	a,r7
	mov	a,r2
	xrl	a,#0x80
	mov	b,r0
	xrl	b,#0x80
	subb	a,b
	jnc	L039008?
<<<<<<< HEAD
;	Transmitter_src.c:110: c=getchar();
=======
;	Transmitter_src.c:109: c=getchar();
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
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
<<<<<<< HEAD
;	Transmitter_src.c:111: if ( (c=='\n') || (c=='\r') )
=======
;	Transmitter_src.c:110: if ( (c=='\n') || (c=='\r') )
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	cjne	r3,#0x0A,L039015?
	sjmp	L039001?
L039015?:
	cjne	r3,#0x0D,L039002?
L039001?:
<<<<<<< HEAD
;	Transmitter_src.c:113: buff[j]=0;
=======
;	Transmitter_src.c:112: buff[j]=0;
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	a,_getsn_sloc0_1_0
	add	a,_getsn_buff_1_171
	mov	r4,a
	mov	a,(_getsn_sloc0_1_0 + 1)
	addc	a,(_getsn_buff_1_171 + 1)
	mov	r5,a
	mov	r6,(_getsn_buff_1_171 + 2)
	mov	dpl,r4
	mov	dph,r5
	mov	b,r6
	clr	a
	lcall	__gptrput
<<<<<<< HEAD
;	Transmitter_src.c:114: return j;
=======
;	Transmitter_src.c:113: return j;
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	dpl,_getsn_sloc0_1_0
	mov	dph,(_getsn_sloc0_1_0 + 1)
	ret
L039002?:
<<<<<<< HEAD
;	Transmitter_src.c:118: buff[j]=c;
=======
;	Transmitter_src.c:117: buff[j]=c;
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	a,r1
	add	a,_getsn_buff_1_171
	mov	r4,a
	mov	a,r2
	addc	a,(_getsn_buff_1_171 + 1)
	mov	r5,a
	mov	r6,(_getsn_buff_1_171 + 2)
	mov	dpl,r4
	mov	dph,r5
	mov	b,r6
	mov	a,r3
	lcall	__gptrput
<<<<<<< HEAD
;	Transmitter_src.c:108: for(j=0; j<(len-1); j++)
=======
;	Transmitter_src.c:107: for(j=0; j<(len-1); j++)
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	inc	r1
	cjne	r1,#0x00,L039018?
	inc	r2
L039018?:
	mov	_getsn_sloc0_1_0,r1
	mov	(_getsn_sloc0_1_0 + 1),r2
	sjmp	L039005?
L039008?:
<<<<<<< HEAD
;	Transmitter_src.c:121: buff[j]=0;
=======
;	Transmitter_src.c:120: buff[j]=0;
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	a,_getsn_sloc0_1_0
	add	a,_getsn_buff_1_171
	mov	r2,a
	mov	a,(_getsn_sloc0_1_0 + 1)
	addc	a,(_getsn_buff_1_171 + 1)
	mov	r3,a
	mov	r4,(_getsn_buff_1_171 + 2)
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	clr	a
	lcall	__gptrput
<<<<<<< HEAD
;	Transmitter_src.c:122: return len;
=======
;	Transmitter_src.c:121: return len;
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	dpl,_getsn_PARM_2
	mov	dph,(_getsn_PARM_2 + 1)
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;buffer                    Allocated with name '_main_buffer_1_177'
;speed                     Allocated with name '_main_speed_1_177'
;direction                 Allocated with name '_main_direction_1_177'
;off_x                     Allocated to registers r2 r3 
;off_y                     Allocated with name '_main_off_y_1_177'
;------------------------------------------------------------
<<<<<<< HEAD
;	Transmitter_src.c:125: void main(void) {
=======
;	Transmitter_src.c:124: void main(void) {
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
<<<<<<< HEAD
;	Transmitter_src.c:129: int off_x=0;
;	Transmitter_src.c:130: int off_y=0;
=======
;	Transmitter_src.c:128: int off_x=0;
;	Transmitter_src.c:129: int off_y=0;
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	clr	a
	mov	r2,a
	mov	r3,a
	mov	_main_off_y_1_177,a
	mov	(_main_off_y_1_177 + 1),a
<<<<<<< HEAD
;	Transmitter_src.c:131: offset_flag=1;
	setb	_offset_flag
;	Transmitter_src.c:134: Tcom_init(110L); //enter baudrate for UART1
=======
;	Transmitter_src.c:130: offset_flag=1;
	setb	_offset_flag
;	Transmitter_src.c:132: Tcom_init(110L); //enter baudrate for UART1
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	dptr,#(0x6E&0x00ff)
	clr	a
	mov	b,a
	push	ar2
	push	ar3
	lcall	_Tcom_init
<<<<<<< HEAD
;	Transmitter_src.c:135: LCD_4BIT();
	lcall	_LCD_4BIT
;	Transmitter_src.c:137: waitms(200);
=======
;	Transmitter_src.c:133: LCD_4BIT();
	lcall	_LCD_4BIT
;	Transmitter_src.c:135: waitms(200);
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	dptr,#0x00C8
	lcall	_waitms
	pop	ar3
	pop	ar2
<<<<<<< HEAD
;	Transmitter_src.c:138: if (mode == 1) {
	mov	a,#0x01
	cjne	a,_mode,L040002?
;	Transmitter_src.c:139: nunchuck_init(1);
=======
;	Transmitter_src.c:136: if (mode == 1) {
	mov	a,#0x01
	cjne	a,_mode,L040002?
;	Transmitter_src.c:137: nunchuck_init(1);
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	setb	_nunchuck_init_PARM_1
	push	ar2
	push	ar3
	lcall	_nunchuck_init
	pop	ar3
	pop	ar2
L040002?:
<<<<<<< HEAD
;	Transmitter_src.c:141: waitms(100);
=======
;	Transmitter_src.c:139: waitms(100);
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	dptr,#0x0064
	push	ar2
	push	ar3
	lcall	_waitms
	pop	ar3
	pop	ar2
<<<<<<< HEAD
;	Transmitter_src.c:143: if(offset_flag && mode == 1){
	jnb	_offset_flag,L040004?
	mov	a,#0x01
	cjne	a,_mode,L040004?
;	Transmitter_src.c:144: nunchuck_getdata(buffer);
	mov	dptr,#_main_buffer_1_177
	mov	b,#0x40
	lcall	_nunchuck_getdata
;	Transmitter_src.c:145: off_x=(int)buffer[0]-128;
=======
;	Transmitter_src.c:141: if(offset_flag && mode == 1){
	jnb	_offset_flag,L040004?
	mov	a,#0x01
	cjne	a,_mode,L040004?
;	Transmitter_src.c:142: nunchuck_getdata(buffer);
	mov	dptr,#_main_buffer_1_177
	mov	b,#0x40
	lcall	_nunchuck_getdata
;	Transmitter_src.c:143: off_x=(int)buffer[0]-128;
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	r6,_main_buffer_1_177
	mov	r7,#0x00
	mov	a,r6
	add	a,#0x80
	mov	r2,a
	mov	a,r7
	addc	a,#0xff
	mov	r3,a
<<<<<<< HEAD
;	Transmitter_src.c:146: off_y=(int)buffer[1]-128;
=======
;	Transmitter_src.c:144: off_y=(int)buffer[1]-128;
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	r6,(_main_buffer_1_177 + 0x0001)
	mov	r7,#0x00
	mov	a,r6
	add	a,#0x80
	mov	_main_off_y_1_177,a
	mov	a,r7
	addc	a,#0xff
	mov	(_main_off_y_1_177 + 1),a
<<<<<<< HEAD
;	Transmitter_src.c:147: printf("Offset_X:%4d Offset_Y:%4d\n\n", off_x, off_y);
=======
;	Transmitter_src.c:145: printf("Offset_X:%4d Offset_Y:%4d\n\n", off_x, off_y);
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	push	ar2
	push	ar3
	push	_main_off_y_1_177
	push	(_main_off_y_1_177 + 1)
	push	ar2
	push	ar3
<<<<<<< HEAD
	mov	a,#__str_11
	push	acc
	mov	a,#(__str_11 >> 8)
=======
	mov	a,#__str_12
	push	acc
	mov	a,#(__str_12 >> 8)
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	mov	a,sp
	add	a,#0xf9
	mov	sp,a
	pop	ar3
	pop	ar2
<<<<<<< HEAD
;	Transmitter_src.c:148: offset_flag=0; //clear offset flag, so not to re-get offset. 
	clr	_offset_flag
L040004?:
;	Transmitter_src.c:151: waitms(500);
=======
;	Transmitter_src.c:146: offset_flag=0; //clear offset flag, so not to re-get offset. 
	clr	_offset_flag
L040004?:
;	Transmitter_src.c:149: waitms(500);
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	dptr,#0x01F4
	push	ar2
	push	ar3
	lcall	_waitms
<<<<<<< HEAD
;	Transmitter_src.c:153: printf("LAB 6 Microcontroller\r\nWith extra features\r\n\n");
	mov	a,#__str_12
	push	acc
	mov	a,#(__str_12 >> 8)
=======
;	Transmitter_src.c:151: printf("LAB 6 Microcontroller\r\nWith extra features\r\n\n");
	mov	a,#__str_13
	push	acc
	mov	a,#(__str_13 >> 8)
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
<<<<<<< HEAD
;	Transmitter_src.c:154: waitms(500);     
	mov	dptr,#0x01F4
	lcall	_waitms
;	Transmitter_src.c:155: LCDprint("Ready", 1, 1);
	mov	_LCDprint_PARM_2,#0x01
	setb	_LCDprint_PARM_3
	mov	dptr,#__str_13
=======
;	Transmitter_src.c:152: waitms(500);     
	mov	dptr,#0x01F4
	lcall	_waitms
;	Transmitter_src.c:153: LCDprint("Ready", 1, 1);
	mov	_LCDprint_PARM_2,#0x01
	setb	_LCDprint_PARM_3
	mov	dptr,#__str_14
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	b,#0x80
	lcall	_LCDprint
	pop	ar3
	pop	ar2
<<<<<<< HEAD
;	Transmitter_src.c:160: while(1) {
L040017?:
;	Transmitter_src.c:164: if (mode == 0) {
	mov	a,_mode
	jnz	L040014?
;	Transmitter_src.c:165: printf("Enter command: \r\n");
	push	ar2
	push	ar3
	mov	a,#__str_14
	push	acc
	mov	a,#(__str_14 >> 8)
=======
;	Transmitter_src.c:158: while(1) {
L040015?:
;	Transmitter_src.c:162: if (mode == 0) {
	mov	a,_mode
	jnz	L040012?
;	Transmitter_src.c:163: printf("Enter command: \r\n");
	push	ar2
	push	ar3
	mov	a,#__str_15
	push	acc
	mov	a,#(__str_15 >> 8)
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
<<<<<<< HEAD
;	Transmitter_src.c:166: getsn(buffer, CHARS_PER_LINE);
=======
;	Transmitter_src.c:164: getsn(buffer, CHARS_PER_LINE);
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	_getsn_PARM_2,#0x10
	clr	a
	mov	(_getsn_PARM_2 + 1),a
	mov	dptr,#_main_buffer_1_177
	mov	b,#0x40
	lcall	_getsn
<<<<<<< HEAD
;	Transmitter_src.c:167: getCommand(buffer); //after use, is clear, only used within functions
=======
;	Transmitter_src.c:165: getCommand(buffer); //after use, is clear, only used within functions
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	dptr,#_main_buffer_1_177
	mov	b,#0x40
	lcall	_getCommand
	pop	ar3
	pop	ar2
<<<<<<< HEAD
	sjmp	L040017?
L040014?:
;	Transmitter_src.c:169: } else if ((mode == 1)) {
	mov	a,#0x01
	cjne	a,_mode,L040017?
;	Transmitter_src.c:170: Z_but=read_nunchuck(&direction, &speed, buffer, off_x, off_y);
=======
	sjmp	L040015?
L040012?:
;	Transmitter_src.c:167: } else if (mode == 1) {
	mov	a,#0x01
	cjne	a,_mode,L040015?
;	Transmitter_src.c:168: read_nunchuck(&direction, &speed, buffer, off_x, off_y);
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	_read_nunchuck_PARM_2,#_main_speed_1_177
	mov	(_read_nunchuck_PARM_2 + 1),#0x00
	mov	(_read_nunchuck_PARM_2 + 2),#0x40
	mov	_read_nunchuck_PARM_3,#_main_buffer_1_177
	mov	(_read_nunchuck_PARM_3 + 1),#0x00
	mov	(_read_nunchuck_PARM_3 + 2),#0x40
	mov	_read_nunchuck_PARM_4,r2
	mov	(_read_nunchuck_PARM_4 + 1),r3
	mov	_read_nunchuck_PARM_5,_main_off_y_1_177
	mov	(_read_nunchuck_PARM_5 + 1),(_main_off_y_1_177 + 1)
	mov	dptr,#_main_direction_1_177
	mov	b,#0x40
	push	ar2
	push	ar3
	lcall	_read_nunchuck
<<<<<<< HEAD
	mov	_Z_but,c
;	Transmitter_src.c:172: printf("Z_but: %i", Z_but);
	mov	c,_Z_but
	clr	a
	rlc	a
	mov	r6,a
	mov	r7,#0x00
	push	ar6
	push	ar7
	mov	a,#__str_15
	push	acc
	mov	a,#(__str_15 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	mov	a,sp
	add	a,#0xfb
	mov	sp,a
	pop	ar3
	pop	ar2
;	Transmitter_src.c:174: if(Z_but==0){ 
	jb	_Z_but,L040010?
;	Transmitter_src.c:175: if(speedbit){
	jnb	_speedbit,L040007?
;	Transmitter_src.c:176: sendCommand(SPEED_OP, speed);
=======
	pop	ar3
	pop	ar2
;	Transmitter_src.c:170: if(speedbit){
	jnb	_speedbit,L040007?
;	Transmitter_src.c:171: sendCommand(SPEED_OP, speed);
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	_sendCommand_PARM_2,_main_speed_1_177
	mov	dpl,#0x00
	push	ar2
	push	ar3
	lcall	_sendCommand
<<<<<<< HEAD
;	Transmitter_src.c:177: printf("yesssss\n\n");
	mov	a,#__str_16
	push	acc
	mov	a,#(__str_16 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
	pop	ar3
	pop	ar2
;	Transmitter_src.c:178: speedbit=0;
	clr	_speedbit
	sjmp	L040010?
L040007?:
;	Transmitter_src.c:181: printf("dirrrrrrrrr: %i \n\n", direction);
	mov	a,_main_direction_1_177
	mov	r6,a
	rlc	a
	subb	a,acc
	mov	r7,a
	push	ar2
	push	ar3
	push	ar6
	push	ar7
	mov	a,#__str_17
	push	acc
	mov	a,#(__str_17 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	mov	a,sp
	add	a,#0xfb
	mov	sp,a
;	Transmitter_src.c:182: sendCommand(DIRECTION_OP, direction);
	mov	_sendCommand_PARM_2,_main_direction_1_177
	mov	dpl,#0x01
	lcall	_sendCommand
	pop	ar3
	pop	ar2
;	Transmitter_src.c:183: speedbit=1;
	setb	_speedbit
L040010?:
;	Transmitter_src.c:189: printf("direction: %d   speed: %d \n", direction, speed);
=======
	pop	ar3
	pop	ar2
;	Transmitter_src.c:172: speedbit=0;
	clr	_speedbit
	sjmp	L040008?
L040007?:
;	Transmitter_src.c:174: sendCommand(DIRECTION_OP, direction);
	mov	_sendCommand_PARM_2,_main_direction_1_177
	mov	dpl,#0x01
	push	ar2
	push	ar3
	lcall	_sendCommand
	pop	ar3
	pop	ar2
;	Transmitter_src.c:175: speedbit=1;
	setb	_speedbit
L040008?:
;	Transmitter_src.c:179: printf("direction: %c   speed: %c \n", direction, speed);
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	mov	a,_main_speed_1_177
	mov	r6,a
	rlc	a
	subb	a,acc
	mov	r7,a
	mov	a,_main_direction_1_177
	mov	r4,a
	rlc	a
	subb	a,acc
	mov	r5,a
	push	ar2
	push	ar3
	push	ar6
	push	ar7
	push	ar4
	push	ar5
<<<<<<< HEAD
	mov	a,#__str_18
	push	acc
	mov	a,#(__str_18 >> 8)
=======
	mov	a,#__str_16
	push	acc
	mov	a,#(__str_16 >> 8)
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	mov	a,sp
	add	a,#0xf9
	mov	sp,a
	pop	ar3
	pop	ar2
<<<<<<< HEAD
	ljmp	L040017?
=======
	ljmp	L040015?
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	rseg R_CSEG

	rseg R_XINIT

	rseg R_CONST
__str_0:
	db 'Sent: %d'
	db 0x0D
	db 0x0A
	db 0x00
__str_1:
	db 'c err'
	db 0x0D
	db 0x0A
	db 0x00
__str_2:
	db '%*s %c %c'
	db 0x00
__str_3:
	db '%*s %u'
	db 0x00
__str_4:
	db 'Set timer4 freq to: %d'
	db 0x0D
	db 0x0A
	db 0x00
__str_5:
	db 'Set timer4 reload to: %d'
	db 0x0D
	db 0x0A
	db 0x00
__str_6:
	db 'Help Menu'
	db 0x0D
	db 0x0A
	db 'List of Commands: '
	db 0x0D
	db 0x0A
	db '-cw [duty value]'
	db 0x0D
	db 0x0A
	db '-ccw [duty '
	db 'value]'
	db 0x0D
	db 0x0A
	db '-f [freq value]'
	db 0x0D
	db 0x0A
	db '-r [reload value]'
	db 0x0D
	db 0x0A
	db '-o'
	db 0x0D
	db 0x0A
	db '-s'
	db 0x0D
	db 0x0A
	db '-i'
	db 0x0D
	db 0x0A
	db 0x0A
	db 0x00
__str_7:
	db 'Reload: %u, Freq: %d '
	db 0x0D
	db 0x0A
	db 0x00
__str_8:
	db 0x22
	db '%s'
	db 0x22
	db ' invalid command'
	db 0x0D
	db 0x0A
	db 0x00
__str_9:
	db 'Not Valid input'
	db 0x0D
	db 0x0A
	db 0x00
__str_10:
	db 'Extension type: %02x  %02x  %02x  %02x  %02x  %02x'
	db 0x0A
	db 0x00
__str_11:
<<<<<<< HEAD
=======
	db 'Buttons(Z:%c, C:%c) Joystick(%4d, %4d)'
	db 0x0D
	db 0x00
__str_12:
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	db 'Offset_X:%4d Offset_Y:%4d'
	db 0x0A
	db 0x0A
	db 0x00
<<<<<<< HEAD
__str_12:
=======
__str_13:
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	db 'LAB 6 Microcontroller'
	db 0x0D
	db 0x0A
	db 'With extra features'
	db 0x0D
	db 0x0A
	db 0x0A
	db 0x00
<<<<<<< HEAD
__str_13:
	db 'Ready'
	db 0x00
__str_14:
=======
__str_14:
	db 'Ready'
	db 0x00
__str_15:
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	db 'Enter command: '
	db 0x0D
	db 0x0A
	db 0x00
<<<<<<< HEAD
__str_15:
	db 'Z_but: %i'
	db 0x00
__str_16:
	db 'yesssss'
	db 0x0A
	db 0x0A
	db 0x00
__str_17:
	db 'dirrrrrrrrr: %i '
	db 0x0A
	db 0x0A
	db 0x00
__str_18:
	db 'direction: %d   speed: %d '
=======
__str_16:
	db 'direction: %c   speed: %c '
>>>>>>> afe2bea48aa7feb8ae96f661afe768b5c52ada3c
	db 0x0A
	db 0x00

	CSEG

end
