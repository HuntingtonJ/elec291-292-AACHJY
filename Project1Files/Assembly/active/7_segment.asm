; ISR_example.asm: a) Increments/decrements a BCD variable every half second using
; an ISR for timer 2; b) Generates a 2kHz square wave at pin P3.7 using
; an ISR for timer 0; and c) in the 'main' loop it displays the variable
; incremented/decremented using the ISR for timer 2 on the LCD.  Also resets it to 
; zero if the 'BOOT' pushbutton connected to P4.5 is pressed.
$NOLIST
$MODLP51
$LIST

; There is a couple of typos in MODLP51 in the definition of the timer 0/1 reload
; special function registers (SFRs), so:

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


; In the 8051 we can define direct access variables starting at location 0x30 up to location 0x7F
dseg at 0x30
Count1ms:     ds 2 ; Used to determine when half second has passed
BCD_counter:  ds 1 ; The BCD counter incrememted in the ISR and displayed in the main loop
Disp1:  ds 1 
Disp2:  ds 1
Disp3:  ds 1
seg_state:  ds 1

; In the 8051 we have variables that are 1-bit in size.  We can use the setb, clr, jb, and jnb
; instructions with these variables.  This is how you define a 1-bit variable:
bseg
half_seconds_flag: dbit 1 ; Set to one in the ISR every time 500 ms had passed

cseg

; Pattern to load passed in accumulator
load_segments:
	mov c, acc.0
	mov SEGA, c
	mov c, acc.1
	mov SEGB, c
	mov c, acc.2
	mov SEGC, c
	mov c, acc.3
	mov SEGD, c
	mov c, acc.4
	mov SEGE, c
	mov c, acc.5
	mov SEGF, c
	mov c, acc.6
	mov SEGG, c
	mov c, acc.7
	mov SEGP, c
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

;;;  7_seg_state machine for 7-segment displays starts here
	; Turn all displays off
	setb CA1
	setb CA2
	setb CA3

	mov a, seg_state
seg_state0: ;Display LED 1
	cjne a, #0, seg_state1
	mov a, disp1
	lcall load_segments
	clr CA1
	inc seg_state
	sjmp seg_state_done
seg_state1: ;Display LED 2
	cjne a, #1, seg_state2
	mov a, disp2
	lcall load_segments
	clr CA2
	inc seg_state
	sjmp seg_state_done
seg_state2: ;Display LED 3
	cjne a, #2, seg_state_reset
	mov a, disp3
	lcall load_segments
	clr CA3
	mov seg_state, #0
	sjmp seg_state_done
seg_state_reset: ;Back to LED 1
	mov seg_state, #0
seg_state_done:
;;;  7_seg_state machine for 7-segment displays ends here
	
	; Increment the 16-bit one mili second counter
	inc Count1ms+0    ; Increment the low 8-bits first
	mov a, Count1ms+0 ; If the low 8-bits overflow, then increment high 8-bits
	jnz Inc_Done
	inc Count1ms+1

Inc_Done:
	; Check if half second has passed
	mov a, Count1ms+0
	cjne a, #low(500), Timer2_ISR_done ; Warning: this instruction changes the carry flag!
	mov a, Count1ms+1
	cjne a, #high(500), Timer2_ISR_done
	
	; 500 milliseconds have passed.  Set a flag so the main program knows
	setb half_seconds_flag ; Let the main program know half second had passed
	cpl TR0 ; Enable/disable timer/counter 0. This line creates a beep-silence-beep-silence sound.
	; Reset to zero the milli-seconds counter, it is a 16-bit variable
	clr a
	mov Count1ms+0, a
	mov Count1ms+1, a
	; Increment the BCD counter
	mov a, BCD_counter
	jnb UPDOWN, Timer2_ISR_decrement
	add a, #0x01
	sjmp Timer2_ISR_da
Timer2_ISR_decrement:
	add a, #0x99 ; Adding the 10-complement of -1 is like subtracting 1.
Timer2_ISR_da:
	da a ; Decimal adjust instruction.  Check datasheet for more details!
	mov BCD_counter, a
	
Timer2_ISR_done:
	pop psw
	pop acc
	reti

HEX_7SEG: DB 0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90

seg_state_init:
	mov seg_state, #0 ;set 7_seg 7_seg_state to 0
	reti

set_7_segment_diplay:
	mov dptr, #HEX_7SEG
	
	mov a, BCD_temp      ;
	anl a, #0x0f         ;Clear upper 4 bits
	movc a, @a+dptr      ;Access HEX_7SEG[a]
	mov disp1, a         ;Move Lowest BCD to display 1
	
	mov a, BCD_temp      ;
	swap a               ;Swaps the high and low nibbles
	anl a, #0x0f         ;Clear upper 4 bits (which are now the lower 4)
	movc a, @a+dptr      ;Access HEX_7SEG[a]
	mov disp2, a         ;Move Second Lowest BCD to display 2
	
	mov a, BCD_temp+1    ;Get the upper 2 BCD digits of value being diplayed
	anl a, #0x0f         ;Clear upper 4 bits
	movc a, @a+dptr      ;Access HEX_7SEG[a]
	mov disp3, a         ;Moves highest bcd digit to diplay 3
	
	reti


END