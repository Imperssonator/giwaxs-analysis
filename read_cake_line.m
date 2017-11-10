function linecut = read_cake_line(filename, startRow, endRow)
%IMPORTFILE1 Import numeric data from a text file as column vectors.
%   [Q1,TTHRAD,TTHDEG,DRPX,IQ] = IMPORTFILE1(FILENAME) Reads data from text
%   file FILENAME for the default selection.
%
%   [Q1,TTHRAD,TTHDEG,DRPX,IQ] = IMPORTFILE1(FILENAME, STARTROW, ENDROW)
%   Reads data from rows STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   [Q1,Tthrad,Tthdeg,dRpx,IQ] = importfile1('NP_2day_sonicated_parallel_12111644_0001.tif line100.csv',3, 620);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2017/03/22 18:31:27

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 3;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
Q1 = dataArray{:, 1};
Tthrad = dataArray{:, 2};
Tthdeg = dataArray{:, 3};
dRpx = dataArray{:, 4};
IQ = dataArray{:, 5};

linecut.Q=Q1;
linecut.I=IQ;

end


