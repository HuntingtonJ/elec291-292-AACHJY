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
MAX_TEMP	  EQU 250
TIMEOUT_TIME  EQU 60
BAUD equ 115200
BRG_VAL equ (0x100-(CLK/(16*BAUD)))
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

;Edge triggered keyboard interrupt vector
org 0x003B
	ljmp Start_stop_ISR

; These ’EQU’ must match the wiring between the microcontroller and ADC
SOUND_OUT   EQU P3.7
CE_ADC      EQU P2.4
MY_MOSI     EQU P2.5
MY_MISO     EQU P2.6
MY_SCLK     EQU P2.7
UP_BUTTON	EQU P0.1
DOWN_BUTTON EQU P0.2
SELECT_BUTTON EQU P0.3

MASTER_START_STOP equ p1.0


DSEG at 0x30
Count1ms:      ds 2 ; Used to determine when half second has passed
Result: ds 2
x:      ds 4
y:      ds 4
bcd:    ds 5
soaktime: ds 2
soaktemp: ds 2
reflowtime: ds 2
reflowtemp: ds 2
soaktemp3digit: ds 2
reflow_state: ds 1
pwm: ds 1
temp: ds 1
sec: ds 1 		; seconds variable for reflow FSM (to be incremented every second)
cooled_temp: ds 1

BSEG
mf: dbit 1

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

Ramp_to_Soak: 		db         'Preheat', 0
Soak: 				db		   'Soak   ', 0
Ramp_to_Peak: 		db 		   'Ramp2pk', 0
Reflow: 			db 		   'Reflow ', 0
Cooling: 			db 		   'Cooling', 0
secondsss: 			db		   's'		, 0



$NOLIST
$include(LCD_4bit.inc) ; A library of LCD related functions and utility macros
$LIST

$NOLIST
$include(menu_code.inc) ; A library of LCD related functions and utility macros
$LIST

$NOLIST
$include(lab3HJ.asm) ; A copy of Huntington's Lab3 to be used in polling, converting and pushing temp data to SPI
$LIST

;----------------;
; Routine to initialize 
; Start/stop buttons ISR; 
;-----------------;

Start_stop_Init: 
	setb EKBD		; Enables the keyboard interrupt. 
	mov KBMOD, #3	; enable edge triggered for P0.0 and P0.1
	mov KBLS, #0 	; watch for negative edge (0->1)
	mov KBE, #3	; enable interrupt for p0.0 and p0.1
	mov KBF, #3; interrupt active, must clear at start of ISR and setb at end. 

	ret

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

Start_stop_ISR: 

			; In order to make the start button work effectively, we need to update where the routine returns to in main when it gets updated. This could involve either changing the link register (which is????) or checking if a flag has been pressed upon returning to main. 

	mov KBF, #0		; masks interrupt 
	push acc

	button_jmp(MASTER_STOP, STOP_ROUTINE)	; if master stop has been pressed, change to state 5
	button_jmp(MASTER_START, START_ROUTINE) ; if master start has been pressed, change to state 1
START_ROUTINE: 

; We should add some code here that checks if appropriate values have been loaded into the variable locations (ie the temp isn't greater than 255)

	mov a, reflow_state
	cjne a, #0, End_master_ISR
	mov reflow_state, #1
	sjmp End_master_ISR


STOP_ROUTINE: 
	mov reflow_state, #5	
			; any other things we want to do, ie, statements we want to make 
	Set_cursor(1,1)
	Send_Constant_String(#Abort_string)
	Set_cursor(2,1)
	Send_Constant_String(#Waiting_to_cool)
	sjmp End_master_ISR
End_master_ISR: 
	mov KBF, #3		; enables interrupt
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

MainProgram:
    mov SP, #7FH ; Set the stack pointer to the begining of idata
    lcall Start_stop_Init
    lcall Timer0_Init
    lcall Timer2_Init
    ; In case you decide to use the pins of P0, configure the port in bidirectional mode:
    mov P0M0, #0
    mov P0M1, #0

    setb EA   ; Enable Global interrupts
    
    lcall InitSerialPort
    mov DPTR, #Hello_World
    lcall SendString
    
forever:
	lcall GET_TEMP_DATA	 ;This is the lab3 derivative loop that grabs the data from the thermocouple, 
	ljmp reflow_state_machine 	; go do some stuff in the state_machine
    ljmp forever ; This is equivalent to 'forever: sjmp forever'

    
END