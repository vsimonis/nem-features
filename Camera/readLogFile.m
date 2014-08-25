function [ C ] = readLogFile( env )
%READLOGFILE Summary of this function goes here
%   Detailed explanation goes here



env.LogFileName = 'N2_no_food-Thu_14_Aug_2014-150527.log';
env.VideoInputDir = 'C:\Users\vsimonis\Documents\MATLAB\Elegans\N2-1\';
fname = sprintf('%s%s', env.VideoInputDir, env.LogFileName );
%readLogFile(fname);
fid = fopen(fname);
T= textscan( fid, '%s%s%s%*s%s%s%s', 'delimiter', '\t','EndOfLine', '\n');
T = [ T{1}, T{2}, T{3}, T{4}, T{5}, T{6} ];

end