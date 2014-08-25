function [ skewerStats ] = getSkewerStats( sktp, length, rowsInFrame )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
       
   %% Get rotation angle and skewer angle
   
   numPoints = size(sktp,1);
   head = sktp(1,:);
   tail = sktp(numPoints,:);
   [theta, skewerAngle] = getLineAngles(tail, head, rowsInFrame);
   y = rowsInFrame - sktp(:,1);
   x = sktp(:,2);
     
    %Roatation by an angle theta clockwise
    R  = [cosd(theta) -sind(theta)  ;...
          sind(theta)  cosd(theta)   ];
        
    %%  Analysis with centroid at the origin
    
    rotatedCoords = R * [x';y'];
    xRotated = rotatedCoords(1,:)';
    yRotated = rotatedCoords(2,:)';
    
    %Shift the skeleton so the centroid is at (0,0)
    xCentroid = sum(xRotated )/numPoints;
    yCentroid = sum(yRotated ) /numPoints;
    transformedX = xRotated - repmat(xCentroid, numPoints,1);
    transformedY = yRotated - repmat(yCentroid,numPoints,1);
    
    
    
   %Get the min.max x/y coords
    xMin = min(transformedX(1,1));
    xMax = max(transformedX(numPoints,1));
    yMin = min(transformedY);
    yMax =  max(transformedY);  
    
    %Get distances from the x axis to the largest and smallest y values.
    A = abs(yMax);
    B = abs(yMin);

    trackAmplitude = A + B;
    skewerLength = abs( xMax - xMin);
    sktAmpRatio = min(A,B)/max(A,B);
    sktCmptFactor = length/( trackAmplitude* skewerLength);
    sktElgFactor = trackAmplitude/skewerLength;

      
    Ixx = sum(transformedX.^2)./numPoints;
    Iyy = sum(transformedY.^2)./numPoints;
    
    %Get the average radial angle from each skeleton point to the centroid
    %using element-wise arithmetic
    phi = atand(transformedY ./transformedX);
    aglAve = sum(phi)/numPoints;
    
    
    %% Analysis with origin the point 1/2 dist. between the min and max row and col
    
      
    xCenter = (  min(xRotated) + max(xRotated)  )/2;
    yCenter = (  min(yRotated) + max(yRotated)  )/2;
    
    %nsform the skeleton so the midpoint is at (0,0)
    transformed2X = xRotated - repmat(xCenter,numPoints,1);
    transformed2Y = yRotated - repmat(yCenter,numPoints,1);
    
    xsym = sum(transformed2X);
    ysym = sum(transformed2Y); 
    xysym = sum( (transformed2X.* abs(transformed2Y)));
    
    trackAmplitude =  max(transformed2Y) - min(transformed2Y) ;
    
     
    %% Frequency Analysis to get characteristic period
     
    signal = transformedY;
    [~,indexMax] = max(abs(fft(signal-mean(signal))));
    
    %Length of signal
    L = numPoints;
    frequency = indexMax / L;
    period = 1/frequency;
    
        
    %% Load the results
    
    skewerStats.SkewerLength = skewerLength;
    skewerStats.SktAmpRatio = sktAmpRatio;
    skewerStats.SktCmptFactor = sktCmptFactor;
    skewerStats.SktElgFactor = sktElgFactor;
    skewerStats.Ixx = Ixx;
    skewerStats.Iyy = Iyy;
    skewerStats.SktAglAve = aglAve;
    skewerStats.Xsym = xsym;
    skewerStats.Ysym = ysym;
    skewerStats.XYsym = xysym;
    skewerStats.TrackAmplitude = trackAmplitude;
    skewerStats.TrackPeriod = period;
    skewerStats.SkewerAngle = skewerAngle ;
    
    
       
end

