function createSegVideo( env )
% CREATESEGVIDEO Creates a gray scale video with contours and medial axis
% annotated

%This program assumes that the dataset is ordered by frame number, though 
%each frame number need not be represented.  Though all frames will be 
%included in the output video, only frames with data avilable %will be 
%annotated. 

    addAllCodePaths();
    %globalEnv = setGlobalEnv( );
    env = getEnv_createSegVideo( env ); 
     
    processName = 'CreateSegVideo';
    [ studyInstancePath, f, g, theTimeStamp] = initializeProcess( processName, env);
   
    
    %Get video input file to annotate
    inputVideo = sprintf('%s%s',env.VideoInputDir, env.VideoInputName);
    videoFReader = vision.VideoFileReader(inputVideo);
    
    %Get number of frames from a VideoReader object
    obj = VideoReader(inputVideo);
    numFrames = obj.NumberOfFrames;
    clear obj;
    
    %Determine the frame rate
    infoStruct = info(videoFReader);
    frameRate = infoStruct.VideoFrameRate;
    
    %Set up the video output file
    videoOutputFile = sprintf('%s%s_%s.avi',studyInstancePath,env.VideoOutputName, theTimeStamp);
    outputVideoSize = [env.VideoOutputRows, env.VideoOutputCols];
    videoFWriter  = VideoWriter(videoOutputFile, env.OutputCODEC);
    videoFWriter.FrameRate = frameRate;
    open(videoFWriter );
    
   % Get the .mat file containing the data list variable, dl
    if isempty(env.AnnotationFileName) 
        %[fileName,pathName,~] = uigetfile;
       %inputMatFile = sprintf('%s%s', pathName, fileName);
        inputMatFile = env
    else
        inputMatFile = sprintf('%s%s', studyInstancePath, env.AnnotationFileName);
    end
    S = load(inputMatFile); %Loads the variable dl with the contours and skeletons
    dl = S.dl;
    fprintf(g,'\n Input Mat Annotation File: %s', inputMatFile);
    fprintf(g,'\n Input Gray Scale Video: %s', inputVideo);
    fprintf(g,'\n Output Annotated Video: %s', videoOutputFile);
    fprintf(g,'\n Output Video rows: %s', num2str(env.VideoOutputRows));
    fprintf(g,'\n Output  Video columns: %s', num2str(env.VideoOutputCols)); 
    fprintf(g,'\n Output  CODEC: %s', env.OutputCODEC); 
    
    errorFrames = '';
    startDatarow = env.StartDatarow;
    if length(dl) < env.EndDatarow;
        
        endDatarow = length(dl);
    else
        endDatarow = env.EndDatarow;
    end
    fprintf(g, '\n Number of Gray Scale Frames: %s', num2str(numFrames));
    fprintf(g, '\n Start Data Row: %s', num2str(startDatarow));
    fprintf(g, '\n End Data Row: %s', num2str(endDatarow));
    tic
    
    %Iterate through datarows and advance the frame counter to match the
    %frame in each data row
    iFrame = 0;
    for iDatarow = startDatarow:endDatarow
    
        %Advance the frames until it equals the current frame number
        %from the data set
        while ~isDone(videoFReader) && iFrame < dl(iDatarow).FrameNum
        
            videoFrame = step(videoFReader);
            iFrame = iFrame+1;
        end
        
        %Display frame number to output at periodic intervals
        if iFrame == 1 || mod(iFrame,env.DisplayRate) == 0
                        disp(iFrame);
                        toc
        end
        
       
        try
            %Create the annotated video frame    
            gsImage =  im2uint8(videoFrame(:,:,1));
            
            %Contour is saved as local coordiantes, so no change
            contour = dl(iDatarow).Contour;
            sktp  = globalToLocal(dl(iDatarow).Sktp, [dl(iDatarow).TotalOffsetRows,dl(iDatarow).TotalOffsetCols]);
            rgbImage = annotateFrame(gsImage, contour, sktp, iFrame, outputVideoSize);
            writeVideo(videoFWriter, rgbImage);
            
        catch err
            newError = sprintf('\n Frame %s: %s', num2str(iFrame),  getReport(err,'basic'));
            errorFrames = strcat(errorFrames, newError );
        end
        
    end
    
    %Conclude log entries and clean up variables
    elapsedTime = toc;
    fprintf(g, '\n Execution started at %s.', theTimeStamp);
    fprintf(g, '\n Execution Time: %s \n', num2str(elapsedTime));
    fprintf(g, '\n Error Frames: \n\n %s', errorFrames);
    release(videoFReader);
    close(videoFWriter);  
    fclose(f);
    fclose(g);
    clear f;
    clear g;
        
    
end

