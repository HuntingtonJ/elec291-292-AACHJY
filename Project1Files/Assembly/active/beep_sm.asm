one_beep mac
	mov beep_state, #1
	mov one_beep_count, %0
	setb TR0
endmac

six_beep:
	mov beep_state, #2
	mov six_beep_count, #6
	mov one_beep_count, #100
	mov six_beep_state, #0
	setb TR0
	ret

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
		cjne a, #1, state_six_beep
		djnz one_beep_count, beep_state_machine_end
		mov beep_state, #0
		clr TR0
		sjmp beep_state_machine_end
		
	state_six_beep:
		cjne a, #2, state_beep_default 
		
		mov a, six_beep_count			;if six_beep_count = 0, exit 6 beeps
		jz state_beep_default
		
		mov a, six_beep_state
		cjne a, #0, six_beep_off
		
		sjmp six_beep_on
		
		six_beep_on:
			;djnz one_beep_count, state_six_beep
			djnz one_beep_count, beep_state_machine_end
			mov one_beep_count, #100
			mov six_beep_state, #1 ;#0
			clr TR0
			lcall delay
			lcall delay
			lcall delay
			;djnz six_beep_count, state_six_beep
			dec six_beep_count
			sjmp beep_state_machine_end
			;djnz six_beep_count, beep_state_machine_end
			;sjmp state_beep_default
			
		six_beep_off:
			;djnz one_beep_count, state_six_beep
			;mov one_beep_count, #40
			mov six_beep_state, #0
			;lcall delay
			;lcall delay
			;lcall delay
			lcall WaitHalfSec
			setb TR0
			sjmp beep_state_machine_end
			;djnz six_beep_count, state_six_beep
		
	state_beep_default:
		clr TR0
		mov beep_state, #0
		
	beep_state_machine_end:
	ret
	
end













