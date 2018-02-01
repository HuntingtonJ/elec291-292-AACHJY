$NOLIST
; Code for menu options


							; Menu options: 
							; Solder profile: 
								; Pb solder
								; Pb-free 
								; Custom 
									; Soak Time
									; Soak Temp
									; Reflow Time
									; Reflow Temp 

									; Will be implemented with a moveable cursor, the value of which will add 1's, 10's, 0r 100's. 

;Messages to be displayed
; cseg
Welcome: db 'Welcome', 0
Choose_menu_option: db 'Please select menu option', 0

; dseg at 0x30
increment_counter: ds 1 


Initial_menu: 			

	Set_Cursor(1, 1)
    Send_Constant_String(#Welcome)
    Set_Cursor(2, 1)
    Send_Constant_String(#Choose_option)
    ;------------- any button being pressed will change the screen

    jnb SELECT_BUTTON, Choose_menu
    jnb NEXT_BUTTON, Choose_menu
    jnb UP_BUTTON, Choose_menu
    jnb DOWN_BUTTON, Choose_menu
    sjmp Initial_menu

system_ready: 
	Set_Cursor(1,1)
	Send_Constant_String(#Is_ready)
	Set_Cursor(2,1)
	Send_Constant_String(#Press_start)

	button_jmp(BACK_BUTTON, Choose_menu)
	button_jmp(UP_BUTTON, Choose_menu)
	button_jmp(DOWN_BUTTON, Choose_menu)
	button_jmp(SELECT_BUTTON, Choose_menu)

sjmp system_ready




Choose_menu: 
	Set_Cursor(1,1)
	Send_Constant_String(#Preset_menu)

	
	Set_Cursor(2,1)
	Send_Constant_String(#Custom_menu)


	;!!!!need to have flashing cursor on screen on whichever option is selected !!!
	jnb UP_BUTTON, Preset_menu_select
	jnb DOWN_BUTTON, Custom_menu_select

	sjmp Choose_menu


Preset_menu_select: 
	jnb DOWN_BUTTON, Custom_menu_select
	jnb SELECT_BUTTON, Preset_menu
	jnb BACK_BUTTON, Choose_menu ; have we determined if we are using a back button or a next button? What is the purpose of a next button? 

	sjmp Preset_menu_select

Custom_menu_select: 
	jnb UP_BUTTON, Preset_menu_select
	jnb SELECT_BUTTON, Custom_menu
	jnb BACK_BUTTON, Choose_menu

	sjmp Custom_menu_select


Preset_menu: 
	Set_Cursor(1,1)
	Send_Constant_String(#Pb_free_solder)
	Set_Cursor(2,1)
	Send_Constant_String(#Pb_solder)


	jnb UP_BUTTON, pb_free_select
	jnb DOWN_BUTTON, pb_select
	jnb BACK_BUTTON, Choose_menu

	sjmp Choose_menu

pb_free_select: 
	jnb DOWN_BUTTON, pb_select
	jnb SELECT_BUTTON, pb_free_solder_set
	jnb BACK_BUTTON, Choose_menu

	sjmp pb_free_select

pb_select: 
	jnb UP_BUTTON, pb_free_select
	jnb SELECT_BUTTON, pb_solder_set
	jnb BACK_BUTTON, Choose_menu

	sjmp pb_select


pb_solder_set: 		; for soldering with the Sn63Pb37 alloy	
	Set_Cursor(1,1)
	Send_Constant_String(#Pb_solder)
	Set_Cursor(2,1)
	Send_Constant_String(#Profile_loaded)

	mov soak_time, #120
	mov soak_temp, #150
	mov reflow_time, #20
	mov reflow_temp, #230

	ljmp system_ready

pb_free_solder_set: 	;for soldering SAC305 lead-free solder 
	Set_Cursor(1,1)
	Send_Constant_String(#Pb_free_solder)
	Set_Cursor(2,1)
	Send_Constant_String(#Profile_loaded)

	mov soak_time, #120
	mov soak_temp, #160
	mov reflow_time, #15
	mov reflow_temp, #245

	ljmp system_ready

Pb_free_secret_pizza: 				; can we include this as a joke/bonus pls???
	Set_Cursor(1,1)
	Send_Constant_String(#Pizza_msg0)
	Set_Cursor(2,1)
	Send_Constant_String(#Pizza_msg1)

	mov soak_time, #30
	mov soak_temp, #200
	mov reflow_time, #20
	mov reflow_temp, #245

	ljmp system_ready





;Button Pressed macro 
;if button (input %0) is pressed, go to specified location (input %1), if not, go to next instruction

button_jmp mac	
jb %0, endhere
Wait_Milli_Seconds(#50)
jb %0, endhere
jnb %0, $
ljmp %1

endhere: 
	endmac


$LIST