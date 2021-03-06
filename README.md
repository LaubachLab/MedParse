# MedParse

Functions to read MedPC data into python and matlab <br>
Files: <br>
mpc_to_tec.m  -> MATLAB Original file provided by Russell Church and Paulo Guilhardi, May 2000<br>
med_to_tec.m  -> MATLAB Updated version by Marcelo Cetano, April 2010<br>
med_to_tec.py -> PYTHON Translated to python by Kyra Swanson, January 2015<br>
2015-09-25_ML03 -> Example MedPC data file containing raw time-event codes <br>
MEDPC Template  -> Standard MedPC event codes and saving conventions used in our lab<br>


### Requirements for MedPC file


Set a timing variable (eg U) to the internal time to set a baseline 
and set another as an index placeholder (eg Y). A separate index holder is needed for each data array

#Start: Set U = BTIME, Y = 0, K = 0; 


<b> Set variables to arrays to hold times: </b>

DIM A=9999, B=3, L=9999


<b> Save variables as they occur into the arrays: </b>

This example saves lick times into array L 

s.s.X, <br>
    s1, <br>
            #Start: ---> s2 \this prevents licks from being recorded before initialization of the session <br>
    s2, <br>
            #R^LICK:   Set L(K) = BTIME-U; Add K; ---> SX <br>

This example saves event times and the code corresponding to the event. 
The element is saved as TIME.EVENTCODE.  For example, OnPumpA = 11 and if 
OnPumpA occurs at exactly 536 seconds from start will be recorded as 268000.011

s.s.X, <br>
    s1, <br>
        #Z^OnPumpA:   Set A(Y) = BTIME-U + (^OnPumpA)/1000; Add Y; --->sx <br>
        #Z^OffPumpA:  Set A(Y) = BTIME-U + (^OffPumpA)/1000; Add Y; --->sx <br>


### Example File (2015-09-25_ML03)

The following codes correspond to the following events in this example:

Lick = 1   (.001)

PumpA <br>
ON = 11 (.011) <br>
OFF = 21 (.021) <br>

PumpB <br>
ON = 12 (.012) <br>
OFF = 22 (.022) <br>

Low concentration = 50  (0.050) <br>
High concentration = 51 (0.051) <br>     
Shift = 52              (0.052) <br>
