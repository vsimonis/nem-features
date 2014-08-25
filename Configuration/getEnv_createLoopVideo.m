function [ env ] = getEnv_createLoopVideo(  )
%SETENV Sets the environment for executing the feature extraction system
%   Sets code paths, specifies working directories, and manages warning messages


%Specify where the results will be saved
env.WorkingDir = 'C:\Users\rniehaus\Documents\Elegans\';
env.StudyInstanceName = '1stVideo_Test2';

% Specify the directory that contains the code
env.CodeDirectory = 'C:\Users\rniehaus\Documents\Matlab\LocalNematodes';


%% Width Profile Analysis

%set the pixels from each end to use in the width profile analysis
env.WidthProfileRange = [5,30];

%% Specify the location and parameters of the input video sequences

env.VideoDir = 'C:\Users\rniehaus\Documents\Elegans\Videos\';
env.VideoName = 'loopVideo.avi'; %'worm2014_05_05-12-44-53.avi';

%% Specify the location and parameters of the extract loops process

env.ExtractLoopsVideoInputDir = 'C:\Users\rniehaus\Documents\Elegans\';
env.ExtractLoopsVideoInputName = 'worm2014_05_05-12-44-53.avi';
env.ExtractLoopsOutputVideo = 'loopVideo.avi';
env.LoopCrossRefFile = 'loopCrossref.csv';

%% Specify the directories and files for the contour and skel extraction process
env.ContourAndSkelVideoInputDir = 'C:\Users\rniehaus\Documents\Elegans\1stVideo_Test2\';
env.ContourAndSkelVideoInputName = 'worm2014_05_05-12-44-53.avi';
env.ContourAndSkelOutputFile = 'ContourAndSkel.csv';


%% Starting and ending frame 

%If ending frame is greater than number frames, the system adjsuts by
%setting ending frame to the number of frames in the video.

env.StartFrame =1;
env.EndFrame = 36036; 

%% Segmentation Parameters

env.StructElementSize = 2;
env.EstArea = 2473;
%env.EstPosition = [506, 559];
%env.WindowSize = [200,200];

%% Head/Tail Association

%%Reverse the head/tail association on the following frames
env.FrameOverrideList = []; %[1496, 1999, 2811, 3113];

%% Display

%Every nth seq number to display to the screen
env.DisplayRate = 100;

%% Loop Frame Buffering

env.NumPreFrames = 10;
env.NumPostFrames = 10;

%% Endpoints from Curvature Calculations
env.SaveCurvInfo  = 0;
env.KernelRadius = 10;
env.Sigma = 1;
env.Threshold = 0.6;
env.SigmaAdjusted = 1;

%% Segmentation Video 
env.SegVideoInputDir= 'C:\Users\rniehaus\Documents\Elegans\1stVideo_Test2\';
env.SegVideoInputName = 'worm2014_05_05-12-44-53.avi';
env.SegVideoName = 'SegVideo.avi';
env.SegVideoRows = 300;
env.SegVideoCols = 300;
env.SegVideoFileColorSpace = 'RGB';
env.SegVideoFileFormat = 'AVI';
%% Results saved

%Specify where the results will be saved
env.ResultsDir = 'C:\Users\rniehaus\Documents\Elegans\';


%% Manage warning messages
warning('off', 'images:initSize:adjustingMag');

%% Manage code paths

%Add code paths
addpath(genpath(env.CodeDirectory)); 
addpath(strcat(env.CodeDirectory,'\' ) );
end

