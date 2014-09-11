function [ globalEnv ] = setGlobalEnv( user, video )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

globalEnv.video = video;
globalEnv.user = user;

%% This bit here will change depending on the computadora
globalEnv.CodeDirectory = sprintf('%s%s%s', 'C:\Users\', user, '\Documents\MATLAB\nem-features\');
globalEnv.WorkingDir = sprintf('%s%s%s%s', 'C:\Users\', user, '\Documents\MATLAB\Data\', video);
globalEnv.VideoInputDir = sprintf('%s%s%s%s', 'C:\Users\', user, '\Documents\MATLAB\Data\', video);

%% This bit finds the Log and Video file
for file = dir(globalEnv.WorkingDir)'
    if ~isempty(strfind(file.name, '.avi'))
        globalEnv.VideoInputName = file.name;
    elseif ~isempty(strfind(file.name, '.log'))
        globalEnv.LogFileName = file.name;
    end
end

%% Naming conventions for Extract All Features mat and csv
globalEnv.OutputCsvFileName = 'AllFeatures';
globalEnv.OutputMatFileName = 'AllFeatures';

%% Has log file?
globalEnv.ShotChanges = 1;

switch video
    case 'tph-1_no_food'
        globalEnv.StudyInstanceName= 'Penul';
        globalEnv.EndFrame = 25000;
        globalEnv.EstArea = 585;
        
    case 'n2_no_food1'
        globalEnv.StudyInstanceName= 'Run1';
        globalEnv.EndFrame = 40000;
        globalEnv.EstArea = 505;
        
    case 'n2_no_food2'
        globalEnv.StudyInstanceName = 'FullRunTest-1000';
        globalEnv.EndFrame = 1000;
        globalEnv.EstArea = 560;
        
    case 'N2_f5'
        globalEnv.StudyInstanceName = 'Prelim';
        globalEnv.EndFrame = 1000;
        globalEnv.EstArea = 560;
    case 'N2_f6'
        globalEnv.StudyInstanceName = 'Prelim';
        globalEnv.EndFrame = 1000;
        globalEnv.EstArea = 560;
    case 'tph-1_f3'
        globalEnv.StudyInstanceName = 'Run1';
        globalEnv.EndFrame = 25000;
        globalEnv.EstArea = 534;
        
    case 'tph-1_f4'
        globalEnv.StudyInstanceName = 'Run1';
        globalEnv.EndFrame = 25000;
        globalEnv.EstArea = 593;
        
        
        
        
        
        
    case 'N2_nf1--manual'
        globalEnv.StudyInstanceName= 'Test';
        globalEnv.EndFrame = 43762;
        globalEnv.EstArea = 1970;
        
    case 'tph-1nofood1'
        globalEnv.StudyInstanceName= 'Run1';
        globalEnv.EndFrame = 37754;
        globalEnv.EstArea = 640;
        
        
        
    case 'tph-1_nofood'
        globalEnv.StudyInstanceName= 'Test';
        globalEnv.EndFrame = 14237;
        globalEnv.EstArea = 420;
        
        
    case 'tph-1_no_food-MONSTER'
        
        globalEnv.StudyInstanceName= 'Prelim';
        globalEnv.EndFrame = 1000;
        globalEnv.EstArea = 640;
        
    case 'N2_no_food-Wed'
        globalEnv.StudyInstanceName= 'Run2';
        globalEnv.EndFrame = 40000;
        globalEnv.EstArea = 570;
        
end

%%% This bit finds mat files generated during skel, contour and all
%%% features
globalEnv.StudyInstanceDir = sprintf('%s\\%s', globalEnv.WorkingDir, globalEnv.StudyInstanceName);
filesInDir  = dir(globalEnv.StudyInstanceDir);

for file = filesInDir'
    if ~isempty(strfind(file.name, '.mat'))
        if ~isempty(strfind(file.name, 'ContourAndSkel'))
            globalEnv.ContourSkelMat = file.name;
        elseif ~isempty(strfind(file.name, 'AllFeatures'))
            globalEnv.FeaturesMat = file.name;
            
        end
    end
end


end

