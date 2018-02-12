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
	;lcall putchar 					;display current time count of state

	Set_Cursor(2, 12)
	Send_Constant_String(#secondsss)

	Set_Cursor(2, 1)
	mov a, temp
	;lcall putchar 					;display current temp of state
	
endmac


reflow_state_machine: 
	Get_ADC_Channel(MASTER_STOP) ; master stop voltage in ADC_Result
	mov a, ADC_Result				; stop high when pressed 
	;cpl TR0
	cjne a, #0, abort_reflow
	sjmp start_fsm
	
	abort_reflow: 
		Set_Cursor(1,1)
		Send_Constant_String(#abort_msg)
		mov reflow_state, #0x05
	
	start_fsm:
	mov a, reflow_state ;Check current state

	state0: ;Menu/Idle
			cjne a, #0x00, state1
			Set_Cursor(1,1)
			Send_Constant_String(#State_0)
			Set_Cursor(2,1)
			Send_Constant_String(#Clear_Row)
			mov TIMER1_RELOAD_H, #DUTY_0 
			ljmp Main_Menu_Program 
		state0_done:
			ljmp forever


	state1: ;Ramp To Soak
			cjne a, #0x01, state2
			mov TIMER1_RELOAD_H, #DUTY_100 
			Reflow_screen(Ramp_to_Soak)
			mov sec, #0
			mov a, soaktemp
			clr c
			subb a, Result_Thermo
			jnc state1_done 	;if temp>soaktemp then go to state 2 
			mov seconds, #0			; Reset time 'sec' variable representing elapsed time in each state
			mov reflow_state, #0x02
			one_beep(#40)
		state1_done:
			
			ljmp forever

	state2: ;Preheat/Soak
			cjne a, #0x02, state3jmp
			sjmp state2go
		state3jmp: 
			ljmp state3
		state2go:
			mov TIMER1_RELOAD_H, #DUTY_20 
			Reflow_screen(Soak)
			Display_8bit_to_BCD(seconds)
			mov a, soaktime
			clr c
			subb a, seconds
			jnc state2_done
			mov reflow_state, #0x03
			one_beep(#40)
			mov seconds, #0			; reset time for state 3
		state2_done:
			ljmp forever

	state3: ;Ramp to Peak
			cjne a, #0x03, state4jmp
			sjmp state3go
		state4jmp: 
			ljmp state4
		state3go:
			Display_8bit_to_BCD(seconds)
			mov TIMER1_RELOAD_H, #DUTY_100 
			Reflow_screen(Ramp_to_Peak)
			mov a, reflowtemp
			clr c
			subb a, Result_Thermo
			jnc state3_done 	;if temp>reflowtemp then go to state 4
			mov seconds, #0			; reset time for state 4
			mov reflow_state, #0x04
			one_beep(#40)
		state3_done:
			ljmp forever

	state4: ;Reflow/Peak 
			cjne a, #0x04, state5jmp
			sjmp state4go
		state5jmp: 
			ljmp state5
			
		state4go:
			mov TIMER1_RELOAD_H, #DUTY_20 
			Reflow_screen(Reflow)
			Display_8bit_to_BCD(seconds)
			mov a, reflowtime
			clr c
			setb state4_flag
			subb a, seconds
			jnc state4_done
			clr state4_flag
			mov reflow_state, #0x05
			one_beep(#200)
			mov seconds, #0		; reset time for state 5
			
		state4_done:
			ljmp forever

	state5: ;Cooling -> at end of cooling give 6 beeps
			cjne a, #0x05, state6jmp
			sjmp state5go
		state6jmp:
			ljmp state6
		state5go: 
			mov TIMER1_RELOAD_H, #DUTY_0 
			Reflow_screen(Cooling)
			Display_8bit_to_BCD(seconds)
			mov a, Result_Thermo
			clr c
			subb a, cooled_temp 
			jnc state5_done 	;if temp>reflowtemp then go to state 4
			mov seconds, #0			; reset time for state 4
			mov reflow_state, #0x06
			one_beep(#40)
		state5_done:
			ljmp forever
			
	state6: ;Back to Menu/Idle
		mov reflow_state, #0x00

		ljmp forever

end

;shortbeepflag:		dbit 1
;longbeepflag:		dbit 1
;sixbeepflag:		dbit 1
