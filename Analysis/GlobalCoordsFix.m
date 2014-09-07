%% Load original mat
close all;
clear;

wd = 'C:\Users\Valerie\Documents\MATLAB\Data';
% video = 'N2_no_food1';
% MatFile = 'ContourAndSkel_2014-08-25-16-54m13s.mat';
% study = 'Run1';

video = 'n2_no_food2';
MatFile = 'ContourAndSkel_2014-08-27-10-17m55s.mat';
study = 'Run2';

% video = 'tph-1_no_food';
% MatFile = 'ContourAndSkel_2014-08-25-16-48m07s.mat';
% study = 'Run1';

goTo = sprintf('%s\\%s\\%s\\%s', wd,video,study,MatFile);
load(goTo)
numFrames = size(dl,2);
moves = 0;
for i = 1:numFrames
    dl(i).ElapsedTime = dl(i).ElapsedTime{1};
    if dl(i).CameraStepCols ~= 0
        moves = 1;
    end
    if dl(i).CameraStepRows ~=0
        moves = 1;
    end
    if moves
        dl(i).GblCentroidColNew = dl(i).LclCentroidCol + dl(i - 2).TotalOffsetCols;
        dl(i).GblCentroidRowNew = dl(i).LclCentroidRow + dl(i - 2).TotalOffsetRows;
    else
        dl(i).GblCentroidColNew = dl(i).LclCentroidCol + dl(i).TotalOffsetCols;
        dl(i).GblCentroidRowNew = dl(i).LclCentroidRow + dl(i).TotalOffsetRows;
    end
    
end

        