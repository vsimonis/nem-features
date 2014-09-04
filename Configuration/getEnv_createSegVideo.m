function env = getEnv_createSegVideo( globalEnv )
%GETENV_CREATESEGVIDEO  Sets configuration variables to create an annotated grays scale video showing
%contour and medial axis


%Specify where the results will be saved
env.WorkingDir = globalEnv.WorkingDir;% 'C:\Users\vsimonis\Documents\MATLAB\Elegans\';
env.StudyInstanceName = globalEnv.StudyInstanceName;


% Specify the directory that contains the code
env.CodeDirectory = globalEnv.CodeDirectory;%'C:\Users\vsimonis\Documents\MATLAB\LocalNematodes';


%% Starting and ending frame 

%If ending frame is greater than number frames, the system adjsuts by
%setting ending frame to the number of frames in the video.

env.StartDatarow =1;
env.EndDatarow = globalEnv.EndFrame;%36036; 

%% Display

%Every nth sequence number to display to the screen
env.DisplayRate = 1000;

%% Input Gray scale video 
env.VideoInputDir =  globalEnv.VideoInputDir;%'C:\Users\vsimonis\Documents\MATLAB\Elegans\N2-3\';
env.VideoInputName = globalEnv.VideoInputName;%'N2_no_food3-Wed_13_Aug_2014-133814.avi';

%% Input Annotation File
env.AnnotationFileName = '';% 'ContourAndSkelCorrected_2014-08-06-06-48m34s';

%% Annotated Video Output

env.VideoOutputName = sprintf('%s-%s',globalEnv.StudyInstanceName, 'SegVideo');
env.VideoOutputRows = 300;
env.VideoOutputCols = 300;
env.OutputFileColorSpace = 'RGB';
env.OutputFileFormat = 'AVI';
env.OutputCODEC = 'Motion JPEG AVI';


end

