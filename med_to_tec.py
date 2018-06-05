# -*- coding: utf-8 -*-
"""
% File:             med_to_tec.py
% File type:        Function
% Created on:       Jan 5, 2015
% Created by:       Kyra Swanson
% Last revised on:  Jun 5, 2018
% Last revised by:  Kyra Swanson

Converts MedPC file into list of [time,event] codes

Based on med_to_tec.m
Created by Marcelo S. Caetano

Requires Time-Event pairs to be saved as:
TIME.EVENT
For example, an event 1 at exactly 536 seconds from start will be recorded as 
268000.001
Currently, the system clocks at 2ms, so time codes are divided by 500 
to convert them to seconds.
Events are converted to integers.
The final product for this event is 
[536,1]

"""
import numpy as np
import re

#convert time to seconds (BTIME at 2ms, 500/sec)
timeslice = 500
# timeslice = 200 (old files timeslice at 5ms = 200)



#convert a .med file into a readable format 
def cleanLines(item):
    start = item.index(":") + 1
    item = item[start:]
    item = item.replace("\n","")
    item = item.split()
    return item

def breakLine(lines):
    Time_Event = []
    for item in lines:
        for el in item:
            temp = el.split(".")
            if temp[0] != "0":
                temp[0] = float(temp[0])/timeslice
                temp[1] = float(temp[1])
                Time_Event.append(temp)
    return np.asarray(Time_Event)    
    
def convert(fileName,variable = "A"):
    fid = open(fileName) #open file
    lines = fid.readlines() #store lines in list
    fid.close()
    
    flag = variable + ":\n" #find variable flag (eg A:)
    start_index = next(i for i,x in enumerate(lines) if x == flag) + 1 
    lines = lines[start_index:]
    stop_index = 0
    
    while not (re.search('[a-zA-Z]', lines[stop_index])): #stops at the next variable or comment
        lines[stop_index] = cleanLines(lines[stop_index]) #clean lines
        stop_index +=  1
    
    lines = lines[:stop_index]
    TEC = breakLine(lines) #break lines, store time,event in list Time_Event
    return TEC
    


#****************************************************************************    
#   PULLING OUT DATA    
    
#returns times for a given code    
def findTimes(EV,code):
    return [val[0] for (i,val) in enumerate(EV) if val[1] == code] 
    
#Returns the value for a given variable
def findVariable(fileName,variable):
    fid = open(fileName)
    lines = fid.readlines()
    fid.close()
    
    for i,j in enumerate(lines):
        if j[0] == variable:
            answer = lines[i]
    
    answer = answer[:-5]
    start = re.search("\d", answer).start()
    return int(answer[start:])    
    





