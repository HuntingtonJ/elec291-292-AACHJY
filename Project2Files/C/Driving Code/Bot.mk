SHELL=cmd
CC=arm-none-eabi-gcc
AS=arm-none-eabi-as
LD=arm-none-eabi-ld

#Flags for compiling C
CCFLAGS=-mcpu=cortex-m0 -mthumb -g

#Paths for libraries
GCCPATH=$(subst \bin\arm-none-eabi-gcc.exe,\,$(shell where $(CC)))
LIBPATH1=$(subst \libgcc.a,,$(shell dir /s /b "$(GCCPATH)*libgcc.a" | find "v6-m"))
LIBPATH2=$(subst \libc_nano.a,,$(shell dir /s /b "$(GCCPATH)*libc_nano.a" | find "v6-m"))
LIBSPEC=-L"$(LIBPATH1)" -L"$(LIBPATH2)"

OBJS = main.o startup.o

main.elf: $(OBJS)
	$(LD) $(OBJS) $(LIBSPEC) -T stm32f05xxx.ld --cref -Map main.map -nostartfiles -o main.elf
	arm-non-eabi-objcopy -O ihex main.elf main.hex
	@echo Nice!
	
main.o: main.c
	$(CC) -c $(CCFLAGS) main.c -o main.o
	
startup.o: startup.c stm32f05xxx.h serial.h
	$(CC) $(CCFLAGS) startup.c -o startup.o
	
clean:
	del $(OBJS) 
	del main.elf main.hex main.map 2>NUL
	del *.lst
	
Flash_Load:
	STMFlashLoader -c -i STM32F0_5x_3x_64K -e --all -d --fn main.hex --v

# Phony targets can be added to show useful files in the file list of
# CrossIDE or execute arbitrary programs.
dummy: linker_script.ld main.hex
	@echo :-)

explorer:
	@explorer .