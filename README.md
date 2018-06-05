# MedParse

Reads MedPC data into python and matlab

### Requirements for MedPC file

See <a href = "https://www.med-associates.com/med-nr/storing-events-v0-1/"> Storing All Events (Procedure) </a>

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
