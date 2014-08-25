function env = getEnv_aggregateLoops( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    % Specify the directory that contains the code
    env.CodeDirectory = 'C:\Users\rniehaus\Documents\Matlab\LocalNematodes';
    
    %Specify the study instance directory 
    env.WorkingDir = 'C:\Users\rniehaus\Documents\Elegans\';
    env.StudyInstanceName = '1stVideo_Test5';

    %Specify the file containing the structure array with the data
    env.InputMatFileName = 'ContourAndSkelCorrected_2014-07-25-06-10m18s.mat';

    %Specify the output CSV file
    env.OutputFileName = 'AggregatedLoopsCorrected';

    %Every nth seq number to display to the screen
    env.DisplayRate = 1;

    end

