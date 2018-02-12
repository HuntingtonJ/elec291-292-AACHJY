;---------------------------------------------;
;  load_segments()                            ;
;                                             ;
;  Pattern to load passed in accumulator      ;
;  Called in the seq_state_machine.           ;
;---------------------------------------------;
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

;---------------------------------------------;
;  seg_state_machine()                        ;
;                                             ;
;  7-seg state machine. Called in the         ;
;  timer2 isr.                                ;
;---------------------------------------------;
seg_state_machine:
	; Turn all displays off
	setb CA1
	setb CA2
	setb CA3

	mov a, seg_state ; Load current state value
			
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
	ret

;--------------------------------------------;
;  seg_state_init()                          ;
;                                            ;
;  called to initializ 7-seg display         ;
;--------------------------------------------;
seg_state_init:
	mov a, #0
	mov seg_state, a  ;set 7_seg 7_seg_state to 0
	mov a, #00010001b
	mov BCD_temp+0, a
	mov a, #00000001b
	mov BCD_temp+1, a
	
	lcall set_7_segment_diplay
	ret

;--------------------------------------------;
;  set_7_segment_diplay()                    ;
;                                            ;
;  sets the 7-seg display to the current     ;
;  BCD_temp value.                           ;
;  Should be called after temp data is       ;
;  updated.                                  ;
;--------------------------------------------;
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
	ret
	
load_sm_init:
	mov load_state, #0
	setb load
	ret
	
load_sm_off:
	clr load
	ret
	
load_sm:
	mov a, load_state
	
	load_state0:
		cjne a, #0, load_state1 ; _ _ _
		mov disp1, #0xF0        ;|     |
		mov disp2, #0x7F        ;|_   _|
		mov disp3, #0xC6
		mov load_state, #1
		ljmp load_sm_end
	load_state1:
		cjne a, #1, load_state2 ; _ _ _
		mov disp1, #0xF0        ;|     |
		mov disp2, #0xF6        ;|  _ _|
		mov disp3, #0xCE
		mov load_state, #2
		ljmp load_sm_end
	load_state2:
		cjne a, #2, load_state3 ; _ _ _
		mov disp1, #0xF0        ;|     |
		mov disp2, #0xF6        ; _ _ _|
		mov disp3, #0xD6
		mov load_state, #3
		ljmp load_sm_end
	load_state3:
		cjne a, #3, load_state4 ; _ _ _
		mov disp1, #0xF0        ;      |
		mov disp2, #0xF6        ;|_ _ _|
		mov disp3, #0xE6
		mov load_state, #4
		ljmp load_sm_end
	load_state4:
		cjne a, #4, load_state5 ;   _ _
		mov disp1, #0xF0        ;|     |
		mov disp2, #0xF6        ;|_ _ _|
		mov disp3, #0xC7
		mov load_state, #5
		ljmp load_sm_end
	load_state5:
		cjne a, #5, load_state6 ; _   _
		mov disp1, #0xF0        ;|     |
		mov disp2, #0xF7        ;|_ _ _|
		mov disp3, #0xC6
		mov load_state, #6
		ljmp load_sm_end
	load_state6:
		cjne a, #6, load_state7 ; _ _  
		mov disp1, #0xF1        ;|     |
		mov disp2, #0xF6        ;|_ _ _|
		mov disp3, #0xC6
		mov load_state, #7
		ljmp load_sm_end
	load_state7:
		cjne a, #7, load_state8 ; _ _ _
		mov disp1, #0xF2        ;|      
		mov disp2, #0xF6        ;|_ _ _|
		mov disp3, #0xC6
		mov load_state, #8
		ljmp load_sm_end
	load_state8:
		cjne a, #8, load_state9 ; _ _ _
		mov disp1, #0xF4        ;|     |
		mov disp2, #0xF6        ;|_ _ _
		mov disp3, #0xC6
		mov load_state, #9
		ljmp load_sm_end
	load_state9:                ; _ _ _
		mov disp1, #0xF8        ;|     |
		mov disp2, #0xF6        ;|_ _  |
		mov disp3, #0xC6
		mov load_state, #0

	load_sm_end:
	ret

END