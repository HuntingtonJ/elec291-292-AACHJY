#Specify Shell
SHELL = cmd

#Specify compiler. Use $(CC) to use c51
CC = c51 

Transmitter_src.hex: Transmitter_src.obj
				$(CC) Transmitter_src.obj
				@echo Dun!
				
Transmitter_src.obj: Transmitter_src.c Tcom.h EFM8LCDlib.h
				$(CC) -c Transmitter_src.c
				
clean:
	@del $(OBJS) *.asm *.lkr *.lst *.map *.hex *.map 2> nul
	
LoadFlash:
	EFM8_prog.exe -ft230 -r Transmitter_src.hex
	
explorer:
	explorer .



