$MODLP51

; There is a couple of typos in MODLP51 in the definition of the timer 0/1 reload
; special function registers (SFRs), so:

TIMER0_RELOAD_L DATA 0xf2
TIMER1_RELOAD_L DATA 0xf3
TIMER0_RELOAD_H DATA 0xf4
TIMER1_RELOAD_H DATA 0xf5

CLK           EQU 22118400 ; Microcontroller system crystal frequency in Hz
TIMER0_RATE   EQU 4096     ; 2048Hz squarewave (peak amplitude of CEM-1203 speaker)
TIMER0_RELOAD EQU ((65536-(CLK/TIMER0_RATE)))
TIMER2_RATE   EQU 1000     ; 1000Hz, for a timer tick of 1ms
TIMER2_RELOAD EQU ((65536-(CLK/TIMER2_RATE)))
MILLISECOND_WAIT equ 200		; how many milliseconds between temp samples

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

BAUD equ 115200
BRG_VAL equ (0x100-(CLK/(16*BAUD)))

; These ’EQU’ must match the wiring between the microcontroller and ADC
SOUND_OUT   EQU P3.7
CE_ADC EQU P2.0
MY_MOSI EQU P2.1
MY_MISO EQU P2.2
MY_SCLK EQU P2.3

DSEG at 0x30
Count1ms:      ds 2 ; Used to determine when half second has passed
Result:        ds 2
Result_Thermo: ds 2
seconds: 	ds 1
x:             ds 4
y:             ds 4
bcd:           ds 5

BSEG
mf: dbit 1
one_second_flag: dbit 1 

$NOLIST
$include(math32.inc)   ; A library of 32bit math functions
$LIST

CSEG
LCD_RS equ P1.1
LCD_RW equ P1.2
LCD_E  equ P1.3
LCD_D4 equ P3.2
LCD_D5 equ P3.3
LCD_D6 equ P3.4
LCD_D7 equ P3.5

$NOLIST
$include(LCD_4bit.inc) ; A library of LCD related functions and utility macros
$LIST

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
    setb TR0  ; Start timer 0
	ret

;---------------------------------;
; ISR for timer 0.  Set to execute;
; every 1/4096Hz to generate a    ;
; 2048 Hz square wave at pin P3.7 ;
;---------------------------------;
Timer0_ISR:
	;clr TF0  ; According to the data sheet this is done for us already.
	sjmp no_beep
beep_on:
	;cpl SOUND_OUT ; Connect speaker to P3.7!
no_beep:
	reti
	
	

Send_BCD mac
	push ar0
	mov r0, %0
	lcall ?Send_BCD
	mov a, #'\r'
    lcall putchar
    mov a, #'\n'
    lcall putchar
	pop ar0
endmac


	
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
	; Enable the timer and interrupts
    setb ET2  ; Enable timer 2 interrupt
    setb TR2  ; Enable timer 2
	ret

;---------------------------------;
; ISR for timer 2                 ;
;---------------------------------;
Timer2_ISR:
	clr TF2  ; Timer 2 doesn't clear TF2 automatically. Do it in ISR
	cpl P3.6 ; To check the interrupt rate with oscilloscope. It must be precisely a 1 ms pulse.
	
	; The two registers used in the ISR must be saved in the stack
	push acc
	push psw
	
	; Increment the 16-bit one mili second counter
			;	inc Count1ms+0    ; Increment the low 8-bits first
				;mov a, Count1ms+0
			;	cjne a, #10h, Timer2_ISR_done
			;	mov Count1ms+0, #0h
	inc Count1ms+0    ; Increment the low 8-bits first
	mov a, Count1ms+0 ; If the low 8-bits overflow, then increment high 8-bits
	jnz Inc_Done
	inc Count1ms+1
	
				Send_BCD(bcd)
	Inc_Done:
	; Check if a second has passed

	mov a, Count1ms+0
	cjne a, #low(MILLISECOND_WAIT), Timer2_ISR_done ; Warning: this instruction changes the carry flag!
	mov a, Count1ms+1
	cjne a, #high(MILLISECOND_WAIT), Timer2_ISR_done
	
	; 1000 milliseconds have passed.  Set a flag so the main program knows
	setb one_second_flag ; Let the main program know one second had passed
	cpl TR0 ; Enable/disable timer/counter 0. This line creates a beep-silence-beep-silence sound.
	; Reset to zero the milli-seconds counter, it is a 16-bit variable
	clr a
	mov Count1ms+0, a
	mov Count1ms+1, a
	; Increment the BCD counter
	mov a, seconds
	add a, #0x01
	da a ; Decimal adjust instruction.  Check datasheet for more details!
	mov seconds, a
	
	
Timer2_ISR_done:
	pop psw
	pop acc
	reti

; Configure the serial port and baud rate
InitSerialPort:
    ; Since the reset button bounces, we need to wait a bit before
    ; sending messages, otherwise we risk displaying gibberish!
    mov R1, #222
    mov R0, #166
    djnz R0, $   ; 3 cycles->3*45.21123ns*166=22.51519us
    djnz R1, $-4 ; 22.51519us*222=4.998ms
    ; Now we can proceed with the configuration
	orl	PCON,#0x80
	mov	SCON,#0x52
	mov	BDRCON,#0x00
	mov	BRL,#BRG_VAL
	mov	BDRCON,#0x1E ; BDRCON=BRR|TBCK|RBCK|SPD;
    ret

; Send a character using the serial port
putchar:
    jnb TI, putchar
    clr TI
    mov SBUF, a
    ret

; Send a constant-zero-terminated string using the serial port
SendString:
    clr A
    movc A, @A+DPTR
    jz SendStringDone
    lcall putchar
    inc DPTR
    sjmp SendString
SendStringDone:
    ret
    
INIT_SPI:
	setb MY_MISO ; Make MISO an input pin
 	clr MY_SCLK ; For mode (0,0) SCLK is zero
 	ret

DO_SPI_G:
 	push acc
 	mov R1, #0 ; Received byte stored in R1
 	mov R2, #8 ; Loop counter (8-bits)
DO_SPI_G_LOOP:
 	mov a, R0 ; Byte to write is in R0
 	rlc a ; Carry flag has bit to write
 	mov R0, a
 	mov MY_MOSI, c
 	setb MY_SCLK ; Transmit
 	mov c, MY_MISO ; Read received bit
 	mov a, R1 ; Save received bit in R1
 	rlc a
 	mov R1, a
 	clr MY_SCLK
 	djnz R2, DO_SPI_G_LOOP
 	pop acc
 	ret
 
Hello_World:
    DB  'Hello, World!', '\r', '\n', 0
    
Delay:
	mov R1, #222
    mov R0, #166
    djnz R0, $   ; 3 cycles->3*45.21123ns*166=22.51519us
    djnz R1, $-4 ; 22.51519us*222=4.998ms
    reti
    
Left_blank mac
	mov a, %0
	anl a, #0xf0
	swap a
	jz Left_blank_%M_a
	ljmp %1
Left_blank_%M_a:
	Display_char(#' ')
	mov a, %0
	anl a, #0x0f
	jz Left_blank_%M_b
	ljmp %1
Left_blank_%M_b:
	Display_char(#' ')
endmac
   
; Sends 10-digit BCD number in bcd to the LCD 
Display_10_digit_BCD:
	Set_Cursor(2, 7)
	Display_BCD(bcd+4)
	Display_BCD(bcd+3)
	Display_BCD(bcd+2)
	Display_BCD(bcd+1)
	Display_BCD(bcd+0)
	; Replace all the zeros to the left with blanks
	Set_Cursor(2, 7)
	Left_blank(bcd+4, skip_blank)
	Left_blank(bcd+3, skip_blank)
	Left_blank(bcd+2, skip_blank)
	Left_blank(bcd+1, skip_blank)
	mov a, bcd+0
	anl a, #0f0h
	swap a
	jnz skip_blank
	Display_char(#' ')
skip_blank:
	ret
	
Display_10_digit_BCD_2:
	Set_Cursor(1, 7)
	Display_BCD(bcd+4)
	Display_BCD(bcd+3)
	Display_BCD(bcd+2)
	Display_BCD(bcd+1)
	Display_BCD(bcd+0)
	; Replace all the zeros to the left with blanks
	Set_Cursor(1, 7)
	Left_blank(bcd+4, skip_blank_2)
	Left_blank(bcd+3, skip_blank_2)
	Left_blank(bcd+2, skip_blank_2)
	Left_blank(bcd+1, skip_blank_2)
	mov a, bcd+0
	anl a, #0f0h
	swap a
	jnz skip_blank_2
	Display_char(#' ')
skip_blank_2:
	ret

	; Sends 10-digit BCD number in BCD to the SPI
Send_10_digit_BCD:
	Send_BCD(bcd+4)
	Send_BCD(bcd+3)
	Send_BCD(bcd+2)
	Send_BCD(bcd+1)
	Send_BCD(bcd+0)
	ret

?Send_BCD:
	push acc
	; Write most significant digit
	mov a, r0
	swap a
	anl a, #0fh
	orl a, #30h
	lcall putchar
	; write least significant digit
	mov a, r0
	anl a, #0fh
	orl a, #30h
	lcall putchar
	pop acc
	ret

GET_ADC_TEMP:
    clr CE_ADC         ; selects 
    mov R0, #00000001B ; Start bit: 1
    lcall DO_SPI_G
    
    mov R0, #10000000B ; Read channel 0
    lcall DO_SPI_G
    mov a, R1
    anl a, #00000011B
    mov Result+1, a    ; Save high result
    
    mov R0, #55H
    lcall DO_SPI_G
    mov Result, R1     ; Save low result
    
    setb CE_ADC        ; deselects
    
    ;V_OUT = ADC_voltage*4.096V/1023
    ;ADC_voltage*4096 = A
    mov x+0, Result
    mov x+1, Result+1
    mov x+2, #0
    mov x+3, #0
    
 ret

 GET_THERMO_TEMP:
    clr CE_ADC         ; selects 
    mov R0, #00000001B ; Start bit: 1
    lcall DO_SPI_G
    
    mov R0, #10010000B ; Read channel 1
    lcall DO_SPI_G
    mov a, R1
    anl a, #00000011B
    mov Result_Thermo+1, a    ; Save high result
    
    mov R0, #55H
    lcall DO_SPI_G
    mov Result_Thermo, R1     ; Save low result
    setb CE_ADC        ; deselects
    
    ;V_OUT = ADC_voltage*4.096V/1023
    ;ADC_voltage*4096 = A
    mov x+0, Result_Thermo
    mov x+1, Result_Thermo+1
    mov x+2, #0
    mov x+3, #0
  ret

;____________________________________
 ;*************************************

; This is the code that converts the amplified voltage from the the k-type thermocouple 
; to temperature data for use. 
; Current Parameters: 
;		Op-amp gain: ~200
;		Thermocouple conversion: 41 uV/celcius
; 		Reference Voltage: 4.096 
; inputs
;*************************************		
;------------------------------------- 		

Voltage_to_temp_LM355: 
		  	Load_y(4096)
		    lcall mul32 ;multiplies x *= y
		    
		    ;A/1023 = B
		    Load_y(1023)
		    lcall div32 ;divides x /= y
		    
		    ;B - 2730 = C
		    Load_y(2730);
		    lcall sub32
		    
		    ;B/10 = V_OUT
		    Load_y(10);
		    lcall div32 ;divides x /= y
		   	lcall hex2bcd
    	ret

  Voltage_to_temp_thermocouple: 

	;SPI_REF_VOLTAGE_mul100 equ 4081
	;THERMOCOUPLE_CONVERSION_div1000 equ 2475
	
	;
	; We are doing the conversion from V--> 10 bit Temp (deg C)
	; Start: Amplified Volts, Vin
	;
	; 		Vin*(1 deg C)* (V_REF)*    1    * 1
	;			 --------			    ---    ---  - ADC_RESULT
	; 			(41 uV )		   OP_AMP_GAIn  1023

	Load_y(4081); 4.081*1000=mV
	lcall mul32
	
	Load_y(1023)
	lcall div32   
	
	Load_y(247) ; 24.75*10
	lcall mul32
				;---------
	Load_y(2000) ; 200*10
	lcall div32
	
	Load_y(22)


	lcall add32
  	
   	lcall hex2bcd
   ret
  



MainProgram:
    mov SP, #7FH ; Set the stack pointer to the begining of idata
    
    ;lcall Timer0_Init
    lcall Timer2_Init
    ; In case you decide to use the pins of P0, configure the port in bidirectional mode:
    mov P0M0, #0
    mov P0M1, #0
    setb EA   ; Enable Global interrupts
    
    lcall InitSerialPort
    mov DPTR, #Hello_World
    lcall SendString
    
    lcall INIT_SPI
    lcall LCD_4BIT
  


GET_TEMP_DATA: 
	jnb one_second_flag, GET_TEMP_DATA
	clr one_second_flag ; We clear this flag in the main loop, but it is set in the ISR for timer 2
	
	;Gets, displays, and pushes ADC LM355 temp values
	lcall GET_ADC_TEMP
    lcall Voltage_to_temp_LM355
    lcall Display_10_digit_BCD
    
    ; Gets, displays, and pushes k-type thermocouple vlaues
	lcall GET_THERMO_TEMP
    lcall Voltage_to_temp_thermocouple
    lcall Send_10_digit_BCD
    lcall Display_10_digit_BCD_2
    
    ;lcall Delay
    ret
	


END