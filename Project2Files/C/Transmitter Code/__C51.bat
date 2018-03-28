@echo off
::This file was created automatically by CrossIDE to compile with C51.
C:
cd "\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Transmitter Code\"
"C:\CrossIDE\Call51\Bin\c51.exe" --use-stdout  "C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Transmitter Code\Transmitter_src.c"
if not exist hex2mif.exe goto done
if exist Transmitter_src.ihx hex2mif Transmitter_src.ihx
if exist Transmitter_src.hex hex2mif Transmitter_src.hex
:done
echo done
echo Crosside_Action Set_Hex_File C:\Users\carso\Documents\1. School\0. Spring 2018\Elec 292\project1\elec291-292-AACHJY\Project2Files\C\Transmitter Code\Transmitter_src.hex
