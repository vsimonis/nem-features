function  fixSktps( )
%FIXSKTPS Recalculates the Sktp, head, tail, and skewer angle based on
%correction files.
    
    %Initilization
    addAllCodePaths();
    env = getEnv_fixSktps();
    processName = 'FixSktps';
    [ studyInstancePath, f, g, theTimeStamp] = initializeProcess( processName, env);
   
    %% Output Destination
    
    outputCsvFile = sprintf('%s%s_%s.csv',studyInstancePath,env.OutputCsvFileName, theTimeStamp);
    fprintf(g, '\n\nCSV OutputFile: %s\n', outputCsvFile); 
    
    outputMatFile = sprintf('%s%s_%s.mat',studyInstancePath,env.OutputMatFileName, theTimeStamp);
    fprintf(g, 'Matlab Variable Output File: %s\n', outputMatFile); 
    
    %% Input data
    
    %Load the Matlab file containing the data list variable
    inputMatFileName = env.InputMatFileName;
    if isempty(inputMatFileName) 
        [fileName,pathName,~] = uigetfile;
        inputMatFile = sprintf('%s%s', pathName, fileName);
    else
    	inputMatFile = sprintf('%s%s',studyInstancePath,env.InputMatFileName);
    end
    S = load(inputMatFile);
    dl = S.dl;
    
    %Load the frames to delete from the the specified CSV file 
    deleteListFileName = env.DeleteListFileName;
    if isempty(deleteListFileName) 
        [fileName,pathName,~] = uigetfile;
        deleteListFile = sprintf('%s%s', pathName, fileName);
    else
        deleteListFile = sprintf('%s%s', studyInstancePath, deleteListFileName);
    end
    D = readtable(deleteListFile, 'delimiter',',');
      
    %Load the check list from the specified CSV file 
    checkListFileName = env.CheckListFileName;
    if isempty(checkListFileName) 
        [fileName,pathName,~] = uigetfile;
        checkListFile = sprintf('%s%s', pathName, fileName);
    else
        checkListFile = sprintf('%s%s', studyInstancePath, checkListFileName);
    end
    C = readtable(checkListFile, 'delimiter',',');
    checkpointFrames = table2array(C(:,'FrameNum'));
    checkpointCoords = [C.HeadRow,C.HeadCol ];
    strCheckpoints = 'Frame   HeadRow     HeadCol'; 
    for i = 1: height(C)
        aRow = sprintf('\n %d    %d         %d',  table2array(C(i,:)));
        strCheckpoints = strcat(strCheckpoints, aRow);
    end
 
    %First delete the frames to be deleted 
    frameNumsToDelete = D.FrameNum;
    dataFrames = transpose([dl.FrameNum]);
    frameNumsDeleted = '';
    if ~isempty( frameNumsToDelete)
        [~,LocB] = ismember(frameNumsToDelete,dataFrames);
        dl( LocB) = [];
        qtyDeleted = size(LocB,1);
        frameNumsDeleted = strcat(frameNumsDeleted,num2str(frameNumsToDelete(1)));
        for i = 2:qtyDeleted
           frameNumsDeleted = strcat(frameNumsDeleted,',',num2str(frameNumsToDelete(i)));
        end
    end
    numRowsInImage = dl(1).NumRows;
    
    tic
    errorFrames = '';
    for i = 1:length(dl)
       
       if i  == 1 || mod(i,env.DisplayRate) == 0
                        disp(i);
                        disp(toc);
       end
       iFrame = dl(i).FrameNum;
       
       oldEnds = [dl(i).HeadRow,...
                    dl(i).HeadCol;...
                    dl(i).TailRow,...
                    dl(i).TailCol];
       try
           
            isLoopPosture = dl(i).IsLoop;
            sktp = dl(i).Sktp;           
            %If it is a checkpoint, fix the Sktp if necessary to conform to the
            %checkpoint head location, else process based on information from 
            % previous frames 
            [~, loc] = ismember(iFrame,checkpointFrames);
            if loc ~= 0
                if ~isequal( sktp(1,:), checkpointCoords(loc,:));
                    sktp = reverserows(sktp);
                end
                head = sktp(1,:);
                tail = sktp(end,:);
                [~, skewerAngle] = getLineAngles(tail, head, numRowsInImage);
            else   
                %Associate endpoints by skewer angle .
                if i ~= 1 
                    prevSkewerAngle = dl(i-1).SkewerAngle;
                   
                    [sktp, skewerAngle] = assocEndpointsBySkewerAngle(sktp,prevSkewerAngle, numRowsInImage);
                else
                    head = [dl(i).HeadRow,dl(i).HeadCol];
                    tail = [dl(i).TailRow,dl(i).TailCol];
                     [~, skewerAngle] = getLineAngles(tail, head, numRowsInImage);
                end
            end
            
            dl(i).Sktp = sktp;
            dl(i).SkewerAngle = skewerAngle;
            dl(i).HeadRow = sktp(1,1);
            dl(i).HeadCol = sktp(1,2);
            dl(i).TailRow = sktp(end,1);
            dl(i).TailCol = sktp(end,2);
            
            %Need to recalculate the posture, since frames being deleted
            %may resolve the posture for unknown posture, or may combine
            %loops, etc.
            ends = [dl(i).HeadRow,...
                        dl(i).HeadCol;...
                        dl(i).TailRow,...
                        dl(i).TailCol];
           
           if isLoopPosture == 0
               dl(i).Posture = 1;
           else
               oldPosture = dl(i).Posture;
               if oldPosture == 0 || oldPosture == 3 || oldPosture == 4
                   %The number of ends is equal to 2 for these cases
                    dl(i).Posture = getLoopPosture( dl, ...
                                                             i,...
                                                             ends,...
                                                             numRowsInImage);
               end
           end 
           
           %If the head and tail changed, need to switch any columns that
           %are head/tail dependent
           if ~isequal(oldEnds, ends)
                              
              temp = [dl(i).HeadCurvPtRow, dl(i).HeadCurvPtCol];
              dl(i).HeadCurvPtRow = dl(i).TailCurvPtRow;
              dl(i).HeadCurvPtCol= dl(i).TailCurvPtCol;
              dl(i).TailCurvPtRow = temp(1);
              dl(i).TailCurvPtCol = temp(2);
              
              temp = dl(i).CurvHead;
              dl(i).CurvHead = dl(i).CurvTail;
              dl(i).CurvTail = temp;
               
           end
        catch err
            newError = sprintf('\n Frame %s: %s', num2str(iFrame),  getReport(err,'basic'));
            errorFrames = strcat(errorFrames, newError );
       end
    end
    
   
    timeSpent = toc;
    
    fprintf(g, '\n Study instance name: %s ', env.StudyInstanceName);
    fprintf(g, '\n Check list file : %s', checkListFile);
    fprintf(g, '\n Delete list file : %s', deleteListFile);
    fprintf(g, '\n Output CSV file : %s', outputCsvFile);
    fprintf(g, '\n Output Mat file : %s', outputMatFile);
    fprintf(g, '\n Execution started at %s.', theTimeStamp);
    fprintf(g, '\n Number of frames deleted: %s',  num2str(qtyDeleted));
    fprintf(g, '\n Frame numbers deleted:  %s', frameNumsDeleted);
    fprintf(g, '\n\n Checkpoints:\n\n %s', strCheckpoints);
    fprintf(g, '\n Execution Time: %s \n', timeSpent);
    fprintf(g, '\n\n Error Frames: \n\n %s', errorFrames);
    
    %% Save data to disk
   
    %Save the structure array to disk as a Matlab variable
    save(outputMatFile,'dl');
    
    %Save feature data to a csv file except for contour and skel
    dl = rmfield(dl,'Sktp');
    dl = rmfield(dl,'Contour');
    T = struct2table(dl);
    writetable(T, outputCsvFile);
  
    fclose(f);
    fclose(g);
    clear f;
    clear g;
    
       
end




