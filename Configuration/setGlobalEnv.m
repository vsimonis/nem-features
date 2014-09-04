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

switch video
    case 'n2_no_food2'
        %% Video n2_no_food2
        globalEnv.StudyInstanceName = 'FullRunTest-1000';
        %globalEnv.VideoInputName= 'n2_no_food2-Wed_13_Aug_2014-124318.avi';
        %globalEnv.LogFileName= 'n2_no_food2-Wed_13_Aug_2014-124258.log';
        globalEnv.EndFrame = 1000;
        globalEnv.EstArea = 560;
        %globalEnv.InputMatFileName = 'ContourAndSkel_2014-08-26-13-32m11s.mat'; %ContourAndSkelCorrected_2014-07-25-06-10m18s.mat';
        
        %globalEnv.AllFeaturesMat = 'AllFeatures_2014-08-28-14-44m51s.mat';
        globalEnv.ShotChanges = 1;
        
    case 'N2_nf1--manual'
        
        globalEnv.StudyInstanceName= 'Test';
        globalEnv.VideoInputName= 'N2_nf1-Tue_19_Aug_2014-155538.avi';
        globalEnv.LogFileName= 'N2_nf1-Tue_19_Aug_2014-155505.log';
        globalEnv.EndFrame = 43762;
        globalEnv.EstArea = 1970;
    case 'tph-1nofood1'
        globalEnv.StudyInstanceName= 'Run1';
        globalEnv.VideoInputName= 'tph-1nofood1-Tue_12_Aug_2014-171059.avi';
        globalEnv.LogFileName= 'tph-1nofood1-Tue_12_Aug_2014-170327.log';
        globalEnv.EndFrame = 37754;
        globalEnv.EstArea = 640;
        globalEnv.WorkingDir= 'C:\Users\vsimonis\Documents\MATLAB\Data\n2_no_food1\';
    case 'n2_no_food1'
        globalEnv.StudyInstanceName= 'Run1';
        globalEnv.VideoInputName= 'N2_no_food1-Wed_13_Aug_2014-112010.avi';
        globalEnv.LogFileName= 'N2_no_food1-Wed_13_Aug_2014-111901.log';
        globalEnv.EndFrame = 40000;
        globalEnv.EstArea = 505;
        globalEnv.InputMatFileName ='ContourAndSkel_2014-08-25-16-54m13s.mat'; %ContourAndSkelCorrected_2014-07-25-06-10m18s.mat';
        globalEnv.OutputCsvFileName = 'AllFeatures';
        globalEnv.OutputMatFileName = 'AllFeatures';
        globalEnv.ShotChanges = 1;
        
    case 'tph-1_nofood'
        globalEnv.StudyInstanceName= 'Test';
        globalEnv.VideoInputName= 'tph-1_nofood-Tue_12_Aug_2014-152943.avi';
        globalEnv.LogFileName= 'tph-1_nofood-Tue_12_Aug_2014-152554.log';
        globalEnv.EndFrame = 14237;
        globalEnv.EstArea = 420;
    case 'tph-1_no_food'
        
        globalEnv.StudyInstanceName= 'a';
        %globalEnv.VideoInputName= 'tph-1_no_food-Thu_14_Aug_2014-153000.avi';
       % globalEnv.LogFileName= 'tph-1_no_food-Thu_14_Aug_2014-152746.log';
        globalEnv.EndFrame = 10; %40,000
        globalEnv.EstArea = 585;
        
    case 'tph-1_no_food-MONSTER'
        
        globalEnv.StudyInstanceName= 'Prelim';
        globalEnv.VideoInputName= 'tph-1_no_food-Wed_13_Aug_2014-152819-30400.avi';
        globalEnv.LogFileName= 'tph-1_no_food-Wed_13_Aug_2014-152753.log';
        globalEnv.EndFrame = 1000;
        globalEnv.EstArea = 640;
        
    case 'N2_no_food-Wed'
        globalEnv.WorkingDir= 'C:\Users\vsimonis\Documents\MATLAB\Data\N2_no_food-Wed\';
        globalEnv.StudyInstanceName= 'Run2';
        globalEnv.VideoInputDir= 'C:\Users\vsimonis\Documents\MATLAB\Data\N2_no_food-Wed\';
        globalEnv.VideoInputName= 'N2_no_food-Wed_13_Aug_2014-103129.avi';
        globalEnv.LogFileName= 'N2_no_food-Wed_13_Aug_2014-102725.log';
        globalEnv.EndFrame = 40000;
        globalEnv.EstArea = 570;
        % globalEnv.StudyInstanceName= 'Run1';
        % globalEnv.VideoInputDir= 'C:\Users\vsimonis\Documents\MATLAB\Data\N2_no_food-Wed\';
        % globalEnv.VideoInputName= 'N2_no_food-Wed_13_Aug_2014-103129.avi';
        % globalEnv.LogFileName= 'N2_no_food-Wed_13_Aug_2014-102725.log';
        % globalEnv.EndFrame = 62573;
        % globalEnv.EstArea = 640;
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

