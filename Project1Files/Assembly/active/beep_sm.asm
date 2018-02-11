beep_machine_init:
	clr TR0
	mov beep_state, #0
	mov one_beep_count, #0
	ret

beep_state_machine:
	
	mov a, beep_state
	
	state_no_beep:
		cjne a, #0, state_one_beep
		sjmp beep_state_machine_end
		
	state_one_beep:
		cjne a, #1, state_beep_default
		djnz one_beep_count, beep_state_machine_end
		mov beep_state, #0
		clr TR0
		
	state_beep_default:
		mov beep_state, #0
		
	beep_state_machine_end:
	ret
	
one_beep:
	mov beep_state, #1
	mov one_beep_count, #40
	setb TR0
	ret
	
end