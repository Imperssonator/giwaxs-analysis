function [csv_file,D]=analyze_giwaxs_dir(dirPath,Imin,Imax)

% Input:
% dirPath: a folder path terminated with a /
% Example: '/Users/Imperssonator/Google Drive/GIWAXS/Data/'
% Hopefully this folder has data that has been 

% Output:
% csv_file: the path to a csv file that is saved in the folder specified in
% dirPath

% Build directory
ad=pwd;
cd(dirPath),
D=dir('*.tif')
cd(ad)

extn = {' cake_rows.csv';...
        ' line010.csv';...
        ' line100.csv';...
        ' line_amorph.csv';...
        'whole image.bin'...
        };

% Add raw data to dir struct

for i = 1:length(D)
%     D(i).img = imread([dirPath, 'pics/', D(i).name, extn{5}]);
    disp(D(i).name)
    D(i).cake = read_cake_csv([dirPath, 'pics/', D(i).name, extn{1}]);
    D(i).line010 = read_cake_line([dirPath, 'pics/', D(i).name, extn{2}]);
    D(i).line100 = read_cake_line([dirPath, 'pics/', D(i).name, extn{3}]);
    D(i).line_amorph = read_linecut([dirPath, 'pics/', D(i).name, extn{4}]);
    make_giwaxs_image([dirPath, 'pics/', D(i).name, extn{5}], Imin, Imax);
end

% Perform analysis

for i = 1:length(D)
    D(i).cake = analyze_cake(D(i).cake);
    D(i).line100 = analyze_100(D(i).line100);
    D(i).line010 = analyze_010(D(i).line010);
end

% Save as csv

csv_file=[dirPath, 'results.csv'];
csv_compact=[dirPath, 'results_compact.csv'];
csv_struct=struct();
for i = 1:length(D)
    csv_struct(i).Name = D(i).name;
    csv_struct(i).d100 = D(i).line100.d100;
    csv_struct(i).Size100 = D(i).line100.GrainSize;
    csv_struct(i).Hermans = D(i).cake.Hermans;
    csv_struct(i).d010 = D(i).line010.d010;
    csv_struct(i).line100 = [D(i).line100.Q'; D(i).line100.I'];
    csv_struct(i).line010 = [D(i).line010.Q'; D(i).line010.I'];
end

struct2csv(csv_struct,csv_file);

rcell = cell(length(D),5);
rcell{1,1} = 'Name';
rcell{1,2} = 'd100';
rcell{1,3} = 'Size100';
rcell{1,4} = 'Hermans';
rcell{1,5} = 'd010';

for i = 1:length(D)
    rcell{i+1,1} = csv_struct(i).Name;
    rcell{i+1,2} = csv_struct(i).d100;
    rcell{i+1,3} = csv_struct(i).Size100;
    rcell{i+1,4} = csv_struct(i).Hermans;
    rcell{i+1,5} = csv_struct(i).d010;
end

cell2csv(csv_compact,rcell);

end
