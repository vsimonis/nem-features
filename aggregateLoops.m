function aggregateLoops(  )
%AGGREGATELOOPS Creates a CSV file of aggregated loop daa with each row
%being data for a single looping sequnece of frames

    addAllCodePaths();
    env = getEnv_aggregateLoops();
  
     
    processName = 'AggregateLoops';
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
   
    %Output CSV File
    outputCsvFile = sprintf('%s%s%s.csv', studyInstancePath, env.OutputFileName, theTimeStamp);
    
    fprintf(g,'\n Input MAt File: %s', inputMatFile);
    fprintf(g,'\n Output CSV File: %s', outputCsvFile);
     
      
    j = 0;
   
    pattern = '';
    tic
    for i = 2:length(dl)
       if i == 1 || mod(i,env.DisplayRate) == 0
                        disp(i);
                        toc
       end
       
       %If the current and prior variables for identifying loops are not
       %empty and one of the variables indicates there is a loop
       if ~isempty(dl(i).IsLoop) ...
           && ~isempty(dl(i-1).IsLoop )...
           &&  ( dl(i).IsLoop == 1 || dl(i-1).IsLoop == 1)
           
            if dl(i).IsLoop == 1 && dl(i-1).IsLoop ==0
                %New loop, set begin frame and reset the loop index
                j = j + 1;
                loop(j).LoopNum = j;
                loop(j).BeginFrame = dl(i).FrameNum;
                pattern = strcat(pattern, num2str(dl(i).Posture));
            elseif dl(i).IsLoop == 0 && dl(i-1).IsLoop == 1
                %End of loop - set endframe and reset the patter accumulator
                loop(j).EndFrame = dl(i-1).FrameNum;
                loop(j).Pattern = pattern;
                pattern = '';

            elseif dl(i).IsLoop ==1 && dl(i-1).IsLoop ==1
                %Existing loop - append to the patter accumulator
                pattern = strcat(pattern, num2str(dl(i).Posture));
            end
        end
       
    end
           
    T = struct2table(loop);
    writetable(T, outputCsvFile );
    elapsedTime = toc;
   
    fprintf(g, '\n Execution started at %s.', theTimeStamp);
    fprintf(g, '\n Execution Time: %s \n', num2str(elapsedTime));
    fclose(f);
    fclose(g);
    clear f;
    clear g;
    
end