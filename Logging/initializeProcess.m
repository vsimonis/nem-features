function [ studyInstancePath, f, g, theTimeStamp] = initializeProcess( processName, env)
%INITIALIZEPROCESS Initializes log files for process execution
%   Returns the path to the study instance directory and handles to the
%   study instance log file (f) and process log file (g)

    
    theTimeStamp = gettimestamp();
    tic;
    warning('off', 'images:initSize:adjustingMag');
    warning('off', 'MATLAB:polyfit:RepeatedPointsOrRescale');
     
    %Make a directory for the study instance, if it does not exist 
    studyInstanceName = env.StudyInstanceName;
    if exist(sprintf('%s%s',env.WorkingDir, studyInstanceName),'dir') == 0
        mkdir(env.WorkingDir, studyInstanceName);
    end
    studyInstancePath = sprintf('%s\\%s\\', env.WorkingDir, studyInstanceName);
   
    %Create or append to a log file to save project related messages
    studyInstanceLogFile = sprintf('%sProject_Log_%s.txt', studyInstancePath, studyInstanceName);
    if ~ exist(studyInstanceLogFile, 'file')
        f = fopen(studyInstanceLogFile, 'at');
        fprintf(f, 'Study Instance Name:  %s \n\n', env.StudyInstanceName);
    else
        f = fopen(studyInstanceLogFile, 'at'); 
    end
   
    
    %Create an execution log for process execution related messages
    processLogFile = sprintf('%sLog_%s_%s_%s.txt', studyInstancePath, studyInstanceName, processName, theTimeStamp);
    g = fopen(processLogFile, 'at');
    fprintf(g, 'Study Instance Name:  %s \n', env.StudyInstanceName);
    fprintf(g, 'Execution started at %s.\n', theTimeStamp);
    fprintf(f, '\n %s was executed at %s.', processName, theTimeStamp);

end

