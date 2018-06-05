% ___________________________________________________________________________________________
% File:             med_to_tec.m
% File type:        Function
% Created on:       April 15, 2010
% Created by:       Marcelo S. Caetano
% Last revised on:
% Last revised by:
%
% Purpose:          A function to convert a MedPC file into time-event
%                   codes
%
% Input:            fNAME - File name as a string
%                   ST - System timing in MedAssociates
%                   (ST of 500 gives 2 ms samples)
%
% Output:           The output is a two column [Time Event] matrix. Time is
%                   an integer number of X-ms. Event is an integer code.
%
% Coments:          The first part of the code is a small modification of
%                   MedParse.m (written by Kumar Narayanan and Nate Smith)
%
% Format:           Time_event = med_to_tec(File_name)
% Example:          Time_event = med_to_tec('NSC12_112009_VDT')


function Time_event = med_to_tec(fNAME, ST)

flag = 'A';
Time_event = [];
startParse = 2e10;   %bigger than stopParse for error check

fid = fopen(fNAME);
if fid == -1
    fprintf ('\nIncorrect file: %s', fNAME)
    return;
end;

%%Scans the entire line in as a string, with spaces (to preserve number info)
fileString = fscanf(fid, '%c');

%%Finds all the values equal to the parse Flags, and then only keeps the ones with a colon.
tmp = find(fileString == flag);
% make sure tmp is not looking at first or last char of fileString, or else
% will cause error below. first char is an F for Filename, so this will happen
idx = tmp > 1;
tmp = tmp(idx);

for i = 1:size(tmp, 2);
    % letter should be preceded by a new line (ascii code 10 or 13, not sure why MedPC uses both) and followed by a colon
    if (fileString(tmp(i) - 1) == char(13) || fileString(tmp(i) - 1) == char(10) )  && fileString(tmp(i) + 1) == ':'
        startParse = tmp(i);
        break;
    end;
end;
%should error check that only accepts the first colon'ed letter...

% Now search from startParse for next letter. that will be the stop parse
tmp = isletter(fileString(startParse+1:end));
tmp = find(tmp > 0);
% or, may get to end of file, in which case stop should be eof
if isempty(tmp)
    stopParse = length(fileString);
else
	tmp = tmp(1);
    % -1 to remove last offending letter picked up
    stopParse = tmp + startParse - 1;
end

%%if start is greater than stop, or if they are not initialized
if startParse > stopParse
    fprintf ('\n Check your variables');
    return;
end;

%%Clips out the string from the file, does not include flags
parsedString = fileString(startParse + 2:stopParse - 1);

%%Finds all the colons, and deletes them and the number before them
colons = find(parsedString == ':');
for k = 1:size(colons, 2);
    parsedString(colons(k) - 6:colons(k)) = ' ';
end;

% Pulls out the events and saves them as a row of numbers
Events = nan;
Dots = find(parsedString == '.');
for k = 1:size(Dots,2)
   Events(k) =  str2double(parsedString(Dots(k)+1:Dots(k)+3));
end
Events = nonzeros(Events);

% Pulls out the times and saves them as a row of numbers
Times = nan;
Spaces = find(parsedString == ' '); % Find spaces
for i = 1:length(Dots)
    Index = Spaces(find(Dots(i)>Spaces,1,'last'))+1;
    Times(i) = str2double(parsedString(Index:Dots(i)-1));
end
Times = nonzeros(Times);

Time_event = [Times/ST Events];  % TS is time slice in MedAssociates

fclose(fid);
