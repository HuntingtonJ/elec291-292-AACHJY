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

DUTY_0    EQU 0
DUTY_20   EQU 51   ;256 * 0.2
DUTY_50   EQU 128  ;256 * 0.5
DUTY_100  EQU 255

org 0x0000
   ljmp MainProgram

; External interrupt 0 vector (not used in this code)
org 0x0003
	reti

; Timer/Counter 0 overflow interrupt vector
org 0x000B
	reti

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
	reti
	
DSEG at 0x30
Count1ms:      ds 2 ; Used to determine when half second has passed
x:             ds 4
y:             ds 4
bcd:           ds 5

BSEG

CSEG
	
;---------------------------------;
; Routine to initialize the ISR   ;
; for timer 1                     ; 
;---------------------------------;
Timer1_Init:
	mov a, TMOD
	anl a, #00001111B
	orl a, #00010000B
	mov TMOD, a
	
	mov TH1, #DUTY_50             ;Current count value
	mov TL1, #255                 ;Linear Prescaling
	
	mov TIMER1_RELOAD_H, #DUTY_50 ;Duty cycle percentage
	mov TIMER1_RELOAD_L, #255     ;Frequency scaling/adjust f_out = f_sys/(256 * (256 - TL))
	
	mov a, TCONB ;load TCONB for PWM settings
	anl a, #00000000B
	orl a, #10000000B
	mov TCONB, a
	
	setb TR1
	reti
	
MainProgram:
    mov SP, #7FH ; Set the stack pointer to the begining of idata
    lcall Timer1_Init
    
forever:
	sjmp forever
END