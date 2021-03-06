CSEG

; State 0 - menu
; 1 - ramp to soak 
; 2- Soak
; 3- Ramp to reflow
; 4- Reflow
; 5- Cooling 
; 

Reflow_screen mac

	Set_Cursor(1,1)
	Send_Constant_String(#%0)		; display current state

	Set_Cursor(2,9)
	mov a, seconds
	lcall putchar 					;display current time count of state

	Set_Cursor(2, 12)
	Send_Constant_String(#secondsss)

	Set_Cursor(2, 1)
	mov a, temp
	lcall putchar 					;display current temp of state
	
endmac


reflow_state_machine: 

	mov a, reflow_state ;Check current state

	state0: ;Menu/Idle
			cjne a, #0x00, state1
			Set_Cursor(1,1)
			Send_Constant_String(#State_0)
			
			Set_Cursor(2,1)
			Send_Constant_String(#Clear_Row)
			mov TIMER1_RELOAD_H, #DUTY_0 
			;jb MASTER_START, state0_done
			;jnb MASTER_START, $ ; Wait for key release
			;mov reflow_state, #1
		state0_done:
			ljmp forever


	state1: ;Ramp To Soak
			cjne a, #0x01, state2
			setb shortbeepflag			;set flag to choose which beep in isr
			;lcall Timer0_ISR
			clr shortbeepflag	
			mov TIMER1_RELOAD_H, #DUTY_100 
			Reflow_screen(Ramp_to_Soak)
			mov sec, #0
			mov a, soaktemp
			clr c
			subb a, temp
			jnc state1_done 	;if temp>soaktemp then go to state 2 
			mov seconds, #0			; Reset time 'sec' variable representing elapsed time in each state
			mov reflow_state, #0x02
		state1_done:
			
			ljmp forever

	state2: ;Preheat/Soak
			cjne a, #0x02, state3
			setb shortbeepflag			;set flag to choose which beep in isr
			lcall Timer0_ISR
			clr shortbeepflag
			mov TIMER1_RELOAD_H, #DUTY_20 
			Reflow_screen(Soak)
			mov a, soaktime
			clr c
			subb a, seconds
			jnc state2_done
			mov reflow_state, #0x03
			mov seconds, #0			; reset time for state 3
		state2_done:
			ljmp forever

	state3: ;Ramp to Peak
			cjne a, #0x03, state4
			setb shortbeepflag			;set flag to choose which beep in isr
			lcall Timer0_ISR
			clr shortbeepflag
			mov TIMER1_RELOAD_H, #DUTY_100 
			Reflow_screen(Ramp_to_Peak)
			mov a, reflowtemp
			clr c
			subb a, temp
			jnc state3_done 	;if temp>reflowtemp then go to state 4
			mov seconds, #0			; reset time for state 4
			mov reflow_state, #0x04
		state3_done:
			ljmp forever

	state4: ;Reflow/Peak 
			cjne a, #0x04, state5
			setb shortbeepflag			;set flag to choose which beep in isr
			lcall Timer0_ISR
			clr shortbeepflag
			mov pwm, #20		;20% duty
			;mov TIMER1_RELOAD_H, #DUTY_20 
			Reflow_screen(Reflow)
			mov a, reflowtime
			clr c
			subb a, seconds
			jnc state4_done
			mov reflow_state, #0x05
			mov seconds, #0		; reset time for state 5
		state4_done:
			ljmp forever

	state5: ;Cooling -> at end of cooling give 6 beeps
			cjne a, #0x05, state6
			setb longbeepflag			;set flag to choose which beep in isr
			lcall Timer0_ISR
			clr longbeepflag
			mov pwm, #0			; Heater on at 0% duty
			;mov TIMER1_RELOAD_H, #DUTY_0 
			Reflow_screen(Cooling)
			mov a, temp
			subb a, cooled_temp 
			jnc state5_done 	;if temp>reflowtemp then go to state 4
			mov seconds, #0			; reset time for state 4
			mov reflow_state, #0x00
		state5_done:
			ljmp forever
			
	state6: ;Back to Menu/Idle
		setb sixbeepflag			;set flag to choose which beep in isr
		lcall Timer0_ISR
		clr sixbeepflag
		ljmp menu_forever

end

;shortbeepflag:		dbit 1
;longbeepflag:		dbit 1
;sixbeepflag:		dbit 1
