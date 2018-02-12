#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Feb 11 17:39:45 2018

@author: abdoelhosary
"""
Graph_Flag=2

import serial
import serial.tools.list_ports
PORT = 'COM1'
try:
   ser.close();
except:
   print();
try:
    ser = serial.Serial(PORT, 115200, timeout=100)
except:
    print ('Serial port %s is not available' % PORT); portlist=list(serial.tools.list_ports.comports())
    print('Trying with port %s' % portlist[0][0]);
    ser = serial.Serial(portlist[0][0], 115200, timeout=100)
    ser.isOpen()

count=0  
paramters_array=[] 
 
handshake=ser.readline()
if handshake==1:
    Graph_Flag=0
    
while (Graph_Flag==0) :
    paramters_array[count] = ser.readline();
    print(paramters_array[count].decode('ascii')); #Testing to see if right paramters are beng sent
         
    if paramters_array[count]==0:
        Graph_Flag=1
    count+=1
    
while (Graph_Flag==1) :
    strin = ser.readline();
    print(strin.decode('ascii'));