% ___________________________________________________________________________________________
% File:             mpc_to_tec.m
% File type:        function 
% Created on:       May 31st, 2000
% Created by:       Russell Church &Paulo Guilhardi
% Last revised on:  February 22nd, 2001
% Last revised by:  
% 
% Purpose:          A function to convert an mpc file to time_event codes.
% Input:            1. File name as a string
%                   2. Session number as a string
% Output:           The output is a two column [Time Event] matrix.Time is integer 
%                   number of 10-ms units. Event is an integer code.
% Comments:          
% Format:           Time_event = mpc_to_tec(File,Session)
% Example:          Time_event = mpc_to_tec('dq125100','015')
%


function Time_event = mpc_to_tec(File,Session)

File_name = [File '.' Session];
load(File_name);
X = eval(File);
%Include if integer part is > 0; All legitimate times are greater than zero
%Include if remainder part is > 0; All legitimate event codes are greater than zero
%Include if remainder part is less than 62; All legitimate event codes are less than 62
%Include if the remainder contains no more than three digits; All legitimate event codes are 3 digits
Possible_event = round(1000*rem(X,1)); %Possible 3-digit event codes
Recorded_event = 1000*rem(X,1);        %Recorded event codes as real numbers
Epsilon = abs(Possible_event - Recorded_event); %If difference is large, it is not a real event
Time_filter = ((floor(X) > 0) & (Possible_event > 0) & (Possible_event<62) & (Epsilon < .0001));
Data = nonzeros(Time_filter .* X);
Time = floor(Data); Event = round(1000*rem(Data,1)); %Create list of times and events
%Exclude true event codes that are recorded before the beggining of the session
Time_event = [Time/500 Event];

