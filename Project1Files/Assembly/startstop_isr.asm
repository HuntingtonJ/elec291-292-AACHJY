


; START/STOP SWITCH SUBROUTINE
; Configured as a keyboard interface and general- purpose interrupts 

; CHecks if pin is high or low
; if high- jumps into reflow FSM 
; if low- jumps into the menu 
; 

MASTER_START equ p1.0
MASTER_STOP EQU 1.1
Abort_string: db 'Process aborted', 0
Waiting_to_cool: db 'Wait to cool', 0

;----------------;
; Routine to initialize 
; Start/stop buttons ISR; 
;-----------------;

Start_stop_Init: 
	
	mov KBMOD, #3	; enable edge triggered for P0.0 and P0.1
	mov KBLS, #0 	; watch for negative edge (0->1)
	mov KBE, #3	; enable interrupt for p0.0 and p0.1
	mov KBF, #3; interrupt active, must clear at start of ISR and setb at end. 

	ret

Start_stop_ISR: 
mov KBF, #0		; masks interrupt 
push acc

button_jmp(MASTER_STOP, STOP_ROUTINE)	; if master stop has been pressed, change to state 5

button_jmp(MASTER_START, START_ROUTINE) ; if master start has been pressed, change to state 1

START_ROUTINE: 
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

