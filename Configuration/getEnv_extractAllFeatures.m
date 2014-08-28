function [ env ] = getEnv_extractAllFeatures(  globalEnv )
%SETENV Sets the environment for executing the feature extraction system
%   Sets code paths, specifies working directories, and manages warning messages


    %Specify where the results will be saved
    env.WorkingDir = globalEnv.WorkingDir;% 'C:\Users\rniehaus\Documents\Elegans\';
    env.StudyInstanceName = globalEnv.StudyInstanceName;%'1stVideo_Test5';

    % Specify the directory that contains the code
    env.CodeDirectory = globalEnv.CodeDirectory; %'C:\Users\rniehaus\Documents\Matlab\nem-feature';

    env.InputMatFileName = globalEnv.InputMatFileName; % 'ContourAndSkelCorrected_2014-07-25-06-10m18s.mat';

    env.OutputCsvFileName = globalEnv.OutputCsvFileName;%'AllFeatures';
    env.OutputMatFileName = globalEnv.OutputMatFileName;%'AllFeatures';
    
    %% Starting and ending frame 

    %If ending frame is greater than number frames, the system adjsuts by
    %setting ending frame to the number of frames in the video.

    env.StartDatarow =1;
    env.EndDatarow = globalEnv.EndFrame;%40000; 


    %% Display

    %Every nth seq number to display to the screen
    env.DisplayRate = 1000;

    
    %Specify the cropping done during tracking
    env.Cropping = 0;   % 0 = no cropping, 1 = cropping
    env.CropSize = 0;

    %Specify parameters related to camera shot changes during tracking
    env.ShotChanges = globalEnv.ShotChanges;%0;  % 0 = no, 1 = yes
    env.CameraStartRow = 1;
    env.CameraStartCol = 1;

    

    %Set sample size for sub-sampling th sktp prior to calculating bending
    %stats
    env.BendingSampleSize = 13;
    
    

    %% Endpoints from Curvature Calculations

    env.KernelRadius = 10;
    env.Sigma = 1;
    env.Threshold = 0.6;
    env.SigmaAdjusted = 1;

    %% Get direction parameters
    env.RowsForAverage = 20;
    env.DirectionSktpSampleSize = 13;
end

