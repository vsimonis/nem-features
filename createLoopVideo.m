function createLoopVideo()
   
    env = setEnv();
    tic;
    warning('off', 'images:initSize:adjustingMag');
    warning('off', 'images:initSize:adjustingMag');
    warning('off', 'MATLAB:polyfit:RepeatedPointsOrRescale');
    warning('off', 'images:initSize:adjustingMag');
    
    theTimeStamp = gettimestamp();
  
      
    %Make a directory for the study instance, if it does not exist 
    studyInstanceName =env.StudyInstanceName;
    if exist(studyInstanceName,'dir') == 0
        mkdir(env.WorkingDir, studyInstanceName);
    end
    studyInstancePath = sprintf('%s%s\\', env.WorkingDir, studyInstanceName);
   
    %Create or append to a log file to save project related messages
     if ~ exist(studyInstanceLogFile, 'file')
        f = fopen(studyInstanceLogFile, 'at');
        fprintf(f, 'Study Instance Name:  %s \n\n', env.StudyInstanceName);
    else
        f = fopen(studyInstanceLogFile, 'at'); 
    end
   
    
    %Create an execution log for process execution related messages
    processName = 'ExtractLoops';
    processLogFile = sprintf('%sLog_%s_%s_%s.txt', studyInstancePath, studyInstanceName, processName,theTimeStamp);
    g = fopen(processLogFile, 'at');
    fprintf(g, 'Study Instance Name:  %s \n', env.StudyInstanceName);
    fprintf(g, '%s execution began at %s.\n', processName, theTimeStamp);
    fprintf(f, '%s executed at %s.\n', processName, theTimeStamp);
    
    %% Set up data source 
    
    videoInputFile = sprintf('%s%s',env.ExtractLoopsVideoInputDir, env.ExtractLoopsVideoInputName);

    %Get number of frames from a VideoReader object
    obj = VideoReader(videoInputFile);
    numFrames = obj.NumberOfFrames;
    clear obj;

    %Get most other info from a VideoFileReader object
    videoFReader = vision.VideoFileReader(videoInputFile);

    fileName = videoFReader.Filename;
    imageColorSpace = videoFReader.ImageColorSpace;
    videoOutputDataType = videoFReader.VideoOutputDataType;
    infoStruct = info(videoFReader);
    frameRate = infoStruct.VideoFrameRate;
    videoFormat = infoStruct.VideoFormat;

    %Retrieve the frame rate and the number of rows and cols
    infoStruct = info(videoFReader);
    videoSize = infoStruct.VideoSize;
    numRows = videoSize(2);
    numCols = videoSize(1);    
    
    fprintf(g, 'Video Input File : \n \n');
    fprintf(g, 'Video Input File Name: %s \n', fileName);
    fprintf(g, 'Image Color Space: %s \n', imageColorSpace);
    fprintf(g, 'Video Output Data Type: %s \n', videoOutputDataType);
    fprintf(g, 'Video Format: %s \n', videoFormat);
    fprintf(g, 'Number of Frames: %s \n', num2str(numFrames));
    fprintf(g, 'Frame Rate: %s \n', frameRate);
    fprintf(g, 'Frame Rows:  %s \n', num2str(numRows));
    fprintf(g, 'Frame Cols: %s \n', num2str(numCols));
     
        
    %% Output Destination
    
    outputFile = sprintf('%s%s',studyInstancePath,env.ExtractLoopsOutputVideo');
    fprintf(g, 'OutputFile: %s \n', outputFile);  

    %Get number of frames from a VideoReader object
    obj = VideoReader(videoInputFile);
    numFrames = obj.NumberOfFrames;
    clear obj;
   
    %Get most other info from a VideoFileReader object
    videoFReader = vision.VideoFileReader(videoInputFile);
    infoStruct = info(videoFReader);
    frameRate = infoStruct.VideoFrameRate;
      
     %% Video Writer setup
        
    %Using the IMAQ eriter
    videoFWriter  = VideoWriter(sprintf('%s%s',studyInstancePath,env.ExtractLoopsOutputVideo),...
                    'Motion JPEG AVI');
    videoFWriter.FrameRate = frameRate;
    open(videoFWriter);        
     
    %% Process the frames
    tic
    dataList = processLoops(videoFReader, videoFWriter, env, numFrames);
    timeSpent = toc;
    fprintf(g, '      Execution Time: %s \n', timeSpent);
    fclose(f);
    fclose(g);
   
    %release(videoFWriter);% Vision Version
    close(videoFWriter); % IMAQ version
    release(videoFReader);
     
    %% Save feature data to a csv file 

    datarows = 1: size(dataList,1); 
    datarows = transpose(datarows);
    dataList = [datarows,dataList];
    T = array2table(dataList,'VariableNames',{'DataRow' ,'FrameNum', 'IsLoop'} );
    writetable(T, sprintf('%s%s',studyInstancePath,env.LoopCrossRefFile) );
  
end



function dataList = processLoops(videoFReader, videoFWriter, env, numFrames)

    warning('off', 'images:initSize:adjustingMag');
    warning('off', 'MATLAB:polyfit:RepeatedPointsOrRescale');
    
       
   
    inLoop = 0;
    numPreFrames = 10;
    numPostFrames = 10;
    postLoopIndex = 0;
    
    %Determine last frame
    if numFrames < env.EndFrame;
        
        endFrame = numFrames;
    else
        endFrame = env.EndFrame;
    end
     
    %Read frames until the end frame is reached
    iFrame = 1;
    
    loopBuffer = [];
    loopBufferIndices = [];
    dataList = [];
    while ~isDone(videoFReader) && iFrame <= endFrame
        videoFrame = step(videoFReader);
        
        %Start collecting data after the start frame is reached
        if iFrame >= env.StartFrame 

                %Increment the counter to keep track of rows in the data
                if iFrame == 1 || mod(iFrame,1000) == 0
                    disp(iFrame);
                end
               
                 
                %Grab the current frame.  The current format conists of 
                %RGB with a GS image in each channel
                gsImage = videoFrame(:,:,1);
                gsImage8 =  im2uint8(gsImage);
                
                %Segment the image and get a flag indicating whether a loop
                [~, loopFlag] =  cornerThresh(gsImage8, ...
                                                    env.EstArea, ...
                                                    env.StructElementSize );
                
                % If the worm is in a loop, save the frame to a buffer
                % The buffer should alos include the frame prior to and 
                % after the loop
                
                if inLoop == 0 && loopFlag == 0 && size(loopBuffer,4) < numPreFrames
                    loopBuffer = cat(4,loopBuffer, gsImage);
                    loopBufferIndices = [loopBufferIndices; [iFrame, loopFlag]];
                                        
                elseif inLoop == 0 && loopFlag == 0 && size(loopBuffer,4) == numPreFrames
                    loopBuffer = cat(4,loopBuffer, gsImage);
                    loopBufferIndices = [loopBufferIndices; [iFrame, loopFlag]];
                    
                    %Delete the first row to keep the number of frames in
                    %the buffer the same
                    loopBuffer(:,:,:,1) = [];
                    loopBufferIndices(1,:) = [];
                    
                elseif inLoop == 0 && loopFlag == 1
                    loopBuffer = cat(4,loopBuffer, gsImage);
                    loopBufferIndices = [loopBufferIndices; [iFrame, loopFlag]];
                    inLoop = 1;
                elseif inLoop == 1 && loopFlag == 1 
                    loopBuffer = cat(4,loopBuffer, gsImage);
                    loopBufferIndices = [loopBufferIndices; [iFrame, loopFlag]];
                elseif inLoop == 1 && loopFlag == 0 
                    inLoop = 0;
                    postLoopIndex = 1;
                    loopBuffer = cat(4,loopBuffer, gsImage);
                    loopBufferIndices = [loopBufferIndices; [iFrame, loopFlag]];
                elseif  loopFlag == 0 && postLoopIndex >=1 && postLoopIndex < numPostFrames
                    postLoopIndex = postLoopIndex + 1;
                    loopBuffer = cat(4,loopBuffer, gsImage);
                    loopBufferIndices = [loopBufferIndices; [iFrame, loopFlag]];
                elseif loopFlag == 0 && postLoopIndex == numPostFrames
                    
                    loopBuffer = cat(4,loopBuffer, gsImage);
                    loopBufferIndices = [loopBufferIndices; [iFrame, loopFlag]];
                    for k = 1:size(loopBuffer, 4)
                        newFrame = loopBuffer(:,:,:,k);
                        %step(videoFWriter, newFrame);
                        writeVideo(videoFWriter, newFrame);
                                               
                    end
                    dataList = [dataList; loopBufferIndices];
                    
                    %delete all frames except postloop frames that can be
                    %used for the next loop's pre-loop frames
                    if numPreFrames <= numPostFrames
                        loopBuffer(:,:,:,1:size(loopBuffer,4)- numPreFrames) = [];
                        loopBufferIndices(1:size(loopBufferIndices,1)- numPreFrames, :) = [];  
                    else
                        %numPreFrames > numPostFrames
                        loopBuffer(:,:,:,1:size(loopBuffer,4)- numPostFrames) = [];
                        loopBufferIndices(1:size(loopBufferIndices,1)- numPostFrames,:) = [];
                    end
                    inLoop = 0;
                    postLoopIndex = 0;
                elseif   loopFlag == 1 && postLoopIndex >=1 && postLoopIndex < numPostFrames
                    
                    for k = 1:size(loopBuffer, 4)
                        newFrame = loopBuffer(:,:,:,k);
                        %step(videoFWriter, newFrame);
                        writeVideo(videoFWriter, newFrame);
                    end
                    dataList = [dataList; loopBufferIndices];
                    
                    %delete all frames except postloop frames that can be
                    %used for the next loop's pre-loop frames
                    if numPreFrames <= postLoopIndex
                        loopBuffer(:,:,:,1:size(loopBuffer,4)- numPreFrames) = [];
                        loopBufferIndices(1:size(loopBufferIndices,1)- numPreFrames,:) = [];
                    else
                        %numPreFrames > postLoopIndex
                        loopBuffer(:,:,:,1:size(loopBuffer,4)- postLoopIndex) = [];
                        loopBufferIndices(1:size(loopBufferIndices,1)- postLoopIndex,:) = [];
                    end
                    
                    %Add the current loop frame to the buffer
                    loopBuffer = cat(4,loopBuffer, videoFrame);
                    loopBufferIndices = [loopBufferIndices; [iFrame, loopFlag]];
                    postLoopIndex = 0;
                    inLoop = 1;
                end
                
               
        end   
        iFrame = iFrame + 1;
        
    end
   
end %function