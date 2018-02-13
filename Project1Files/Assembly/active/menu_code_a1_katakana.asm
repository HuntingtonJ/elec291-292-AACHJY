Cseg

Main_Menu_Program_jap:
	;Set all vars initally to zero
	mov soaktime, #0x00
	mov soaktemp, #0x00
	mov reflowtime, #0x00
	mov reflowtemp, #0x00
	;display initial menu messages	

	ljmp Initial_menu	


;----------------Main Menu Logic----------------;


Initial_menu_jap: 
	Set_Cursor(1, 1)
    Send_Constant_String(#Welcome_jap)
    Set_Cursor(2, 1)
    Send_Constant_String(#Choose_option_jap)
	
    ;------------- any button being pressed will change the screen
    button_jmp(SELECT_BUTTON, Choose_menu_jap)
    button_jmp(UP_BUTTON, Choose_menu_jap)
    button_jmp(DOWN_BUTTON, Choose_menu_jap)
    adc_button_jmp(BACK_BUTTON, Choose_menu_jap)
    adc_button_jmp(MASTER_STOP, Initial_menu)

    ljmp Initial_menu_jap

system_ready_jap: 
	Set_Cursor(1,1)
	Send_Constant_String(#Is_ready_jap)
	Set_Cursor(2,1)
	Send_Constant_String(#Press_start_jap)

	adc_button_jmp(BACK_BUTTON, Choose_menu_jap)
	button_jmp(SELECT_BUTTON, Confirm_menu_jap)
	adc_button_jmp(MASTER_START, Confirm_menu_jap)
	adc_button_jmp(MASTER_STOP, Initial_menu)

ljmp system_ready_jap

Confirm_menu_jap:
	
	; We need to check that all parameters are loaded with non-zero values
	mov a, soaktime
	CJNE a, #0, one_good_jap
	sjmp unloaded_jap
one_good_jap: 
	mov a, soaktemp
	CJNE a, #0, two_good_jap
	sjmp unloaded_jap
two_good_jap: 
	mov a, reflowtime
	CJNE a, #0, three_good_jap
	sjmp unloaded_jap

three_good_jap: 
	mov a, reflowtemp
	CJNE a, #0, Loaded_param_jap_jmp
	sjmp unloaded_jap
	
	Loaded_param_jap_jmp: 
		ljmp Loaded_param_jap

unloaded_jap: 
	Set_Cursor(1,1)
	Send_Constant_String(#Error_msg1_jap)
	Set_Cursor(2,1)
	Send_Constant_String(#Error_msg2_jap)
	mov reflow_state, #0		; reset state to zero (as it is set to 1 by the start_button ISR)
	adc_button_jmp(MASTER_STOP, unloaded_jap)
	ljmp Initial_menu_jap


Loaded_param_jap: 			; All parameters are loaded correctly, time to start!

	;Then check if the state=1. If so, goto reflow FSM
	Set_Cursor(2,1)
	Send_Constant_String(#Clear_Row_jap)
	adc_button_jmp(MASTER_STOP, Loaded_param_jap)
	mov seconds, #0x00
	mov a, #0x01
	mov reflow_state, a
	one_beep(#60)
	; Sends parameters to the python program
	
	; Sends 00000001
	Load_x(0x01)
	lcall hex2bcd
	lcall Send_10_digit_BCD
	; Sends 00000001
	Load_x(0x01)
	lcall hex2bcd
	lcall Send_10_digit_BCD
	
	; Sends soaktime
	mov x+0, soaktime+0
	mov x+1, #0
	mov x+2, #0
	mov x+3, #0
	lcall hex2bcd
	lcall Send_10_digit_BCD
	
	; Sends soaktemp
	mov x+0, soaktemp+0
	mov x+1, #0
	mov x+2, #0
	mov x+3, #0
	lcall hex2bcd
	lcall Send_10_digit_BCD
	
	; Sends reflowtime
	mov x+0, reflowtime+0
	mov x+1, #0
	mov x+2, #0
	mov x+3, #0
	lcall hex2bcd
	lcall Send_10_digit_BCD
	
	; Sends reflowtime
	mov x+0, reflowtemp+0
	mov x+1, #0
	mov x+2, #0
	mov x+3, #0
	lcall hex2bcd
	lcall Send_10_digit_BCD
	
	; Sends 00000000
	Load_x(0x00)
	lcall hex2bcd
	lcall Send_10_digit_BCD
	
	lcall load_sm_off
	
	ljmp forever 		; jumps to main loop to grab temp data so the state machine is not operating with garbage values


	;------------------------------Menu options below----------------------------

Choose_menu_jap: 
	Set_Cursor(1,1)
	Send_Constant_String(#Preset_menu_msg_jap)
	Set_Cursor(2,1)
	Send_Constant_String(#Custom_menu_msg_jap)


	button_jmp(UP_BUTTON, Preset_menu_select_jap)
	button_jmp(DOWN_BUTTON, Custom_menu_select_jap)
	adc_button_jmp(MASTER_STOP, Choose_menu_jap)
	
	ljmp Choose_menu_jap

Preset_menu_select_jap:
	;Remove messages when blinking cursor is set up
	Set_Cursor(1,1)
	Send_Constant_String(#PRESETMENUMSG_jap)
	Set_Cursor(2,1)
	Send_Constant_String(#Clear_Row_jap)
	Set_Cursor(1,16)
	Send_Constant_String(#choose_jap)
	
	button_jmp(DOWN_BUTTON, Custom_menu_select_jap)
	button_jmp(SELECT_BUTTON, Preset_menu_jap)
	adc_button_jmp(BACK_BUTTON, Choose_menu_jap) ; have we determined if we are using a back button or a next button? What is the purpose of a next button? 
        adc_button_jmp(MASTER_STOP,Preset_menu_select_jap)
	ljmp Preset_menu_select_jap

Custom_menu_select_jap: 
	;Remove messages when blinking cursor is set up
	Set_Cursor(1,1)
	Send_Constant_String(#CUSTOMMENUMSG_jap)
	Set_Cursor(2,1)
	Send_Constant_String(#Clear_Row_jap)
	Set_Cursor(1,16)
	Send_Constant_String(#choose_jap)
	
	button_jmp(UP_BUTTON, Preset_menu_select_jap)
	button_jmp(SELECT_BUTTON, Custom_menu_jap)
	adc_button_jmp(BACK_BUTTON, Choose_menu_jap)
	adc_button_jmp(MASTER_STOP, Custom_menu_select_jap)

	ljmp Custom_menu_select_jap

;------------------ Preset Menu start----------------------------------;
Preset_menu_jap: 
	Set_Cursor(1,1)
	Send_Constant_String(#Pb_free_solder_jap)
	Set_Cursor(2,1)
	Send_Constant_String(#Pb_solder_jap)


	button_jmp(UP_BUTTON, pb_free_select_jap)
	button_jmp(DOWN_BUTTON, pb_select_jap)
	adc_button_jmp(BACK_BUTTON, Choose_menu_jap)
	adc_button_jmp(MASTER_STOP, Preset_menu_jap)

	ljmp Preset_menu_jap

pb_free_select_jap: 
	button_jmp(DOWN_BUTTON, pb_select_jap)
	button_jmp(SELECT_BUTTON, pb_free_solder_set_jap)
	adc_button_jmp(BACK_BUTTON, Choose_menu_jap)
	Set_Cursor(1,16)
	Send_Constant_String(#choose_jap)
	Set_Cursor(2,16)
	Send_Constant_String(#clear_row_jap)
	adc_button_jmp(MASTER_STOP,pb_free_select_jap)

	ljmp pb_free_select_jap

pb_select_jap: 
	button_jmp(UP_BUTTON, pb_free_select_jap)
	button_jmp(SELECT_BUTTON, pb_solder_set_jap)
	adc_button_jmp(BACK_BUTTON, Choose_menu_jap)
	Set_Cursor(2,16)
	Send_Constant_String(#choose_jap)
	Set_Cursor(1,16)
	Send_Constant_String(#clear_row_jap)
	adc_button_jmp(MASTER_STOP, pb_select_jap)


	ljmp pb_select_jap


pb_solder_set_jap: 		; for soldering with the Sn63Pb37 alloy	
	Set_Cursor(1,1)
	Send_Constant_String(#Pb_solder_jap)
	Set_Cursor(2,1)
	Send_Constant_String(#Profile_loaded_jap)
	adc_button_jmp(MASTER_STOP, pb_solder_set_jap)

	mov soaktime, #120
	mov soaktemp, #150
	mov reflowtime, #20
	mov reflowtemp, #230

	ljmp system_ready_jap

pb_free_solder_set_jap: 	;for soldering SAC305 lead-free solder 
	Set_Cursor(1,1)
	Send_Constant_String(#Pb_free_solder_jap)
	Set_Cursor(2,1)
	Send_Constant_String(#Profile_loaded_jap)
	adc_button_jmp(MASTER_STOP,pb_free_solder_set_jap)
	
	mov soaktime, #120
	mov soaktemp, #160
	mov reflowtime, #15
	mov reflowtemp, #245
	ljmp system_ready_jap

Pb_free_secret_pizza_jap: 				; can we include this as a joke/bonus pls???
	Set_Cursor(1,1)
	Send_Constant_String(#Pizza_msg0_jap)
	Set_Cursor(2,1)
	Send_Constant_String(#Pizza_msg1_jap)
	adc_button_jmp(MASTER_STOP, Pb_free_secret_pizza_jap)

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
Custom_menu_jap: 
	Set_Cursor(1, 1)
    Send_Constant_String(#Custom_menu_msg_jap)
    Set_Cursor(2, 1)
    Send_Constant_String(#Clear_Row_jap)
    adc_button_jmp(MASTER_STOP, Custom_menu_jap)
	;Wait until select button is pressed then loop to options
	;button_jmp(SELECT_BUTTON, Forever_loop_jap)
	;jb SELECT_BUTTON, Forever_loop
	;Wait_Milli_Seconds(#50)
	;jb SELECT_BUTTON, Forever_loop
	;jnb SELECT_BUTTON, $
	
	BUTTON_jmp(SELECT_BUTTON, Set_Soak_temp_jap)
	sjmp Forever_loop_jap
	;ljmp Set_Soak_temp
	
Forever_loop_jap:
	adc_button_jmp(BACK_BUTTON,Custom_to_Choose_menu_jap)
	ljmp Custom_menu_jap	
Custom_to_Choose_menu_jap:
	ljmp Choose_menu_jap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Set Soak Temp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
Set_Soak_temp_jap:	
	Set_Cursor(1,1)
	Send_Constant_String(#Soak_temp_jap)
	adc_button_jmp(MASTER_STOP, Set_Soak_temp_jap)

	; display soaktemp as 3 digit bcd from 8 bit value
	display_param(soaktemp) 


	;if up/down buttons pressed branch and inc/dec params
	jb UP_BUTTON, Decrease_soaktemp_jap
	Wait_Milli_Seconds(#50)
	jb UP_BUTTON, Decrease_soaktemp_jap
	jnb UP_BUTTON, $
	mov a, soaktemp
	add a, #0x01
	cjne a, #0xff, Increase_soaktemp_loop_jap
	clr a 
	mov soaktemp, a
	ljmp Set_Soak_temp_jap
	
Increase_soaktemp_loop_jap:
	mov soaktemp, a
	clr a	
	ljmp Set_Soak_temp_jap
	
Decrease_soaktemp_jap:
	jb DOWN_BUTTON, Nextmenu1_jap
	Wait_Milli_Seconds(#50)
	jb DOWN_BUTTON, Nextmenu1_jap
	jnb DOWN_BUTTON, $	
	mov a, soaktemp
	add a, #0xff
	cjne a, #0x00, Decrease_soaktemp_loop_jap
	clr a 
	mov soaktemp, a
	ljmp Set_Soak_temp_jap
	
Decrease_soaktemp_loop_jap:
	mov soaktemp, a
	clr a	
	ljmp Set_Soak_temp_jap	
Nextmenu1_jap:
	jnb SELECT_BUTTON, Set_Soak_time_jap
	ljmp Set_Soak_temp_jap	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Set Soak Time
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Set_Soak_time_jap:
	jnb SELECT_BUTTON, $
	Set_Cursor(1,1)
	Send_Constant_String(#Soak_time_jap)
	display_param(soaktime) 
	adc_button_jmp(MASTER_STOP, Set_Soak_time_jap)
	;if up/down buttons pressed branch and inc/dec params

	jb UP_BUTTON, Decrease_soaktime_jap
	Wait_Milli_Seconds(#50)
	jb UP_BUTTON, Decrease_soaktime_jap
	jnb UP_BUTTON, $
	mov a, soaktime
	add a, #0x01
	cjne a, #0xff, Increase_soaktime_loop_jap
	clr a 
	mov soaktime, a
	ljmp Set_Soak_time_jap
	
Increase_soaktime_loop_jap:
	mov soaktime, a
	clr a	
	ljmp Set_Soak_time_jap	
	
Decrease_soaktime_jap:
	jb DOWN_BUTTON, Nextmenu2_jap
	Wait_Milli_Seconds(#50)
	jb DOWN_BUTTON, Nextmenu2_jap
	jnb DOWN_BUTTON, $	
	mov a, soaktime
	add a, #0xff
	cjne a, #0x00, Decrease_soaktime_loop_jap
	clr a 
	mov soaktime, a
	ljmp Set_Soak_time_jap
	
Decrease_soaktime_loop_jap:
	mov soaktime, a
	clr a	
	ljmp Set_Soak_time_jap	
Nextmenu2_jap:
	jnb SELECT_BUTTON, Set_Reflow_temp_jap 
	ljmp Set_Soak_time_jap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Set Reflow Temp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Set_Reflow_temp_jap:
	jnb SELECT_BUTTON, $
	Set_Cursor(1,1)
	Send_Constant_String(#Reflow_temp_jap)
	display_param(reflowtemp) 
	adc_button_jmp(MASTER_STOP, Set_Reflow_temp_jap)

	;if up/down buttons pressed branch and inc/dec params
	jb UP_BUTTON, Decrease_reflowtemp_jap
	Wait_Milli_Seconds(#50)
	jb UP_BUTTON, Decrease_reflowtemp_jap
	jnb UP_BUTTON, $
	mov a, reflowtemp
	add a, #0x01
	cjne a, #0xff, Increase_reflowtemp_loop_jap
	clr a 
	mov reflowtemp, a
	ljmp Set_Reflow_temp_jap
	
Increase_reflowtemp_loop_jap:
	mov reflowtemp, a
	clr a	
	ljmp Set_Reflow_temp_jap	
	
Decrease_reflowtemp_jap:
	jb DOWN_BUTTON, Nextmenu3_jap
	Wait_Milli_Seconds(#50)
	jb DOWN_BUTTON, Nextmenu3_jap
	jnb DOWN_BUTTON, $	
	mov a, reflowtemp
	add a, #0xff
	cjne a, #0x00, Decrease_reflowtemp_loop_jap
	clr a 
	mov reflowtemp, a
	ljmp Set_Reflow_temp_jap
	
Decrease_reflowtemp_loop_jap:
	mov reflowtemp, a
	clr a	
	ljmp Set_Reflow_temp_jap	
Nextmenu3_jap:
	jnb SELECT_BUTTON, Set_Reflow_time_jap 
	ljmp Set_Reflow_temp_jap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Set Reflow Time
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
Set_Reflow_time_jap:
	jnb SELECT_BUTTON, $
	Set_Cursor(1,1)
	Send_Constant_String(#Reflow_time_jap)
	display_param(reflowtime) 
	adc_button_jmp(MASTER_STOP, Set_Reflow_time_jap)

	;if up/down buttons pressed branch and inc/dec params
	jb UP_BUTTON, Decrease_reflowtime_jap
	Wait_Milli_Seconds(#50)
	jb UP_BUTTON, Decrease_reflowtime_jap
	jnb UP_BUTTON, $
	mov a, reflowtime
	add a, #0x01
	cjne a, #0xff, Increase_reflowtime_loop_jap
	clr a 
	mov reflowtime, a
	ljmp Set_Reflow_time_jap
	
Increase_reflowtime_loop_jap:
	mov reflowtime, a
	clr a	
	ljmp Set_Reflow_time_jap
	
Decrease_reflowtime_jap:
	jb DOWN_BUTTON, Nextmenu4_jap
	Wait_Milli_Seconds(#50)
	jb DOWN_BUTTON, Nextmenu4_jap
	jnb DOWN_BUTTON, $	
	mov a, reflowtime
	add a, #0xff
	cjne a, #0x00, Decrease_reflowtime_loop_jap
	clr a 
	mov reflowtime, a
	ljmp Set_Reflow_time_jap
	
Decrease_reflowtime_loop_jap:
	mov reflowtime, a
	clr a	
	ljmp Set_Reflow_time_jap
Nextmenu4_jap:
	jnb SELECT_BUTTON, Custom_menu_loopback_jap
	ljmp Set_Reflow_time_jap
	
Custom_menu_loopback_jap:
	Set_Cursor(1,1)
	Send_Constant_String(#Are_you_sure_jap)
	Set_Cursor(2,1)
	Send_Constant_String(#Clear_Row_jap)
	jnb SELECT_BUTTON, lllaaa_jap_jmp
	sjmp adc_jmp_jap
	lllaaa_jap_jmp: 
		ljmp lllaaa_jap
	adc_jmp_jap: 
	adc_button_jmp(MASTER_STOP, Custom_menu_loopback_jap)
	ljmp Custom_menu_loopback_jap
lllaaa_jap:
	ljmp system_ready_jap
;----------------Custom Menu End----------------;


End
