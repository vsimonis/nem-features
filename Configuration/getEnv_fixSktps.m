function env = getEnv_fixSktps( )
%GETENV_FIXSKTPS pROVIDES CONFIGURATION VARIABLES FOR FIXSKTPS PROCESS
%   Detailed explanation goes here

    env.DisplayRate = 1000;
    % Specify the directory that contains the code
    env.CodeDirectory = 'C:\Users\rniehaus\Documents\Matlab\LocalNematodes';
    
    %Specify the study instance directory 
    env.WorkingDir = 'C:\Users\rniehaus\Documents\Elegans\';
    env.StudyInstanceName = 'CincoDeMayo';

    
    %Specify the mat data file containing the input data
    env.InputMatFileName = 'ContourAndSkel_2014-08-05-17-23m05s.mat';
    
    %Specify the output CSV file
    env.OutputCsvFileName = 'ContourAndSkelCorrected';

    %Specify the output Mat file
     env.OutputMatFileName = 'ContourAndSkelCorrected';
     
    %Specify the file containing frames to delete
    env.DeleteListFileName = 'DeleteList.csv';
    
    %Specify the file containing head locations to use as checkpoints
    env.CheckListFileName = 'CheckList.csv';
  
end

