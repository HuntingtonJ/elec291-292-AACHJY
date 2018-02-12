$MODLP51

; There is a couple of typos in MODLP51 in the definition of the timer 0/1 reload
; special function registers (SFRs), so:

TIMER0_RELOAD_L DATA 0xf2
TIMER1_RELOAD_L DATA 0xf3
TIMER0_RELOAD_H DATA 0xf4
TIMER1_RELOAD_H DATA 0xf5

CLK              EQU 22118400 ; Microcontroller system crystal frequency in Hz
TIMER0_RATE      EQU 4096     ; 2048Hz squarewave (peak amplitude of CEM-1203 speaker)
TIMER0_RELOAD    EQU ((65536-(CLK/TIMER0_RATE)))
TIMER2_RATE      EQU 1000     ; 1000Hz, for a timer tick of 1ms
TIMER2_RELOAD    EQU ((65536-(CLK/TIMER2_RATE)))
MAX_TEMP	     EQU 250
TIMEOUT_TIME     EQU 60
BAUD             EQU 115200
BRG_VAL          EQU (0x100-(CLK/(16*BAUD)))
MILLISECOND_WAIT EQU 200		; how many milliseconds between temp samples, needs to be a number evenly divisible into 1000
Seconds_coeff	 equ (1000/MILLISECOND_WAIT)

DUTY_0           EQU 0
DUTY_20          EQU 51   ;256 * 0.2
DUTY_50          EQU 128  ;256 * 0.5
DUTY_80          EQU 204  ;256 * 0.8
DUTY_100         EQU 255

org 0x0000
   ljmp MainProgram

; External interrupt 0 vector (not used in this code)
org 0x0003
	reti

; Timer/Counter 0 overflow interrupt vector
org 0x000B
	ljmp Timer0_ISR

; External interrupt 1 vector (not used in this code)
org 0x0013
	reti

; Timer/Counter 1 overflow interrupt vector (not used in this code)
org 0x001B
	reti

; Serial port receive/transmit interrupt vector (not used in this code)
org 0x0023 
	reti
	
; Timer/Counter 2 overflow interrupt vector
org 0x002B
	ljmp Timer2_ISR

;Edge triggered keyboard interrupt vector
org 0x003B
	reti

; These ’EQU’ must match the wiring between the microcontroller and ADC
SOUND_OUT     EQU P3.7
CE_ADC        EQU P2.0
MY_MOSI       EQU P2.1
MY_MISO       EQU P2.2
MY_SCLK       EQU P2.3

UP_BUTTON	  EQU P2.6 
DOWN_BUTTON   EQU P2.5
SELECT_BUTTON equ P2.4
BACK_BUTTON   EQU #11110000B
MASTER_START  EQU #10100000B 
MASTER_STOP   EQU #10110000B

; For the 7-segment display
SEGA equ P0.3
SEGB equ P0.5
SEGC equ P0.7
SEGD equ P4.4
SEGE equ P4.5
SEGF equ P0.4
SEGG equ P0.6
SEGP equ P2.7
CA1  equ P0.1
CA2  equ P0.0
CA3  equ P0.2

; For the LCD
LCD_RS equ P1.1
LCD_RW equ P1.2
LCD_E  equ P1.3
LCD_D4 equ P3.2
LCD_D5 equ P3.3
LCD_D6 equ P3.4
LCD_D7 equ P3.6

; pins to be used on the MPC 3008
adc_zero 		equ #10000000B               ; LM355 temp sensor 
adc_one 		equ #10010000B               ; thermocouple
adc_two 		equ #10100000B               ;	start
adc_three 		equ #10110000B               ;	stop
adc_four		equ #11000000B               ;	
adc_five		equ #11010000B               ;	
adc_six			equ #11100000B               ; 
adc_seven		equ #11110000B				 ; back

DSEG at 0x30
Count1ms:       ds 2 ; Used to determine when half second has passed
Result:         ds 2 ; Temp from lm355
Result_Thermo:  ds 2 ; Temp from Thermocoupler
ADC_Result:     ds 2 ; Temp from ADC channel 2

BCD_temp:       ds 2 ; Used to diplay temp on the 7-segment display
seconds:        ds 1
polling_time: 	ds 1
x:              ds 4 ; Used in math32
y:              ds 4 ; Used in math32
bcd:            ds 5
soaktime:       ds 2
soaktemp:       ds 2
reflowtime:     ds 2
reflowtemp:     ds 2
soaktemp3digit: ds 2
reflow_state:   ds 1
pwm:            ds 1
temp:           ds 1
sec:            ds 1 ; seconds variable for reflow FSM (to be incremented every second)
cooled_temp:    ds 1
; 7-segment vars

disp1:          ds 1 ; Least significant digit
disp2:          ds 1
disp3:          ds 1 ; Most significant digit
seg_state:      ds 1 ; state of 7_seg fsm
display_scratch: ds 1
seconds_state4: ds 1
;sec_check: ds 1
;Beep Machine vars
beep_state:     ds 1
one_beep_count: ds 1


BSEG
mf: dbit 1
one_second_flag: dbit 1 
polling_flag: dbit 1
shortbeepflag: dbit 1
longbeepflag: dbit 1
sixbeepflag: dbit 1
state4_flag: dbit 1


CSEG
		;			 1234567890123456
Ramp_to_Soak: 	db 	 '         Preheat', 0
Soak: 			db   '         Soak   ', 0
Ramp_to_Peak: 	db 	 '         Ramp2pk', 0
Reflow: 		db 	 '         Reflow ', 0
Cooling: 		db 	 '         Cooling', 0
secondsss: 		db   's'		, 0
;                     1234567890123456    <- This helps determine the location of the counter
Welcome: 		  db 'Welcome!        ', 0
Choose_option: 	  db 'Select option   ', 0
Preset_menu_msg:  db 'Preset Profile  ', 0
Custom_menu_msg:  db 'Custom Profile  ', 0
Soak_temp:		  db 'Soak Temp       ', 0
Soak_time:		  db 'Soak Time       ', 0
Reflow_time: 	  db 'Reflow Time     ', 0
Reflow_temp:	  db 'Reflow Temp     ', 0
Pb_free_solder:	  db 'SAC305 solder   ', 0
Pb_solder:		  db 'Pb-solder paste ', 0
Pizza_msg0: 	  db 'Shhh! No pizza  ', 0
Pizza_msg1: 	  db 'allowed in here.', 0
Profile_loaded:   db 'profile loaded  ', 0
Is_ready: 		  db 'System Ready    ', 0
Press_start: 	  db 'Press Start     ', 0
Set_Value:		  db 'xx              ', 0
Clear_Row:		  db '                ', 0
PRESETMENUMSG:	  db 'AT PRESET MENU  ', 0
CUSTOMMENUMSG:	  db 'AT CUSTOM MENU  ', 0
Are_you_sure:  	  db 'Are you sure?   ', 0
Error_msg1: 	  db 'Error, profiles ', 0
Error_msg2:       db 'not loaded      ', 0
Abort_string: 	  db 'Process aborted ', 0
Waiting_to_cool:  db 'Wait to cool    ', 0
ISR_is_running:   db 'ISR is running  ', 0
abort_msg: 		  db 'Reflow Aborted! ', 0

State_0: db 'State 0', 0
State_1: db 'State 1', 0

HEX_7SEG: DB 0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90


$NOLIST
$include(LCD_4bit.inc) ; A library of LCD related functions and utility macros
$LIST

$NOLIST
$include(math32.inc)   ; A library of 32bit math functions
$LIST

$NOLIST
$include(menu_code_a1.asm) ; A library of LCD related functions and utility macros
$LIST

$NOLIST
$include(get_temp.asm) ; A copy of Huntington's Lab3 to be used in polling, converting and pushing temp data to SPI
$LIST

$NOLIST
$include(reflow_fsm_a1.asm) ; A copy of Huntington's Lab3 to be used in polling, converting and pushing temp data to SPI
$LIST

$NOLIST
$include(7_segment.asm) ; A library of 7 segment displays related functions and utility macros
$LIST

$NOLIST
$include(beep_sm.asm) ; A library of 7 segment displays related functions and utility macros
$LIST
;----------------------------------------MACRO LOCATION----------------------------------------------




;---------------------------------;
; Routine to initialize the ISR   ;
; for timer 0                     ;
;---------------------------------;
Timer0_Init:
	mov a, TMOD
	anl a, #0xf0 ; Clear the bits for timer 0
	orl a, #0x01 ; Configure timer 0 as 16-timer
	mov TMOD, a
	mov TH0, #high(TIMER0_RELOAD)
	mov TL0, #low(TIMER0_RELOAD)
	; Set autoreload value
	mov TIMER0_RELOAD_H, #high(TIMER0_RELOAD)
	mov TIMER0_RELOAD_L, #low(TIMER0_RELOAD)
	; Enable the timer and interrupts
    setb ET0  ; Enable timer 0 interrupt
	;setb TR0  ; Start timer 0
	ret

;---------------------------------;
; ISR for timer 0.  Set to execute;
; every 1/4096Hz to generate a    ;
; 2048 Hz square wave at pin P3.7 ;
;---------------------------------;
Timer0_ISR:
	;clr TF0  ; According to the data sheet this is done for us already.
	;jb sho
	
	
	
	;sjmp no_beep
;beep_on:
	cpl SOUND_OUT ; Connect speaker to P3.7!
;no_beep:
	reti
	
;---------------------------------;
; Routine to initialize the ISR   ;
; for timer 1 in PWM mode         ;
;---------------------------------;

Timer1_Init:
	mov a, TMOD
	anl a, #00001111B       ;Clears timer 1 settings but keeps timer 0 settings
	orl a, #00010000B       ;Gate = 0, TC1 = 0, mode = 01 (mode 1)
	mov TMOD, a
	
	mov a, TCONB            ;load TCONB for PWM settings
	anl a, #00000000B       ;clear TCONB
	orl a, #10000000B       ;Set PWM1 = 1
	mov TCONB, a
	
	mov TH1, #0             ;Current count value
	mov TL1, #0             ;Linear Prescaling
	
	mov TIMER1_RELOAD_H, #DUTY_0 ;Duty cycle percentage. Replace this value to change the duty cycle
	mov TIMER1_RELOAD_L, #0      ;Frequency scaling/adjust f_out = f_sys/(256 * (256 - TL))
	
	setb TR1
	reti

;---------------------------------;
; Routine to initialize the ISR   ;
; for timer 2                     ;
;---------------------------------;
Timer2_Init:
	mov T2CON, #0 ; Stop timer/counter.  Autoreload mode.
	mov TH2, #high(TIMER2_RELOAD)
	mov TL2, #low(TIMER2_RELOAD)
	; Set the reload value
	mov RCAP2H, #high(TIMER2_RELOAD)
	mov RCAP2L, #low(TIMER2_RELOAD)
	; Init One millisecond interrupt counter.  It is a 16-bit variable made with two 8-bit parts
	clr a
	mov Count1ms+0, a
	mov Count1ms+1, a
	mov polling_time, a 	; a variable used to increment one second as well as 200 ms
	; Enable the timer and interrupts
    setb ET2  ; Enable timer 2 interrupt
    setb TR2  ; Enable timer 2
	ret

;---------------------------------;
; ISR for timer 2                 ;
;---------------------------------;
Timer2_ISR:
	clr TF2  ; Timer 2 doesn't clear TF2 automatically. Do it in ISR

	; The two registers used in the ISR must be saved in the stack
	push acc
	push psw
	lcall seg_state_machine
	; Increment the 16-bit one mili second counter
			;	inc Count1ms+0    ; Increment the low 8-bits first
				;mov a, Count1ms+0
			;	cjne a, #10h, Timer2_ISR_done
			;	mov Count1ms+0, #0h
	inc Count1ms+0    ; Increment the low 8-bits first
	mov a, Count1ms+0 ; If the low 8-bits overflow, then increment high 8-bits
	jnz Inc_Done
	inc Count1ms+1
	
	;Send_BCD(bcd)
	Inc_Done:
	; Check if a second has passed

	mov a, Count1ms+0
	cjne a, #low(MILLISECOND_WAIT), Timer2_ISR_done ; Warning: this instruction changes the carry flag!
	mov a, Count1ms+1
	cjne a, #high(MILLISECOND_WAIT), Timer2_ISR_done
	
	; 200 milliseconds have passed.  Set a flag so the main program knows

	setb polling_flag
	
	; Reset to zero the milli-seconds counter, it is a 16-bit variable
	clr a
	mov Count1ms+0, a
	mov Count1ms+1, a
	
	;Checks if 1 second has passed (by checking if Seconds_coeff*Millisecond_wait interrupts have occured)
	inc polling_time
	mov a, polling_time
	cjne a, #Seconds_coeff, Timer2_ISR_done 
	mov polling_time, #0x00
	setb one_second_flag
	; Increment the BCD seconds counter
	inc seconds
	;add a, #0x01
	;da a ; Decimal adjust instruction.  Check datasheet for more details!
	;mov seconds, a
	;jnb state4_flag, Timer2_ISR_done
	;mov a, seconds_state4
	;add a, #0x01
	;da a ; Decimal adjust instruction.  Check datasheet for more details!
;mov seconds_state4, a
	
Timer2_ISR_done:
	pop psw
	pop acc
	reti

MainProgram:
    mov SP, #7FH ; Set the stack pointer to the begining of idata

	lcall seg_state_init
    lcall Timer0_Init
	lcall Timer1_Init
    lcall Timer2_Init
	lcall beep_machine_init
	clr shortbeepflag
	clr longbeepflag
	clr sixbeepflag
	mov seconds, #0x00
	mov seconds_state4, #0x00
	mov reflow_state, #0x00
	mov cooled_temp, #60
    ; In case you decide to use the pins of P0, configure the port in bidirectional mode:
    mov P0M0, #0
    mov P0M1, #0
	
	mov AUXR, #00010001B ; Max memory.  P4.4 is a general purpose IO pin

    setb EA   ; Enable Global interrupts
    
	lcall InitSerialPort
	lcall INIT_SPI
    lcall LCD_4BIT
	
forever:
	lcall GET_TEMP_DATA	 ;This is the lab3 derivative loop that grabs the data from the thermocouple, 
	lcall beep_state_machine
	ljmp reflow_state_machine 	; go do some stuff in the state_machine
    sjmp forever ; This is equivalent to 'forever: sjmp forever'

    
END