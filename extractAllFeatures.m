function dl = extractAllFeatures(  )
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

       
    %Add code paths for all subdirectories
    addAllCodePaths();
    
    %Get the configuration parameters for this process
    env = getEnv_extractAllFeatures();
    
    %Initialize the logging
    processName = 'ExtractAllFeatures';
    [ studyInstancePath, f, g, theTimeStamp] = initializeProcess( processName, env);
   
   
    % Load the Matlab structure array variable from disk 
    if isempty(env.InputMatFileName) 
        [fileName,pathName,~] = uigetfile;
        inputMatFile = sprintf('%s%s', pathName, fileName);
    else
        inputMatFile = sprintf('%s%s', studyInstancePath, env.InputMatFileName);
    end
    S = load(inputMatFile);
    dl = S.dl;
    
    %Set up an output file
    outputCsvFile = sprintf('%s%s_%s.csv', studyInstancePath, env.OutputCsvFileName, theTimeStamp);
    outputMatFile = sprintf('%s%s_%s.mat', studyInstancePath, env.OutputMatFileName, theTimeStamp);
     
    %Set the start frame and end frame
    startDatarow = env.StartDatarow;
    if length(dl) < env.EndDatarow;
        endDatarow = length(dl);
    else
        endDatarow = env.EndDatarow;
    end
    fprintf(g, 'Start Frame: %s \n', num2str(startDatarow));
    fprintf(g, 'End Frame: %s \n', num2str(endDatarow));
    
    %Load the number of image rows and columns in each row
    numRows = dl(startDatarow).NumRows;
    numCols = dl(startDatarow).NumCols;
    fprintf(g, 'Number of Image Rows: %s \n', num2str(numRows));
    fprintf(g, 'Number of Image Cols: %s \n', num2str(numCols));
    
            
    %% Process each row
    tic
    errorRows = '';
    for i = startDatarow:endDatarow 
       
        try
            %Display the datarow
            if i == 1 || mod(i,env.DisplayRate) == 0
                disp(i);
                toc
            end

           %get the BW Image - contour is saved in local coordinates
            bwImage = contour2BwImage(dl(i).Contour, [numRows, numCols]);

            %Load the shape and size features dervied from the binary image
            [dl, distTransform] = loadBwShapeAndSize( bwImage, dl, i);

            
            %Load the features determined by analysis of the skewer
            %representation of the skeleton
            dl = loadSktpSkewerStats(dl, i );

            %Load the width profile of each end
            dl = loadWidthProfiles(distTransform, env.WidthProfileRange, dl, i);

            %Load bending stats
            dl = loadBendingStats(env.BendingSampleSize,dl, i);

            %Load mean sktp movement
            if i == 1;
                dl(i).SktpMovement = 0;
            else
                dl(i).SktpMovement = getSktpMovement(dl(i).Sktp, dl(i-1).Sktp);
            end
            
            %Get direction 
            result = getDirection(env.RowsForAverage, env.DirectionSktpSampleSize,dl,i);
            dl(i).DirectionCode = result;
            
            %Load trajectory info
            dl = loadTrajectoryInfo(dl, i);
        catch err
             newError = sprintf('\n Frame %s: %s', num2str(i),  getReport(err,'extended'));
             errorRows = strcat(errorRows, newError );    
        end
    end
    
    %Save the structure array to disk as a Matlab variable
    save(outputMatFile,'dl');
    
    %Save feature data to a csv file 
    dl = rmfield(dl,'Sktp');
    dl = rmfield(dl,'Contour');
    dl = dl(startDatarow:endDatarow);
    T = struct2table(dl); 
    writetable(T, outputCsvFile  );
    
    timeSpent = toc;
    fprintf(g, 'Execution Time: %s \n', timeSpent);
    fprintf(g, '\n Error Frames: \n\n %s', errorRows);
    fclose(f);
    fclose(g);
    clear f;
    clear g;
    
   
    
    
end
    

