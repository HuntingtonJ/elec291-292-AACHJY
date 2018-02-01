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
   ljmp MainProgram

; These ’EQU’ must match the wiring between the microcontroller and ADC
SOUND_OUT   EQU P3.7
CE_ADC      EQU P2.4
MY_MOSI     EQU P2.5
MY_MISO     EQU P2.6
MY_SCLK     EQU P2.7
UP_BUTTON	EQU P0.0
DOWN_BUTTON EQU P0.2
SELECT_BUTTON EQU P0.5
NEXT_BUTTON EQU P0.7
BACK_BUTTON EQU p0.3
MASTER_START_STOP equ p0.4


DSEG at 0x30
Count1ms:      ds 2 ; Used to determine when half second has passed
Result: ds 2
x:      ds 4
y:      ds 4
bcd:    ds 5
soaktime: ds 1
soaktemp: ds 1
reflowtime: ds 1
reflowtemp: ds 1
soaktemp3digit: ds 1


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

$NOLIST
$include(menu_code.inc) 
$LIST

;                     1234567890123456    <- This helps determine the location of the counter
Welcome: 		  db 'Welcome!        ', 0
Choose_option: 	  db 'Select option   ', 0
Preset_menu:	  db 'Preset Profile  ', 0
Custom_menu: 	  db 'Custom Profile  ', 0
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

WaitHalfSec:
    mov R2, #45
Wait3: mov R1, #250
Wait2: mov R0, #166
Wait1: djnz R0, Wait1 ; 3 cycles->3*45.21123ns*166=22.51519us
    djnz R1, Wait2 ; 22.51519us*250=5.629ms
    djnz R2, Wait3 ; 5.629ms*89=0.5s (approximately)
    ret

;UP_BUTTON	EQU P0.0
;DOWN_BUTTON EQU P0.2
;SELECT_BUTTON EQU P0.5
;BACK_BUTTON p0.7

MainProgram:
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

	ljmp Initial_menu	

Custom_menu:
Forever: 
	Set_Cursor(1, 1)
    Send_Constant_String(#Custom_menu)
    Set_Cursor(2, 1)
    Send_Constant_String(#Clear_Row)
	;Wait until select button is pressed then loop to options
	jnb SELECT_BUTTON, Set_Soak_temp
	Wait_Milli_Seconds(#50)
	jnb SELECT_BUTTON, Set_Soak_temp
	;jb SELECT_BUTTON, $
	sjmp Forever	
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
	ljmp Forever



;----------------Main Menu Logic----------------;


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
	
End
	
	
	

	

	


