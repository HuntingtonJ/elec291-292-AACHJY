SHELL=cmd
CC=c51
COMPORT = $(shell type COMPORT.inc)
OBJS=EFM8_I2C_Nunchuck.obj motor_control.obj

EFM8_I2C_Nunchuck.hex: $(OBJS)
	$(CC) $(OBJS)
	@echo Done!
	
EFM8_I2C_Nunchuck.obj: EFM8_I2C_Nunchuck.c
	$(CC) -c EFM8_I2C_Nunchuck.c

#motor_control.obj: motor_control.c
#	$(CC) -c motor_control.c

clean:
	@del $(OBJS) *.asm *.lkr *.lst *.map *.hex *.map 2> nul

LoadFlash:
	@Taskkill /IM putty.exe /F 2>NUL | wait 500
	EFM8_prog.exe -ft230 -r EFM8_I2C_Nunchuck.hex
	cmd /c start c:\PUTTY\putty -serial $(COMPORT) -sercfg 115200,8,n,1,N -v

putty:
	@Taskkill /IM putty.exe /F 2>NUL | wait 500
	cmd /c start c:\PUTTY\putty -serial $(COMPORT) -sercfg 115200,8,n,1,N -v

Dummy: EFM8_I2C_Nunchuck.hex EFM8_I2C_Nunchuck.Map
	@echo Nothing to see here!
	
explorer:
	cmd /c start explorer .
		