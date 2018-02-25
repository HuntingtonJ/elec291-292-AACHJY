
$MODLP51

; There is a couple of typos in MODLP51 in the definition of the timer 0/1 reload
; special function registers (SFRs), so:

TIMER0_RELOAD_L DATA 0xf2
TIMER1_RELOAD_L DATA 0xf3
TIMER0_RELOAD_H DATA 0xf4
TIMER1_RELOAD_H DATA 0xf5

CKCON0 DATA 0x8f

CLK           EQU 22118400 ; Microcontroller system crystal frequency in Hz
TIMER0_RATE   EQU 4096     ; 2048Hz squarewave (peak amplitude of CEM-1203 speaker)
TIMER0_RELOAD EQU ((65536-(CLK/TIMER0_RATE)))
TIMER2_RATE   EQU 1000     ; 1000Hz, for a timer tick of 1ms
TIMER2_RELOAD EQU ((65536-(CLK/TIMER2_RATE)))

DUTY_0    EQU 0
DUTY_20   EQU 51   ;256 * 0.2
DUTY_50   EQU 128  ;256 * 0.5
DUTY_80   EQU 204  ;256 * 0.8
DUTY_100  EQU 255

bpm equ 160
ms_per_beat equ ((60000/bpm) / 2) ; for 1/8 notes

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
	ljmp Timer2_ISR

ON_OFF EQU P0.0
;   FREQ          TRH1(LIN)
; C 261.63hz         
; D 293.66hz
; E 329.63hz	
; F 349.23hz        8.59
; G 392.00hz       35.59
; A 440.00hz       59.63
; B 493.88hz       81.03
; C 523.25hz       90.87
; D 587.33hz      108.89
; E 659.25hz      124.94
; F 698.46hz      132.29
; G 783.99hz      146.21
; A 880.00hz      157.81
; B 987.77hz      168.53
; C 1046.50hz     173.43
; D 1174.66hz     182.44
; E 1318.51hz     190.47
; F 1396.91hz     194.15 
; G 1567.98hz     200.89
; A 1760.00hz     206.90
; B 1975.53hz     212.26
; C 2093.00hz     214.72
; D 2349.32hz     219.22
; E 2637.02hz     223.24
; F 2793.83hz     225.07
; G 3135.96hz     228.45
; A 3520.00hz     231.45
; B 3951.07hz     234.13
; C 4186.01hz     235.36
; D 4698.63hz     237.61
; E 5274.04hz     239.61
; F 5587.65hz	  240.53

midi_F0 equ 9   ; state 0
midi_G0 equ 36  ; state 1
midi_A0 equ 60  ; state 2
midi_B0 equ 81  ; state 3
midi_C1 equ 91  ; state 4
midi_D1 equ 109 ; state 5
midi_E1 equ 125 ; state 6
midi_F1 equ 132 ; state 7
midi_G1 equ 146 ; state 8
midi_A1 equ 158 ; state 9
midi_B1 equ 169 ; state 10
midi_C2 equ 173 ; state 11
midi_D2 equ 182 ; state 12
midi_E2 equ 190 ; state 13
midi_F2 equ 194 ; state 14
midi_G2 equ 201 ; state 15
midi_A2 equ 207 ; state 16
midi_B2 equ 212 ; state 17
midi_C3 equ 215 ; state 18
midi_D3 equ 219 ; state 19
midi_E3 equ 223 ; state 20
midi_F3 equ 225 ; state 21
midi_G3 equ 228 ; state 22
midi_A3 equ 231 ; state 23
midi_B3 equ 234 ; state 24
midi_C4 equ 235 ; state 25
midi_D4 equ 238 ; state 26
midi_E4 equ 240 ; state 27
midi_F4 equ 241 ; state 28

midi_D1S equ 117
midi_A1S equ 163
midi_D2S equ 187




	
DSEG at 0x30
Count1ms:      ds 2 ; Used to determine when half second has passed
x:             ds 4
y:             ds 4
bcd:           ds 5
;Oscillator
duty:          ds 1
;midi
freq_value:              ds 1
midi_note_state:         ds 1
musical_notes:           ds 31
seq_count:               ds 1
seq_size:                ds 1


BSEG
direction: dbit 1
mf: dbit 1
mute: dbit 1
midi_trigger: dbit 1

CSEG

; For the LCD
LCD_RS equ P1.1
LCD_RW equ P1.2
LCD_E  equ P1.3
LCD_D4 equ P3.2
LCD_D5 equ P3.3
LCD_D6 equ P3.4
LCD_D7 equ P3.6

;midi_seq: db 0x0bh, 0x0dh, 0x0bh, 0x0fh, 0x0bh, 0x0dh, 0x0bh, 0x0fh, 0x0ah, 0x0dh, 0x0ah, 0x0fh, 0x0ah, 0x0dh, 0x0ah, 0x13, 0x0ah, 0x0dh, 0x0ah, 0x0fh, 0x0ah, 0x0dh, 0x0ah, 0x0fh, 0x0ah, 0x0dh, 0x0ah, 0x0fh, 0x0ah, 0x0dh, 0x0ah, 0x13, 0
            ;            -             -             -             -             -             -             -            --     -      -             -             -             -             -             -             -            --
midi_seq: db 0x0bh, 0x04h, 0x0dh, 0x04h, 0x0fh, 0x04h, 0x11h, 0x04h, 0x0bh, 0x04h, 0x0dh, 0x04h, 0x0fh, 0x04h, 0x11h, 0x04h , 0x0ah, 0x03h, 0x0dh, 0x03h, 0x0fh, 0x03h, 0x11h, 0x03h, 0x0a h, 0x03h, 0x0dh, 0x03h, 0x0fh, 0x03h, 0x11h, 0x03h , 0
;midi_seq: db 0x07, 0x08, 0x05, 0x07, 0x06, 0x0c, 0x0f, 0x0f, 0x07, 0x0b, 0x0d

$NOLIST
$include(LCD_4bit.inc) ; A library of LCD related functions and utility macros
$LIST

$NOLIST
$include(math32.inc)   ; A library of 32bit math functions
$LIST
	
;---------------------------------;
; Routine to initialize the ISR   ;
; for timer 1                     ; 
;---------------------------------;
Timer1_Init:
	mov a, CKCON0
	anl a, #11111011B
	orl a, #00000100B ; TK1 = 1 to allow TPs + 1
	mov CKCON0, a
	
	mov a, CLKREG
	anl a, #00000000B
	orl a, #01010000B      ;TPS1 = 5
	mov CLKREG, a

	mov a, TMOD
	anl a, #00001111B       ;Clears timer 1 settings but keeps timer 0 settings
	orl a, #00010000B       ;Gate = 0, TC1 = 0, mode = 01 (mode 1)
	mov TMOD, a
	
	mov a, TCONB            ;load TCONB for PWM settings
	anl a, #00000000B       ;clear TCONB
	orl a, #10000000B       ;Set PWM1 = 1, PWM0 = 0, PRESC1 = 000, PRESC0 = 000
	mov TCONB, a
	
	mov TH1, #0             ;Current count value
	mov TL1, #0             ;Linear Prescaling
	
	mov a, #100
	mov duty, a
	mov TIMER1_RELOAD_H, a ;Duty cycle percentage. Replace this value to change the duty cycle
	mov a, freq_value
	mov TIMER1_RELOAD_L, a      ;Frequency scaling/adjust f_out = f_sys/(256 * (256 - TL))
	
	clr TR1
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

	inc Count1ms+0    ; Increment the low 8-bits first
	mov a, Count1ms+0 ; If the low 8-bits overflow, then increment high 8-bits
	jnz Inc_Done
	inc Count1ms+1
	
	Inc_Done:
	; Check if a second has passed

	mov a, Count1ms+0
	cjne a, #low(ms_per_beat), Timer2_ISR_done ; Warning: this instruction changes the carry flag!
	mov a, Count1ms+1
	cjne a, #high(ms_per_beat), Timer2_ISR_done
	mov Count1ms+0, #0
	mov Count1ms+1, #0
	
	lcall next_midi_note_state

Timer2_ISR_done:

	pop psw
	pop acc
	reti
	
Delay:
	mov R1, #222
    mov R0, #166
    djnz R0, $   ; 3 cycles->3*45.21123ns*166=22.51519us
    djnz R1, $-4 ; 22.51519us*222=4.998ms
    ret
    
next_midi_note_state: ;{
	mov dptr, #midi_seq
	
	mov a, seq_count
	movc a, @a+dptr
	mov midi_note_state, a
	
	mov a, seq_count
	add a, #1
	mov seq_count, a
	cjne a, seq_size, end_note_update
	mov seq_count, #0
end_note_update:
	
	setb midi_trigger
	
	ret
;}

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
Display_10_digit_BCD: ;{
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
;}
	
display_milli:
	mov x+0, Count1ms+0
	mov x+1, Count1ms+1
	mov x+2, #0
	mov x+3, #0
	
	lcall hex2bcd
	lcall Display_10_digit_BCD
	ret
	
display_state:
	mov x+0, midi_note_state+0
	mov X+1, #0
	mov x+2, #0
	mov x+3, #0
	
	lcall hex2bcd
	lcall Display_10_digit_BCD
	ret
	
load_midi_notes:
	mov musical_notes+0, #midi_F0  ;0x00
	mov musical_notes+1, #midi_G0  ;0x01
	mov musical_notes+2, #midi_A0  ;0x02
	mov musical_notes+3, #midi_B0  ;0x03 
	mov musical_notes+4, #midi_C1  ;0x04 
	mov musical_notes+5, #midi_D1  ;0x05 
	mov musical_notes+6, #midi_E1  ;0x06
	mov musical_notes+7, #midi_F1  ;0x07 
	mov musical_notes+8, #midi_G1  ;0x08
	mov musical_notes+9, #midi_A1  ;0x09
	mov musical_notes+10, #midi_B1 ;0x0a
	mov musical_notes+11, #midi_C2 ;0x0b 
	mov musical_notes+12, #midi_D2 ;0x0c 
	mov musical_notes+13, #midi_E2 ;0x0d
	mov musical_notes+14, #midi_F2 ;0x0e 
	mov musical_notes+15, #midi_G2 ;0x0f
	mov musical_notes+16, #midi_A2 ;0x10
	mov musical_notes+17, #midi_B2 ;0x11
	mov musical_notes+18, #midi_C3 ;0x12
	mov musical_notes+19, #midi_D3 ;0x13
	mov musical_notes+20, #midi_E3 ;0x14
	mov musical_notes+21, #midi_F3 ;0x15 
	mov musical_notes+22, #midi_G3 ;0x16
	mov musical_notes+23, #midi_A3 ;0x17 
	mov musical_notes+24, #midi_B3 ;0x18
	mov musical_notes+25, #midi_C4 ;0x19
	mov musical_notes+26, #midi_D4 ;0x1a
	mov musical_notes+27, #midi_E4 ;0x1b
	mov musical_notes+28, #midi_F4 ;0x1c
	; sharps
	mov musical_notes+29, #midi_D1S ; 0x1d
	mov musical_notes+30, #midi_A1S ; 0x1e
	mov musical_notes+31, #midi_D2S ; 0x1f
	
	ret
	
midi_note_state_machine:
	lcall display_state
	mov a, midi_note_state
midi_note_state0:
	cjne a, #0, midi_note_state1
	setb TR1
	mov a, musical_notes+0
	ljmp midi_note_end_state_machine
midi_note_state1:
	cjne a, #1, midi_note_state2
	setb TR1
	mov a, musical_notes+1
	ljmp midi_note_end_state_machine
midi_note_state2:
	cjne a, #2, midi_note_state3
	setb TR1
	mov a, musical_notes+2
	ljmp midi_note_end_state_machine
midi_note_state3:
	cjne a, #3, midi_note_state4
	setb TR1
	mov a, musical_notes+3
	ljmp midi_note_end_state_machine
midi_note_state4:
	cjne a, #4, midi_note_state5
	setb TR1
	mov a, musical_notes+4
	ljmp midi_note_end_state_machine
	setb TR1
midi_note_state5:
	cjne a, #5, midi_note_state6
	setb TR1
	mov a, musical_notes+5
	ljmp midi_note_end_state_machine
midi_note_state6:
	cjne a, #6, midi_note_state7
	setb TR1
	mov a, musical_notes+6
	ljmp midi_note_end_state_machine
midi_note_state7:
	cjne a, #7, midi_note_state8
	setb TR1
	mov a, musical_notes+7
	ljmp midi_note_end_state_machine
midi_note_state8:
	cjne a, #8, midi_note_state9
	setb TR1
	mov a, musical_notes+8
	ljmp midi_note_end_state_machine
midi_note_state9:
	cjne a, #9, midi_note_state10
	setb TR1
	mov a, musical_notes+9
	ljmp midi_note_end_state_machine
midi_note_state10:
	cjne a, #10, midi_note_state11
	setb TR1
	mov a, musical_notes+10
	ljmp midi_note_end_state_machine
midi_note_state11:
	cjne a, #11, midi_note_state12
	setb TR1
	mov a, musical_notes+11
	ljmp midi_note_end_state_machine
	setb TR1
midi_note_state12:
	cjne a, #12, midi_note_state13
	setb TR1
	mov a, musical_notes+12
	ljmp midi_note_end_state_machine
midi_note_state13:
	cjne a, #13, midi_note_state14
	setb TR1
	mov a, musical_notes+13
	ljmp midi_note_end_state_machine
midi_note_state14:
	cjne a, #14, midi_note_state15
	setb TR1
	mov a, musical_notes+14
	ljmp midi_note_end_state_machine
midi_note_state15:
	cjne a, #15, midi_note_state16
	setb TR1
	mov a, musical_notes+15
	ljmp midi_note_end_state_machine
midi_note_state16:
	cjne a, #16, midi_note_state17
	setb TR1
	mov a, musical_notes+16
	ljmp midi_note_end_state_machine
midi_note_state17:
	cjne a, #17, midi_note_state18
	setb TR1
	mov a, musical_notes+17
	ljmp midi_note_end_state_machine
midi_note_state18:
	cjne a, #18, midi_note_state19
	setb TR1
	mov a, musical_notes+18
	ljmp midi_note_end_state_machine
midi_note_state19:
	cjne a, #19, midi_note_state20
	setb TR1
	mov a, musical_notes+19
	ljmp midi_note_end_state_machine
midi_note_state20:
	cjne a, #20, midi_note_state21
	setb TR1
	mov a, musical_notes+20
	ljmp midi_note_end_state_machine
midi_note_state21:
	cjne a, #21, midi_note_state22
	setb TR1
	mov a, musical_notes+21
	ljmp midi_note_end_state_machine
	setb TR1
midi_note_state22:
	cjne a, #22, midi_note_state23
	setb TR1
	mov a, musical_notes+22
	ljmp midi_note_end_state_machine
midi_note_state23:
	cjne a, #23, midi_note_state24
	setb TR1
	mov a, musical_notes+23
	ljmp midi_note_end_state_machine
midi_note_state24:
	cjne a, #24, midi_note_state25
	setb TR1
	mov a, musical_notes+24
	ljmp midi_note_end_state_machine
midi_note_state25:
	cjne a, #25, midi_note_state26
	setb TR1
	mov a, musical_notes+25
	ljmp midi_note_end_state_machine
midi_note_state26:
	cjne a, #26, midi_note_state27
	setb TR1
	mov a, musical_notes+26
	ljmp midi_note_end_state_machine
midi_note_state27:
	cjne a, #27, midi_note_state28
	setb TR1
	mov a, musical_notes+27
	ljmp midi_note_end_state_machine
midi_note_state28:
	cjne a, #28, midi_note_state_off
	setb TR1
	mov a, musical_notes+28
	ljmp midi_note_end_state_machine
midi_note_state29:
	cjne a, #29, midi_note_state30
	setb TR1
	mov a, musical_notes+29
	ljmp midi_note_end_state_machine
midi_note_state30:
	cjne a, #30, midi_note_state31
	setb TR1
	mov a, musical_notes+30
	ljmp midi_note_end_state_machine
midi_note_state31:
	cjne a, #31, midi_note_state_off
	setb TR1
	mov a, musical_notes+31
	ljmp midi_note_end_state_machine
	setb TR1
midi_note_state_off:
	cjne a, #32, midi_note_default_state
	clr TR1
	ljmp midi_note_end_state_machine
midi_note_default_state:
	mov midi_note_state, #0
midi_note_end_state_machine:	
	mov freq_value, a
	mov TIMER1_RELOAD_L, a
	clr midi_trigger
	
	ret
	
play_midi_note:
	jb mute, end_midi_sm
	lcall midi_note_state_machine
end_midi_sm:
	ret
	
MainProgram:
    mov SP, #7FH ; Set the stack pointer to the begining of idata
    mov freq_value, #0
    setb direction
    lcall Timer1_Init
    lcall Timer2_Init
    lcall LCD_4BIT
    lcall load_midi_notes
    
    clr mute
    clr midi_trigger
    mov P0M0, #0
    mov P0M1, #0
    
    setb EA   ; Enable Global interrupts
    
    mov seq_count, #0
    mov seq_size, #32 
forever:

	jb ON_OFF, midi
	lcall Delay
	jb ON_OFF, midi
	jnb ON_OFF, $
	cpl mute
	jnb mute, midi
	clr TR1 
	
midi:
	jb mute, midi_end
	jnb midi_trigger, midi_end
	lcall play_midi_note
midi_end:

	sjmp forever
end