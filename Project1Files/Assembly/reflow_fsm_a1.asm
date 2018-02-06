CSEG

; State 0 - menu
; 1 - ramp to soak 
; 2- Soak
; 3- Ramp to reflow
; 4- Reflow
; 5- Cooling 
; 

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
	mov a, #11011111b			; trying to display the special "degree" symbol 
	lcall putchar 	
endmac



reflow_state_machine: 

	mov a, reflow_state

	state0:
			cjne a, #0, state1
			mov pwm, #0
			ljmp Main_Menu_Program
			jb MASTER_START, state0_done
			jnb MASTER_START, $ ; Wait for key release
			mov reflow_state, #1
		state0_done:
			ljmp forever


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
			mov reflow_state, #2
		state1_done:
			ljmp forever

	state2:
			cjne a, #2, state3
			mov pwm, #20		;20% duty
			Reflow_screen(Soak)
			mov a, soaktime
			clr c
			subb a, sec
			jnc state2_done
			mov reflow_state, #3
			mov sec, #0			; reset time for state 3
		state2_done:
			ljmp forever

	state3:
			cjne a, #3, state4
			mov pwm, #100		; Heater on at 100% duty
			Reflow_screen(Ramp_to_Peak)
			mov a, reflowtemp
			clr c
			subb a, temp
			jnc state3_done 	;if temp>reflowtemp then go to state 4
			mov sec, #0			; reset time for state 4
			mov reflow_state, #4
		state3_done:
			ljmp forever

	state4:
			cjne a, #4, state5
			mov pwm, #20		;20% duty
			Reflow_screen(Reflow)
			mov a, reflowtime
			clr c
			subb a, sec
			jnc state4_done
			mov reflow_state, #5
			mov sec, #0		; reset time for state 5
		state4_done:
			ljmp forever

	state5:
			cjne a, #5, state6
			mov pwm, #0			; Heater on at 100% duty
			Reflow_screen(Cooling)
			mov a, cooled_temp
			clr c
			subb a, temp
			jnc state5_done 	;if temp>reflowtemp then go to state 4
			mov sec, #0			; reset time for state 4
			mov reflow_state, #0
		state5_done:
			ljmp forever
			
	state6:
		ljmp state0

			end