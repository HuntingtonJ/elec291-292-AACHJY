CSEG

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
	button_jmp(MASTER_START, Confirm_menu)

ljmp system_ready

Confirm_menu:
	
	; We need to check that all parameters are loaded with non-zero values
	mov a, soaktime
	CJNE a, #0, one_good
	sjmp unloaded
one_good: 
	mov a, soaktemp
	CJNE a, #0, two_good
	sjmp unloaded
two_good: 
	mov a, reflowtime
	CJNE a, #0, three_good
	sjmp unloaded

three_good: 
	mov a, reflowtemp
	CJNE a, #0, Loaded_param
	sjmp unloaded

unloaded: 
	Set_Cursor(1,1)
	Send_Constant_String(#Error_msg1)
	Set_Cursor(2,1)
	Send_Constant_String(#Error_msg2)
	mov reflow_state, #0		; reset state to zero (as it is set to 1 by the start_button ISR)
	ljmp Initial_menu

Loaded_param: 

	;Then check if the state=1. If so, goto reflow FSM
;	mov a, reflow_state
	;cjne a, #1, state_error
	
	button_jmp(BACK_BUTTON, Choose_menu)
	button_jmp(MASTER_START, reflow_state_machine)	
	
	sjmp Loaded_param

Choose_menu: 
	Set_Cursor(1,1)
	Send_Constant_String(#Preset_menu_msg)
	Set_Cursor(2,1)
	Send_Constant_String(#Custom_menu_msg)

	;!!!!need to have flashing cursor on screen on whichever option is selected !!!
	button_jmp(UP_BUTTON, Preset_menu_select)
	button_jmp(DOWN_BUTTON, Custom_menu_select)
	
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


End