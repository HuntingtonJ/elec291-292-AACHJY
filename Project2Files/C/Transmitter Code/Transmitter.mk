#Specify Shell
SHELL = cmd

#Specify compiler. Use $(CC) to use c51
CC = c51 

Transmitter_src.hex: Transmitter_src.obj
				$(CC) Transmitter_src.obj
				@echo Dun!
				
Transmitter_src.obj: Transmitter_src.c EFM8UART1lib.h Tcom.h EFM8core.h EFM8LCDlib.h Nunchuck_reader.h
				$(CC) -c Transmitter_src.c
				 
clean:
	@del $(OBJS) *.asm *.lkr *.lst *.map *.hex *.map 2> nul
	
LoadFlash:
	@Taskkill /IM putty.exe /F 2>NUL | wait 500
	EFM8_prog.exe -ft230 -r Transmitter_src.hex
	
explorer:
	explorer .



