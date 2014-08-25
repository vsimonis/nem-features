function extractContourAndSkel( )
    
    addAllCodePaths();
    globalEnv = setGlobalEnv();
    env = getEnv_extractContourAndSkel(globalEnv);
    
    processName = 'ExtractContourAndSkel';
    [ studyInstancePath, f, g, theTimeStamp] = initializeProcess( processName, env);
   
    
    %% Set up data source 
   
    videoInputFile = sprintf('%s%s', env.VideoInputDir, env.VideoInputName );

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
    fprintf(g, '\n\n Video File \n\n');
    fprintf(g, 'Video File Name: %s \n', fileName);
    fprintf(g, 'Image Color Space: %s \n', imageColorSpace);
    fprintf(g, 'Video Output Data Type: %s \n', videoOutputDataType);
    fprintf(g, 'Video Format: %s \n', videoFormat);
    fprintf(g, 'Number of Frames: %s \n', num2str(numFrames));
    fprintf(g, 'Frame Rate: %s \n', frameRate);
    fprintf(g, 'Frame Rows:  %s \n', num2str(numRows));
    fprintf(g, 'Frame Cols: %s \n', num2str(numCols));
    fprintf(g, '\n\nSegmentation:\n\n');
    fprintf(g, 'Structure Element Size: %s \n', num2str(env.StructElementSize));
    fprintf(g, 'Estimated Area %s \n', num2str(env.EstArea));
    fprintf(g, '\n\nEndpoints From LAII:\n\n');
    fprintf(g, 'Kernel Radius: %s\n', num2str(env.KernelRadius));
    fprintf(g, 'Sigma: %s\n', num2str(env.Sigma));
    fprintf(g, 'Threshold: %s\n', num2str(env.Threshold));
    fprintf(g, 'Sigma Adjusted: %s\n', num2str(env.SigmaAdjusted));
  
    
    
    
    %% Load crop information into memory
    
    %Load the crop frame size and crop location for each frame.
    %If cropping is not used, set the size to the size of the entire image,
    %and set all the crop locations to (1,1).
    if env.Cropping == 1
        [cropLoc, cropSize]= loadCropLocations();
    else
        cropSize = [ numRows, numCols];
        cropLoc = ones(numFrames,2);
    end
       
       
    %% Load the camera step information into memory
    
    %Report the specified arbitary starting position of the camera
    cameraStartRow = env.CameraStartRow;
    cameraStartCol = env.CameraStartCol;
    fprintf(g, '\n\nCamera Movement:\n\n' );
    fprintf(g, 'CameraStartRow: %s \n', num2str(cameraStartRow) );
    fprintf(g, 'CameraStartCol: %s \n', num2str(cameraStartCol) );
    
  
    
    %Load the camera steps for each frame as an ordreed pair with (0,0)
    %where there are not steps
    if env.ShotChanges == 1 
        [cameraSteps, resolution, stepSize, epoch] = loadCameraStepsEpoch( env ); %reads from file
    else
        cameraSteps = zeros(numFrames,2);
        resolution = 1;
        stepSize = 0;
        % Load epoch information into memory
        epoch = transpose(0:0.1:numFrames);
    end
    fprintf(g, 'Resolution (pixels/mm): %s \n', num2str(resolution) );
    fprintf(g, 'Step size (mm): %s \n', num2str(stepSize) );
    
    %Report the pixels Per Step = mm/step * pixels/mm 
    pixelsPerStep = stepSize * resolution;
    fprintf(g, 'Pixels Per Step: %s \n', num2str(pixelsPerStep) );
    
    %Report the number of shot changes - where steps are not (0,0)
    [indVector, ~] = ismember([0,0], cameraSteps(1,:),'rows');
    ind = find(~indVector);
    numShotChanges = length(ind);
    fprintf(g, 'Number of shot changes: %s \n', num2str( numShotChanges));
    
      
    
    %% Output Destination
    
    outputCsvFile = sprintf('%s%s_%s.csv',studyInstancePath,env.OutputCsvFileName, theTimeStamp);
    fprintf(g, '\n\nCSV OutputFile: %s\n', outputCsvFile); 
    
    outputMatFile = sprintf('%s%s_%s.mat',studyInstancePath,env.OutputMatFileName, theTimeStamp);
    fprintf(g, 'Matlab Variable Output File: %s\n', outputMatFile); 
    
        
     
       
   %% Initialize Loop
           
    if numFrames < env.EndFrame;

        endFrame = numFrames;
    else
        endFrame = env.EndFrame;
    end
    
    %Pre-allocate datalist
    if env.AddToSavedData == 1
        % Load the Matlab structure array variable from disk 
         inputMatFile = sprintf('%s%s', studyInstancePath, env.InputMatFileName);
        S = load(inputMatFile);
        dl = S.dl;
       
        iDatarow = max([dl.SeqNum]); 
        iFrame = 0;
        startFrame = dl(iDatarow).FrameNum + 1;
      
    else
        iDatarow = 0;   
        iFrame = 0;
        startFrame = env.StartFrame;
        l(endFrame-startFrame+1).SeqNum = 0;
     
    end  
    fprintf(g, '\n\nStart Frame: %s \n', num2str(startFrame));
    fprintf(g, 'End Frame: %s \n', num2str(endFrame));  
    %% Execute loop
    errorFrames = '';
    tic
    while ~isDone(videoFReader) && iFrame <= endFrame 
       
        videoFrame = step(videoFReader);
        iFrame = iFrame+1;

        %Start collecting data after the start frame is reached
        if iFrame >= startFrame 
        
            try
                
                %Extract and display seq number and frame number 
                iDatarow = iDatarow+1;
                dl(iDatarow).SeqNum = iDatarow;
                dl(iDatarow).FrameNum = iFrame;
                if iFrame == 1 || mod(iFrame,env.DisplayRate) == 0
                    disp(iFrame);
                    toc
                end
                
                %Load the time epoch for this frame into mmeory
                dl(iDatarow).ElapsedTime = epoch(iFrame);
                
                %Load the shot change and cropping information, if
                %applicable, and obtain the totalOffset for converting
                %between local and global coordinates
                [dl, totalOffset] = loadCameraInfo(resolution, ...
                                                    cameraSteps(iFrame,:),...
                                                    pixelsPerStep,...
                                                    cropLoc(iFrame,:), ...
                                                    env,dl,iDatarow );
                
                %Grab the current frame.  The current format conists of 
                %RGB with a GS image in each channel
                gsImage =  im2uint8(videoFrame(:,:,1));

                %Segment the image and get a flag indicating whether a loop
                [bwImage, isLoopPosture] =  cornerThresh(gsImage, ...
                                                    env.EstArea, ...
                                                    env.StructElementSize );

                %Extract the contour from the bw image.  Keep in local 
                %coordinates  
                [perimRow, perimCol] = find( bwperim( bwImage ) );
                contour = [perimRow, perimCol]; 
                              
                %Load the shape and size features dervied from the binary image
                [dl, distTransform] = loadBwShapeAndSize( bwImage, dl, iDatarow);
                
                
                
                %Get the list of pixels that make up each segment of the skeleton 
                 [segments, endpoints, branchpoints, curvEndpoints, peaks]...
                     = getSkelSegments(bwImage, env, isLoopPosture);
               
                %Covrt the endpoints to global since they are used in
                %inter-frame analysis
                gblEndpoints = localToGlobal(endpoints, totalOffset);
                
                % Get the posture
                if isLoopPosture == 0
                     posture = 1;
                else
                    posture  = getLoopPosture(dl, iDatarow, gblEndpoints, numRows);
                end

                %Get the estimated length
                estLength = 0;
                if posture~= 1
                    estLength = getMean(dl,'Length',iDatarow - 21, iDatarow-1);
                end
                
                %Connect the segments to obtain an estimated centerline,
                %done on the local image
                sktpAll = getCenterline( segments, endpoints, branchpoints, posture, estLength);
                
                %conver tthe Sktp to global , so it can be compared across
                %frames
                sktpAll = localToGlobal(sktpAll, totalOffset);
               
                %Associate endpoints by skewer angle .
                if iDatarow ~= 1 
                    prevSkewerAngle = dl(iDatarow-1).SkewerAngle;
                    [sktpAll, skewerAngle] = assocEndpointsBySkewerAngle(sktpAll,prevSkewerAngle, numRows);
                else
                     [~, skewerAngle] = getLineAngles(sktpAll(end,:), sktpAll(1,:), numRows); 
                end
                
                %Save the data
                dl(iDatarow).NumRows = numRows;
                dl(iDatarow).NumCols = numCols;
                dl(iDatarow).Contour = contour;
                dl(iDatarow).Sktp =sktpAll; 
                dl(iDatarow).Posture = posture;
                dl(iDatarow).SkewerAngle = skewerAngle;
                dl(iDatarow).IsLoop = isLoopPosture;
                dl(iDatarow).Length = getLengthFromPixels(sktpAll);
                dl(iDatarow).HeadRow = sktpAll(1,1);
                dl(iDatarow).HeadCol = sktpAll(1,2);
                dl(iDatarow).TailRow = sktpAll(end,1);
                dl(iDatarow).TailCol = sktpAll(end,2);
                dl = loadEndpointCurvInfo(curvEndpoints, peaks, dl, iDatarow);
                %dl = loadEndIntensity(gsImage,bwImage,sktpAll, dl, iDatarow);
                %dl = loadWidthProfiles(distTransform, env.WidthProfileRange, dl, iDatarow);
                
                if mod(iDatarow,env.SaveRate) == 0
                     save(outputMatFile,'dl');
                    
                end
                
            catch err

                newError = sprintf('\n Frame %s: %s', num2str(iFrame),  getReport(err,'extended'));
                errorFrames = strcat(errorFrames, newError );     

            end
        end
    end
     
    release(videoFReader);
    
    
   
    %% Save data to disk
   
    %Save the structure array to disk as a Matlab variable
    save(outputMatFile,'dl');
    
    %Save feature data to a csv file 
    dl = rmfield(dl,'Sktp');
    dl = rmfield(dl,'Contour');
    T = struct2table(dl);
    writetable(T, outputCsvFile  );
  
    timeSpent = toc;
    fprintf(g, 'Execution Time: %s \n', timeSpent);
    fprintf(g, '\nError Frames: \n\n %s', errorFrames);
    fclose(f);
    fclose(g);
    clear f;
    clear g;
    
end
   
   
       
     


        
                
            
                
          