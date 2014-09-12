function [ nada ] = pathPlots( dl, video, set )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% col = vertcat(dl.GblCentroidColNew);
% row = vertcat(dl.GblCentroidRowNew);
% time = vertcat(dl.ElapsedTime);
% h = figure; scatter(col,row)
% name = sprintf('%s-Scatter-NewCoords-%s', video, set);
% title(name);
% print(h, '-djpeg', name);
% 
% h = figure; plot3(col,row,time)
% name = sprintf('%s-Time-NewCoords-%s', video, set);
% title(name);
% print(h, '-djpeg', name);

col = vertcat(dl.GblCentroidCol);
row = vertcat(dl.GblCentroidRow);
time = vertcat(dl.ElapsedTime);
h = figure; scatter(col,row, 4, '+')
name = sprintf('%s-Scatter-3-%s', video, set);
title(name);
print(h, '-djpeg', name);

h = figure; plot3(col,row,time)
name = sprintf('%s-Time-3-%s', video, set);
title(name);
print(h, '-djpeg', name);
end

