@echo off
::This file was created automatically by CrossIDE to compile with C51.
C:
cd "\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\"
"C:\CrossIDE\Call51\Bin\c51.exe" --use-stdout  "C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.c"
if not exist hex2mif.exe goto done
if exist EFM8_I2C_Nunchuck_and_motor.ihx hex2mif EFM8_I2C_Nunchuck_and_motor.ihx
if exist EFM8_I2C_Nunchuck_and_motor.hex hex2mif EFM8_I2C_Nunchuck_and_motor.hex
:done
echo done
echo Crosside_Action Set_Hex_File C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\EFM8_I2C_Nunchuck_and_motor.hex
