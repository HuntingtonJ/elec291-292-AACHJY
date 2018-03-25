# Since we are compiling in windows, select 'cmd' as the default shell.  This
# is important because make will search the path for a linux/unix like shell
# and if it finds it will use it instead.  This is the case when cygwin is
# installed.  That results in commands like 'del' and echo that don't work.
SHELL=cmd
# Specify the compiler to use
CC=arm-none-eabi-gcc
# Specify the assembler to use
AS=arm-none-eabi-as
# Specify the linker to use
LD=arm-none-eabi-ld

# Flags for C compilation
CCFLAGS=-mcpu=cortex-m0 -mthumb -g
# Flags for assembly compilation
ASFLAGS=-mcpu=cortex-m0 -mthumb -g
# Flags for linking
#LDFLAGS=-T linker_script.ld -cref -nostartfiles

# Search for the path of the right libraries.  Works only on Windows.
GCCPATH=$(subst \bin\arm-none-eabi-gcc.exe,\,$(shell where $(CC)))
LIBPATH1=$(subst \libgcc.a,,$(shell dir /s /b "$(GCCPATH)*libgcc.a" | find "v6-m"))
LIBPATH2=$(subst \libc_nano.a,,$(shell dir /s /b "$(GCCPATH)*libc_nano.a" | find "v6-m"))
LIBSPEC=-L"$(LIBPATH1)" -L"$(LIBPATH2)"

# List the object files used in this project
OBJS= startup.o main.o serial.o newlib_stubs.o adc.o #init.o

PORTN=$(shell type COMPORT.inc)

# The default 'target' (output) is main.elf and 'depends' on
# the object files listed in the 'OBJS' assignment above.
# These object files are linked together to create main.elf.
# The linked file is converted to hex using program objcopy.
main.hex: $(OBJS) stm32f05xxx.ld
	$(LD) $(OBJS) $(LIBSPEC) -Os -nostdlib -lnosys -lgcc -T stm32f05xxx.ld --cref -nostartfiles -o 
	arm-none-eabi-objcopy -O ihex main.hex #main.elf
	@echo Success!

# main.elf: $(OBJS)
# 	$(LD) $(OBJS) $(LDFLAGS) -Map main.map -nostartfiles -o main.elf
# 	arm-none-eabi-objcopy -O ihex main.elf main.hex
# 	@echo Success!

# The object file main.o depends on main.c. main.c is compiled
# to create main.o.
main.o: main.c stm32f05xxx.h serial.h #newlib_stubs.h
	$(CC) -c $(CCFLAGS) main.c -o main.o

serial.o: serial.c serial.h stm32f05xxx.h
	$(CC) -c $(CCFLAGS) serial.c -o serial.o
	
newlib_stubs.o: newlib_stubs.c
	$(CC) -c $(CCFLAGS) newlib_stubs.c -o newlib_stubs.o

adc.o: adc.c adc.h stm32f05xxx.h
	$(CC) -c $(CCFLAGS) adc.c -o adc.o

USART2.o: USART2.c USART2.h stme32f05xxx.h
	$(CC) -c $(CCFLAGS) USART2.c -o USART2.o

#init.o: init.c serial.h stm32f05xxx.h
# 	$(CC) -c $(CCFLAGS) init.c -o init.o
 	
# The object file startup.o depends on startup.c.  startup.c is
# compiled to create startup.o
startup.o: startup.s stm32f05xxx.h serial.h
	$(AS) $(ASFLAGS) startup.s -asghl=startup.lst -o startup.o

# Target 'clean' is used to remove all object files and executables
# associated wit this project
clean:
	@del $(OBJS) 2>NUL
	@del main.hex 2>NUL	#main.elf main.hex main.map 2>NUL
	@del *.lst 2>NUL

# Target 'Flash_Load' is used to load the hex file to the microcontroller 
# using the flash loader.
Flash_Load:
	@Taskkill /IM putty.exe /F 2>NUL | wait 500
	STMFlashLoader -c -i STM32F0_5x_3x_64K -e --all -d --fn main.hex --v

putty:
	@Taskkill /IM putty.exe /F 2>NUL | wait 500
	c:\putty\putty.exe -serial $(PORTN) -sercfg 115200,8,n,1,N -v

# Phony targets can be added to show useful files in the file list of
# CrossIDE or execute arbitrary programs.
#dummy: linker_script.ld main.hex
#	@echo :-)
	
explorer:
	@explorer .

