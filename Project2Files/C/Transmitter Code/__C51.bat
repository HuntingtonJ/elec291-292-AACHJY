@echo off
::This file was created automatically by CrossIDE to compile with C51.
D:
cd "\Users\hunti_000\Documents\repos\elec291group\Project2Files\C\"
"D:\Programs\CrossIDE\Call51\Bin\c51.exe" --use-stdout  "D:\Users\hunti_000\Documents\repos\elec291group\Project2Files\C\Transmitter_src.c"
if not exist hex2mif.exe goto done
if exist Transmitter_src.ihx hex2mif Transmitter_src.ihx
if exist Transmitter_src.hex hex2mif Transmitter_src.hex
:done
echo done
echo Crosside_Action Set_Hex_File D:\Users\hunti_000\Documents\repos\elec291group\Project2Files\C\Transmitter_src.hex
