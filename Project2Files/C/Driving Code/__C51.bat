@echo off
::This file was created automatically by CrossIDE to compile with C51.
C:
cd "\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\"
"C:\CrossIDE\Call51\Bin\c51.exe" --use-stdout  "C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\motor control.c"
if not exist hex2mif.exe goto done
if exist motor control.ihx hex2mif motor control.ihx
if exist motor control.hex hex2mif motor control.hex
:done
echo done
echo Crosside_Action Set_Hex_File C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Driving Code\motor control.hex
