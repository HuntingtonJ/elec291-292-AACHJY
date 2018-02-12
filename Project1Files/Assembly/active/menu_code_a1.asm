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
	
;Similar structure to button_jmp mac
;takes a channel byte for Get_ADC_Channel and 
;and exit vector/label
adc_button_jmp mac
	Get_ADC_Channel(%0)  	; loads ADC_Result (16 bit) with voltage value of pressed button 
	mov a, ADC_Result+0
	cjne a, #0, wait_release_%M

	sjmp endhere_%M
wait_release_%M:
	Get_ADC_Channel(%0)  	; loads ADC_Result (16 bit) with voltage value of pressed button 
	mov a, ADC_Result+0
	cjne a, #0,wait_release_%M
	ljmp %1
	endhere_%M:
endmac

;Pressed value will be greater than ref voltage, resulting in all 10 bits being 1.

;--------------------------------;
;	Takes a channel byte         ;
;                                ;
;   0 - #10000000B               ;
;   1 - #10010000B               ;
;   2 - #10100000B               ;
;   3 - #10110000B               ;
;   4 - #11000000B               ;
;   5 - #11010000B               ;
;   6 - #11100000B               ;
;   7 - #11110000B               ;
;                                ;
;   Stores the value in          ; 
;   ADC_Result.                  ;
;   When used with buttons,      ;
;   just check if the lower      ;
;   byte is 255.                 ;
;--------------------------------;
Get_ADC_Channel mac
	clr CE_ADC         ; selects 
    mov R0, #00000001B ; Start bit: 1
    lcall DO_SPI_G
    
    mov R0, %0 ; Read channel
    lcall DO_SPI_G
    mov a, R1
    anl a, #00000011B
    mov ADC_Result+1, a    ; Save high result
    
    mov R0, #55H
    lcall DO_SPI_G
    mov ADC_Result+0, R1     ; Save low result
    
    setb CE_ADC        ; deselects
    
    ;V_OUT = ADC_voltage*4.096V/1023
    mov x+0, ADC_Result
    mov x+1, ADC_Result+1
    mov x+2, #0
    mov x+3, #0
    
    Load_y(4091)
    lcall mul32 ;multiplies x *= y
    
    Load_y(1023)
    lcall div32 ;divides x /= y
    
    Load_y(1000)
    lcall div32
    
    mov ADC_Result+1, x+1
    mov ADC_Result+0, x+0

endmac

;---------------------------
;Function to get BCD from 8 bit number stored in accumulator 
; input: accumulator 
; output: R1 R0 BCD 
;---------------------------
BCD_from_8_bits: 
mov b, #100
div ab 
mov R1, a 
mov a, b 
mov b, #10
div ab
swap a 
orl a, b 
mov R0, a

ret

;-------------------------------------------
;Macro to display binary number as BCD 
; Input: 8 bit binary number, either in variable or direct
; Output: display at specified location 
;---------------------------------------------

Display_8bit_to_BCD mac
mov a, %0
lcall BCD_from_8_bits
Set_Cursor(2, 1)
mov a, r1
Display_BCD(a)
Set_Cursor(2, 3)
mov a, r0
Display_BCD(a)
endmac

;-------------------------------------
; A macro to be used in custom menu to display the 3 digit value of the 
; input;  variable name
; outputs a display on the LCD screen at (2, 1) to (2, 4)
; ------------------------------------

display_param mac
mov a, %0
mov b, #100
div ab 
mov R1, a 
mov a, b 
mov b, #10
div ab
swap a 
orl a, b 
mov R0, a
mov display_scratch, r1

	Set_Cursor(2,1)
	Display_BCD(display_scratch)

	mov display_scratch, r0
	Set_Cursor(2,3)
	Display_BCD(display_scratch)
endmac


Main_Menu_Program:
	;Set all vars initally to zero
	mov soaktime, #0x00
	mov soaktemp, #0x00
	mov reflowtime, #0x00
	mov reflowtemp, #0x00
	;display initial menu messages	

	sjmp Initial_menu	


;----------------Main Menu Logic----------------;


Initial_menu: 
	Set_Cursor(1, 1)
    Send_Constant_String(#Welcome)
    Set_Cursor(2, 1)
    Send_Constant_String(#Choose_option)
	
    ;------------- any button being pressed will change the screen
    button_jmp(SELECT_BUTTON, Choose_menu)
    button_jmp(UP_BUTTON, Choose_menu)
    button_jmp(DOWN_BUTTON, Choose_menu)
    adc_button_jmp(BACK_BUTTON, Choose_menu)
    ljmp Initial_menu

system_ready: 
	Set_Cursor(1,1)
	Send_Constant_String(#Is_ready)
	Set_Cursor(2,1)
	Send_Constant_String(#Press_start)

	adc_button_jmp(BACK_BUTTON, Choose_menu)
	button_jmp(SELECT_BUTTON, Confirm_menu)
	adc_button_jmp(MASTER_START, Confirm_menu)

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


Loaded_param: 			; All parameters are loaded correctly, time to start!

	;Then check if the state=1. If so, goto reflow FSM
	;mov a, reflow_state
	;cjne a, #1, state_error

	mov a, #0x01
	mov reflow_state, a
	one_beep(#40)
	
	ljmp forever 		; jumps to main loop to grab temp data so the state machine is not operating with garbage values


	;------------------------------Menu options below----------------------------

Choose_menu: 
	Set_Cursor(1,1)
	Send_Constant_String(#Preset_menu_msg)
	Set_Cursor(2,1)
	Send_Constant_String(#Custom_menu_msg)

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
	adc_button_jmp(BACK_BUTTON, Choose_menu) ; have we determined if we are using a back button or a next button? What is the purpose of a next button? 

	ljmp Preset_menu_select

Custom_menu_select: 
	;Remove messages when blinking cursor is set up
	Set_Cursor(1,1)
	Send_Constant_String(#CUSTOMMENUMSG)
	Set_Cursor(2,1)
	Send_Constant_String(#Clear_Row)
	
	button_jmp(UP_BUTTON, Preset_menu_select)
	button_jmp(SELECT_BUTTON, Custom_menu)
	adc_button_jmp(BACK_BUTTON, Choose_menu)

	ljmp Custom_menu_select

;------------------ Preset Menu start----------------------------------;
Preset_menu: 
	Set_Cursor(1,1)
	Send_Constant_String(#Pb_free_solder)
	Set_Cursor(2,1)
	Send_Constant_String(#Pb_solder)


	button_jmp(UP_BUTTON, pb_free_select)
	button_jmp(DOWN_BUTTON, pb_select)
	adc_button_jmp(BACK_BUTTON, Choose_menu)

	ljmp Preset_menu

pb_free_select: 
	button_jmp(DOWN_BUTTON, pb_select)
	button_jmp(SELECT_BUTTON, pb_free_solder_set)
	adc_button_jmp(BACK_BUTTON, Choose_menu)

	ljmp pb_free_select

pb_select: 
	button_jmp(UP_BUTTON, pb_free_select)
	button_jmp(SELECT_BUTTON, pb_solder_set)
	adc_button_jmp(BACK_BUTTON, Choose_menu)

	ljmp pb_select


pb_solder_set: 		; for soldering with the Sn63Pb37 alloy	
	Set_Cursor(1,1)
	Send_Constant_String(#Pb_solder)
	Set_Cursor(2,1)
	Send_Constant_String(#Profile_loaded)
	mov soaktime, #120
	mov soaktemp, #150
	mov reflowtime, #20
	mov reflowtemp, #230

	ljmp system_ready

pb_free_solder_set: 	;for soldering SAC305 lead-free solder 
	Set_Cursor(1,1)
	Send_Constant_String(#Pb_free_solder)
	Set_Cursor(2,1)
	Send_Constant_String(#Profile_loaded)
	
	mov soaktime, #120
	mov soaktemp, #160
	mov reflowtime, #15
	mov reflowtemp, #245
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
	adc_button_jmp(BACK_BUTTON,Custom_to_Choose_menu)
	ljmp Custom_menu	
Custom_to_Choose_menu:
	ljmp Choose_menu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Set Soak Temp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
Set_Soak_temp:	
	Set_Cursor(1,1)
	Send_Constant_String(#Soak_temp)

	; display soaktemp as 3 digit bcd from 8 bit value
	display_param(soaktemp) 


	;if up/down buttons pressed branch and inc/dec params
	jb UP_BUTTON, Decrease_soaktemp
	Wait_Milli_Seconds(#50)
	jb UP_BUTTON, Decrease_soaktemp
	jnb UP_BUTTON, $
	mov a, soaktemp
	add a, #0x01
	cjne a, #0xff, Increase_soaktemp_loop
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
	add a, #0xff
	cjne a, #0x00, Decrease_soaktemp_loop
	clr a 
	mov soaktemp, a
	ljmp Set_Soak_temp
	
Decrease_soaktemp_loop:
	mov soaktemp, a
	clr a	
	ljmp Set_Soak_temp	
Nextmenu1:
	jnb SELECT_BUTTON, Set_Soak_time
	ljmp Set_Soak_temp	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Set Soak Time
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Set_Soak_time:
	jnb SELECT_BUTTON, $
	Set_Cursor(1,1)
	Send_Constant_String(#Soak_time)
	display_param(soaktime) 
	;if up/down buttons pressed branch and inc/dec params

	jb UP_BUTTON, Decrease_soaktime
	Wait_Milli_Seconds(#50)
	jb UP_BUTTON, Decrease_soaktime
	jnb UP_BUTTON, $
	mov a, soaktime
	add a, #0x01
	cjne a, #0xff, Increase_soaktime_loop
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
	add a, #0xff
	cjne a, #0x00, Decrease_soaktime_loop
	clr a 
	mov soaktime, a
	ljmp Set_Soak_time
	
Decrease_soaktime_loop:
	mov soaktime, a
	clr a	
	ljmp Set_Soak_time	
Nextmenu2:
	jnb SELECT_BUTTON, Set_Reflow_temp 
	ljmp Set_Soak_time
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Set Reflow Temp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Set_Reflow_temp:
	jnb SELECT_BUTTON, $
	Set_Cursor(1,1)
	Send_Constant_String(#Reflow_temp)
	display_param(reflowtemp) 

	;if up/down buttons pressed branch and inc/dec params
	jb UP_BUTTON, Decrease_reflowtemp
	Wait_Milli_Seconds(#50)
	jb UP_BUTTON, Decrease_reflowtemp
	jnb UP_BUTTON, $
	mov a, reflowtemp
	add a, #0x01
	cjne a, #0xff, Increase_reflowtemp_loop
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
	add a, #0xff
	cjne a, #0x00, Decrease_reflowtemp_loop
	clr a 
	mov reflowtemp, a
	ljmp Set_Reflow_temp
	
Decrease_reflowtemp_loop:
	mov reflowtemp, a
	clr a	
	ljmp Set_Reflow_temp	
Nextmenu3:
	jnb SELECT_BUTTON, Set_Reflow_time 
	ljmp Set_Reflow_temp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			Set Reflow Time
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
Set_Reflow_time:
	jnb SELECT_BUTTON, $
	Set_Cursor(1,1)
	Send_Constant_String(#Reflow_time)
	display_param(reflowtime) 

	;if up/down buttons pressed branch and inc/dec params
	jb UP_BUTTON, Decrease_reflowtime
	Wait_Milli_Seconds(#50)
	jb UP_BUTTON, Decrease_reflowtime
	jnb UP_BUTTON, $
	mov a, reflowtime
	add a, #0x01
	cjne a, #0xff, Increase_reflowtime_loop
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
	add a, #0xff
	cjne a, #0x00, Decrease_reflowtime_loop
	clr a 
	mov reflowtime, a
	ljmp Set_Reflow_time
	
Decrease_reflowtime_loop:
	mov reflowtime, a
	clr a	
	ljmp Set_Reflow_time
Nextmenu4:
	jnb SELECT_BUTTON, Custom_menu_loopback
	ljmp Set_Reflow_time
	
Custom_menu_loopback:
	Set_Cursor(1,1)
	Send_Constant_String(#Are_you_sure)
	Set_Cursor(2,1)
	Send_Constant_String(#Clear_Row)
	jnb UP_BUTTON, lllaaa
	ljmp Custom_menu_loopback
lllaaa:
	ljmp system_ready
;----------------Custom Menu End----------------;


End