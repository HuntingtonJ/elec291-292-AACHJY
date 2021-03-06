; Code for menu options

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


org 0x0000
   ljmp Main_Menu_Program
   
;org 0x0003
;   ljmp Start_stop_ISR

; These ’EQU’ must match the wiring between the microcontroller and ADC
SOUND_OUT   EQU P3.7
CE_ADC      EQU P2.4
MY_MOSI     EQU P2.5
MY_MISO     EQU P2.6
MY_SCLK     EQU P2.7
UP_BUTTON	EQU P0.0
DOWN_BUTTON EQU P0.1
SELECT_BUTTON EQU P0.2
NEXT_BUTTON EQU P0.3
BACK_BUTTON EQU p0.4
;MASTER_START_STOP equ p0.5
; START/STOP SWITCH SUBROUTINE
; Configured as a keyboard interface and general- purpose interrupts 
; CHecks if pin is high or low
; if high- jumps into reflow FSM 
; if low- jumps into the menu 
MASTER_START equ p0.5
MASTER_STOP equ p0.6
;Abort_string: db 'Process aborted', 0
;Waiting_to_cool: db 'Wait to cool', 0



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
;reflow fsm variables
reflow_state: ds 1
pwm: ds 1
temp: ds 1
sec: ds 1 		; seconds variable for reflow FSM (to be incremented every second)
cooled_temp: ds 1
state: ds 1

BSEG
mf: dbit 1

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

;$NOLIST
;$include(menu_code.inc) 
;$LIST

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
FSMMSG:			  db 'IN FSM          ', 0
Are_you_sure:  	  db 'Are you sure?   ', 0
Abort_string: 	  db 'Process aborted ', 0
Waiting_to_cool:  db 'Wait to cool    ', 0
Confirm:		  db 'Confirm         ', 0
; State titles for LCD
;						123456789012345
Ramp_to_Soak: 		db         'Preheat', 0
Soak: 				db		   'Soak   ', 0
Ramp_to_Peak: 		db 		   'Ramp2pk', 0
Reflow: 			db 		   'Reflow ', 0
Cooling: 			db 		   'Cooling', 0
secondsss: 			db		   's'		, 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;		Master Start/Stop ISR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Start_stop_ISR: 
;Macro commented out as we want the ISR to  be immediate 
; and the macro will delay it by 1 clk cycle due to debouncing 
;	button_jmp(MASTER_STOP, STOP_ROUTINE)	; if master stop has been pressed, change to state 5
;	button_jmp(MASTER_START, START_ROUTINE) ; if master start has been pressed, change to state 1
;	jnb MASTER_START, START_ROUTINE
;	jnb MASTER_START, START_ROUTINE
	

;START_ROUTINE: 
;	mov a, reflow_state
;	cjne a, #0, End_master_ISR
;	mov reflow_state, #1
;	ljmp End_master_ISR

;STOP_ROUTINE: 
;	mov reflow_state, #5	
;	; any other things we want to do, ie, statements we want to make 
;	Set_cursor(1,1)
;	Send_Constant_String(#Abort_string)
;	Set_cursor(2,1)
;	Send_Constant_String(#Waiting_to_cool)
;	sjmp End_master_ISR

;End_master_ISR: 
;	reti
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;				End Master Start/Stop ISR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WaitHalfSec:
    mov R2, #45
Wait3: mov R1, #250
Wait2: mov R0, #166
Wait1: djnz R0, Wait1 ; 3 cycles->3*45.21123ns*166=22.51519us
    djnz R1, Wait2 ; 22.51519us*250=5.629ms
    djnz R2, Wait3 ; 5.629ms*89=0.5s (approximately)
    ret

;-----------------------------
;Button Pressed macro 
;if button (input %0) is pressed, go to specified location (input %1), if not, go to next instruction
;-----------------------------

button_jmp mac	
jb %0, endhere_%M
Wait_Milli_Seconds(#50)
jb %0, endhere_%M
jnb %0, $
ljmp %1

endhere_%M: 			
	endmac

putchar:
    jnb TI, putchar
    clr TI
    mov SBUF, a
    ret

	
; State 0 - menu
; 1 - ramp to soak 
; 2- Soak
; 3- Ramp to reflow
; 4- Reflow
; 5- Cooling 

Reflow_screen mac

	Set_Cursor(1,9)
	Send_Constant_String(#%0)		; display current state

	Set_Cursor(2,9)
	mov a, sec
	lcall putchar 					;display current time count of state

	Set_Cursor(2, 12)
	Send_Constant_String(#secondsss)

	Set_Cursor(2, 1)
	mov a, temp
	lcall putchar 					;display current temp of state

	Set_Cursor(2, 4)
	mov a, #11011111b
	lcall putchar 	
endmac

Main_Menu_Program:
	mov SP, #7FH
	;Configure port 0/1 in bi-directional mode
	mov P0M0, #0
    mov P0M1, #0
    lcall LCD_4BIT
	;Set all vars initally to zero
	mov soaktime, #0x00
	mov soaktemp, #0x00
	mov reflowtime, #0x00
	mov reflowtemp, #0x00
	;display initial menu messages

	Set_Cursor(2, 4)
	mov a, #11011111b
	lcall putchar 	

	ljmp Initial_menu	


;----------------Main Menu Logic----------------;
Initial_menu: 
	Set_Cursor(1, 1)
    Send_Constant_String(#Welcome)
    Set_Cursor(2, 1)
    Send_Constant_String(#Choose_option)
	
    ;------------- any button being pressed will change the screen
    button_jmp(SELECT_BUTTON, Choose_menu)
    button_jmp(NEXT_BUTTON, Choose_menu)
    button_jmp(UP_BUTTON, Choose_menu)
    button_jmp(DOWN_BUTTON, Choose_menu)
    ljmp Initial_menu

system_ready: 
	Set_Cursor(1,1)
	Send_Constant_String(#Is_ready)
	Set_Cursor(2,1)
	Send_Constant_String(#Press_start)

	button_jmp(BACK_BUTTON, Choose_menu)
	
	button_jmp(UP_BUTTON, Choose_menu)

	button_jmp(DOWN_BUTTON, Choose_menu)
	button_jmp(SELECT_BUTTON, Choose_menu)

ljmp system_ready


Choose_menu: 
	Set_Cursor(1,1)
	Send_Constant_String(#Preset_menu_msg)
	Set_Cursor(2,1)
	Send_Constant_String(#Custom_menu_msg)

	;!!!!need to have flashing cursor on screen on whichever option is selected !!!
	button_jmp(UP_BUTTON, Preset_menu_select)
	button_jmp(DOWN_BUTTON, Custom_menu_select)
	;press master start to confrim choices
	button_jmp(MASTER_START, Confirm_menu)
	sjmp Choose_menu

Preset_menu_select:
	;Remove messages when blinking cursor is set up
	Set_Cursor(1,1)
	Send_Constant_String(#PRESETMENUMSG)
	Set_Cursor(2,1)
	Send_Constant_String(#Clear_Row)
	
	button_jmp(DOWN_BUTTON, Custom_menu_select)
	button_jmp(SELECT_BUTTON, Preset_menu)
	button_jmp(BACK_BUTTON, Choose_menu) ; have we determined if we are using a back button or a next button? What is the purpose of a next button? 

	sjmp Preset_menu_select

Custom_menu_select: 
	;Remove messages when blinking cursor is set up
	Set_Cursor(1,1)
	Send_Constant_String(#CUSTOMMENUMSG)
	Set_Cursor(2,1)
	Send_Constant_String(#Clear_Row)
	
	button_jmp(UP_BUTTON, Preset_menu_select)
	button_jmp(SELECT_BUTTON, Custom_menu)
	button_jmp(BACK_BUTTON, Choose_menu)

	sjmp Custom_menu_select

;------------------ Preset Menu END----------------------------------;
Preset_menu: 
	Set_Cursor(1,1)
	Send_Constant_String(#Pb_free_solder)
	Set_Cursor(2,1)
	Send_Constant_String(#Pb_solder)


	button_jmp(UP_BUTTON, pb_free_select)
	button_jmp(DOWN_BUTTON, pb_select)
	button_jmp(BACK_BUTTON, Choose_menu)

	ljmp Preset_menu

pb_free_select: 
	button_jmp(DOWN_BUTTON, pb_select)
	button_jmp(SELECT_BUTTON, pb_free_solder_set)
	button_jmp(BACK_BUTTON, Choose_menu)

	sjmp pb_free_select

pb_select: 
	button_jmp(UP_BUTTON, pb_free_select)
	button_jmp(SELECT_BUTTON, pb_solder_set)
	button_jmp(BACK_BUTTON, Choose_menu)

	sjmp pb_select


pb_solder_set: 		; for soldering with the Sn63Pb37 alloy	
	Set_Cursor(1,1)
	Send_Constant_String(#Pb_solder)
	Set_Cursor(2,1)
	Send_Constant_String(#Profile_loaded)
	;mov a, #120
	;da a 
	mov soaktime, #120
;	mov a, #150
	;da a
	mov soaktemp, #150
	mov reflowtime, #20
	mov reflowtemp, #230

	ljmp system_ready

pb_free_solder_set: 	;for soldering SAC305 lead-free solder 
	Set_Cursor(1,1)
	Send_Constant_String(#Pb_free_solder)
	Set_Cursor(2,1)
	Send_Constant_String(#Profile_loaded)
	
;	mov a, #120
;	da a
	mov soaktime, #120
	
;	mov a, #160
;	da a
	mov soaktemp, #160
	mov a, #15
;	da a
	mov reflowtime, a
	
	mov a, #245
;	da a
	mov reflowtemp, a
	ljmp system_ready

Pb_free_secret_pizza: 				; can we include this as a joke/bonus pls???
	Set_Cursor(1,1)
	Send_Constant_String(#Pizza_msg0)
	Set_Cursor(2,1)
	Send_Constant_String(#Pizza_msg1)

	mov a, #30
;	da a
	mov soaktime, a
	mov a, #200
;	da a
	mov soaktemp, a
	
	mov a , #20
;	da a
	mov reflowtime, a
	mov a, #245
;	da a
	mov reflowtemp, a

	ljmp system_ready
	
;------------------ Preset Menu END----------------------------------;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Custom Menu Begin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Custom_menu: 
	Set_Cursor(1, 1)
    Send_Constant_String(#Custom_menu_msg)
    Set_Cursor(2, 1)
    Send_Constant_String(#Clear_Row)
	;Wait until select button is pressed then loop to options
	;button_jmp(SELECT_BUTTON, Forever_loop)
	;jb SELECT_BUTTON, Forever_loop
	;Wait_Milli_Seconds(#50)
	;jb SELECT_BUTTON, Forever_loop
	;jnb SELECT_BUTTON, $
	BUTTON_jmp(SELECT_BUTTON, Set_Soak_temp)
	sjmp Forever_loop
	;ljmp Set_Soak_temp
	
Forever_loop:
	jnb BACK_BUTTON, Custom_to_Choose_menu
	sjmp Custom_menu	
Custom_to_Choose_menu:
	ljmp Choose_menu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Set Soak Temp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
Set_Soak_temp:	
	Set_Cursor(1,1)
	Send_Constant_String(#Soak_temp)
	Set_Cursor(2,1)
	Display_BCD(soaktemp)
	;if up/down buttons pressed branch and inc/dec params
	jb UP_BUTTON, Decrease_soaktemp
	Wait_Milli_Seconds(#50)
	jb UP_BUTTON, Decrease_soaktemp
	jnb UP_BUTTON, $
	mov a, soaktemp
	add a, #0x01
	da a
	cjne a, #0x99, Increase_soaktemp_loop
	clr a 
	mov soaktemp, a
	ljmp Set_Soak_temp
	
Increase_soaktemp_loop:
	mov soaktemp, a
	clr a	
	ljmp Set_Soak_temp	
	
Decrease_soaktemp:
	jb DOWN_BUTTON, Nextmenu1
	Wait_Milli_Seconds(#50)
	jb DOWN_BUTTON, Nextmenu1
	jnb DOWN_BUTTON, $	
	mov a, soaktemp
	add a, #0x99
	da a
	cjne a, #0x00, Decrease_soaktemp_loop
	clr a 
	mov soaktemp, a
	ljmp Set_Soak_temp
	
Decrease_soaktemp_loop:
	mov soaktemp, a
	clr a	
	ljmp Set_Soak_temp	
Nextmenu1:
	jnb NEXT_BUTTON, Set_Soak_time
	ljmp Set_Soak_temp	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Set Soak Time
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Set_Soak_time:
	jnb NEXT_BUTTON, $
	Set_Cursor(1,1)
	Send_Constant_String(#Soak_time)
	Set_Cursor(2,1)
	Display_BCD(soaktime)
	;Button_jmp(UP_BUTTON,Decrease_soaktime)
	;if up/down buttons pressed branch and inc/dec params
	jb UP_BUTTON, Decrease_soaktime
	Wait_Milli_Seconds(#50)
	jb UP_BUTTON, Decrease_soaktime
	jnb UP_BUTTON, $
	mov a, soaktime
	add a, #0x01
	da a
	cjne a, #0x99, Increase_soaktime_loop
	clr a 
	mov soaktime, a
	ljmp Set_Soak_time
	
Increase_soaktime_loop:
	mov soaktime, a
	clr a	
	ljmp Set_Soak_time	
	
Decrease_soaktime:
	jb DOWN_BUTTON, Nextmenu2
	Wait_Milli_Seconds(#50)
	jb DOWN_BUTTON, Nextmenu2
	jnb DOWN_BUTTON, $	
	mov a, soaktime
	add a, #0x99
	da a
	cjne a, #0x00, Decrease_soaktime_loop
	clr a 
	mov soaktime, a
	ljmp Set_Soak_time
	
Decrease_soaktime_loop:
	mov soaktime, a
	clr a	
	ljmp Set_Soak_time	
Nextmenu2:
	jnb NEXT_BUTTON, Set_Reflow_temp 
	ljmp Set_Soak_time
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Set Reflow Temp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Set_Reflow_temp:
	jnb NEXT_BUTTON, $
	Set_Cursor(1,1)
	Send_Constant_String(#Reflow_temp)
	Set_Cursor(2,1)
	Display_BCD(reflowtemp)
	;if up/down buttons pressed branch and inc/dec params
	jb UP_BUTTON, Decrease_reflowtemp
	Wait_Milli_Seconds(#50)
	jb UP_BUTTON, Decrease_reflowtemp
	jnb UP_BUTTON, $
	mov a, reflowtemp
	add a, #0x01
	da a
	cjne a, #0x99, Increase_reflowtemp_loop
	clr a 
	mov reflowtemp, a
	ljmp Set_Reflow_temp
	
Increase_reflowtemp_loop:
	mov reflowtemp, a
	clr a	
	ljmp Set_Reflow_temp	
	
Decrease_reflowtemp:
	jb DOWN_BUTTON, Nextmenu3
	Wait_Milli_Seconds(#50)
	jb DOWN_BUTTON, Nextmenu3
	jnb DOWN_BUTTON, $	
	mov a, reflowtemp
	add a, #0x99
	da a
	cjne a, #0x00, Decrease_reflowtemp_loop
	clr a 
	mov reflowtemp, a
	ljmp Set_Reflow_temp
	
Decrease_reflowtemp_loop:
	mov reflowtemp, a
	clr a	
	ljmp Set_Reflow_temp	
Nextmenu3:
	jnb NEXT_BUTTON, Set_Reflow_time 
	ljmp Set_Reflow_temp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Set Reflow Time
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
Set_Reflow_time:
	jnb NEXT_BUTTON, $
	Set_Cursor(1,1)
	Send_Constant_String(#Reflow_time)
	Set_Cursor(2,1)
	Display_BCD(reflowtime)
	;if up/down buttons pressed branch and inc/dec params
	jb UP_BUTTON, Decrease_reflowtime
	Wait_Milli_Seconds(#50)
	jb UP_BUTTON, Decrease_reflowtime
	jnb UP_BUTTON, $
	mov a, reflowtime
	add a, #0x01
	da a
	cjne a, #0x99, Increase_reflowtime_loop
	clr a 
	mov reflowtime, a
	ljmp Set_Reflow_time
	
Increase_reflowtime_loop:
	mov reflowtime, a
	clr a	
	ljmp Set_Reflow_time
	
Decrease_reflowtime:
	jb DOWN_BUTTON, Nextmenu4
	Wait_Milli_Seconds(#50)
	jb DOWN_BUTTON, Nextmenu4
	jnb DOWN_BUTTON, $	
	mov a, reflowtime
	add a, #0x99
	da a
	cjne a, #0x00, Decrease_reflowtime_loop
	clr a 
	mov reflowtime, a
	ljmp Set_Reflow_time
	
Decrease_reflowtime_loop:
	mov reflowtime, a
	clr a	
	ljmp Set_Reflow_time
Nextmenu4:
	jnb NEXT_BUTTON, Custom_menu_loopback
	ljmp Set_Reflow_time
	
Custom_menu_loopback:
	Set_Cursor(1,1)
	Send_Constant_String(#Are_you_sure)
	Set_Cursor(2,1)
	Send_Constant_String(#Clear_Row)
	jnb UP_BUTTON, lllaaa
	ljmp Custom_menu_loopback
lllaaa:
	ljmp Custom_menu
;----------------Custom Menu End----------------;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Enter Confirm_menu to confirm choices and enter fsm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Confirm_menu:
	Set_Cursor(1,1)
	Send_Constant_String(#Confirm_menu)
	Set_Cursor(2,1)
	Send_Constant_String(#Clear_Row)	
		
	button_jmp(BACK_BUTTON, Choose_menu)
	button_jmp(MASTER_START, reflow_state_machine)	
	ljmp Confirm_menu
	
reflow_state_machine: 
	
	mov a, reflow_state

	state0:
			cjne a, #0, state1
			mov pwm, #0
			;ljmp Main_Menu_Program
			jb MASTER_START, state0_done
			jnb MASTER_START, $ ; Wait for key release
			mov state, #1
		state0_done:
			ljmp Main_Menu_Program


	state1:
			cjne a, #1, state2
			mov pwm, #100		; Heater on at 100% duty
			Reflow_screen(Ramp_to_Soak)
			mov sec, #0
			mov a, soaktemp
			clr c
			subb a, temp
			jnc state1_done 	;if temp>soaktemp then go to state 2 
			mov sec, #0			; Reset time 'sec' variable representing elapsed time in each state
			mov state, #2
		state1_done:
			ljmp Main_Menu_Program

	state2:
			cjne a, #2, state3
			mov pwm, #20		;20% duty
			Reflow_screen(Soak)
			mov a, soaktime
			clr c
			subb a, sec
			jnc state2_done
			mov state, #3
			mov sec, #0			; reset time for state 3
		state2_done:
			ljmp Main_Menu_Program

	state3:
			cjne a, #3, state4
			mov pwm, #100		; Heater on at 100% duty
			Reflow_screen(Ramp_to_Peak)
			mov a, reflowtemp
			clr c
			subb a, temp
			jnc state3_done 	;if temp>reflowtemp then go to state 4
			mov sec, #0			; reset time for state 4
			mov state, #4
		state3_done:
			ljmp Main_Menu_Program

	state4:
			cjne a, #4, state5
			mov pwm, #20		;20% duty
			Reflow_screen(Reflow)
			mov a, reflowtime
			clr c
			subb a, sec
			jnc state4_done
			mov state, #5
			mov sec, #0		; reset time for state 5
		state4_done:
			ljmp Main_Menu_Program

	state5:
			cjne a, #5, return_state0
			mov pwm, #0			; Heater on at 100% duty
			Reflow_screen(Cooling)
			mov a, cooled_temp
			clr c
			subb a, temp
			jnc state5_done 	;if temp>reflowtemp then go to state 4
			mov sec, #0			; reset time for state 4
			mov state, #0
		state5_done:
			ljmp Main_Menu_Program
return_state0:
	ljmp state0

	
End