function result = getDirection(n, sktpSampleSize,dl,i)
%GETDIRECTION Specifies whetehr worm is moving forward or backward
%  1 - Forward
%  2 - Reverse

% n = the number of frames to determien the average over

% rowsInFrame = number of rows in teh global reference, but it can be
% arbitarily large, because it is used to determien the sktp angle

% The nematode is moving in the forward direction if every sampled sktp 
% point moves closer to where the sktp point in front of it was located 
% at t - n frame. The nematode is moving in the reverse direction if every 
% sampled sktp  point moves closer to where the sktp point behind it was 
% in the t-n frame. the previous frame, n, is the frame from which  the 
% worm would have moved one half the average distance equal  between SKTP 
% points if it was moving at its average velocity 

    numPoints = sktpSampleSize;
    meanSktpMovement = getMean(dl,'SktpMovement', i - n, i);
    meanLength = getMean(dl, 'Length', i - n, i);
    aveDistBetweenSktpPts = meanLength/(numPoints-1);
    frameInterval = floor(aveDistBetweenSktpPts/meanSktpMovement);
    if frameInterval < i && frameInterval >= 1 
        prevFrame = i - frameInterval;
    elseif frameInterval < 1
        prevFrame = i-1;
    else
        prevFrame = 1;
    end
        
   
    [curSampledSktp, ~] = sampleSktp(dl(i).Sktp, sktpSampleSize);
    [prevSampledSktp,~] = sampleSktp(dl(prevFrame).Sktp, sktpSampleSize);

    oldDistBetweenPts = getDist(prevSampledSktp(2:numPoints,:),prevSampledSktp(1:numPoints-1,:));
    newDistBetweenPts = getDist(curSampledSktp(2:numPoints,:), prevSampledSktp(1:numPoints-1,:));

    meanDisplacement = mean( newDistBetweenPts - oldDistBetweenPts );
     
    if meanDisplacement < 0  %gets closer
        result = 1;
    else
        result = 2;
    end   

end




