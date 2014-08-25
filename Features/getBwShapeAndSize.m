function [ STATS ] = getBwShapeAndSize( bwImage)
%getShapeAndSize = returns shape and size features 
%   
% Input Arguments:
%
% bwFrame - logical image
% skeleton - iimage of the skeleton
% sktp - list of pixels in the skeleton
% 
% Returns - structure with shape and size features


    
    STATS = regionprops(bwImage, 'Area',...
                                    'Centroid',...
                                    'MajorAxisLength',...
                                    'MinorAxisLength',...
                                    'Perimeter',...
                                    'PixelList');

    %The elongation is the major axis length divided by the minor axis length
    %of the ellipse with the second second moment as the worm.
    STATS.Elongation = STATS.MajorAxisLength/STATS.MinorAxisLength;

    %The compactness factor is the area of the area of the worm divided by the
    % area of the minimum enclosing rectangle 
    STATS.ComptFactor = STATS.Area/(STATS.MajorAxisLength*STATS.MinorAxisLength);

    %The Heywood circularity factor is the ratio of a worm perimeter to the
    %perimeter of the cicle with the same area  
    STATS.Heywood = STATS.Perimeter/( 2* sqrt( pi * STATS.Area) );

    %The hydraulic radius is the ratio of the worm  area to its perimeter
    STATS.Hydraulic = STATS.Area/STATS.Perimeter;

    %The Waddell disk diameter is the diameter of the disk with the same area 
    %as the worm
    %STATS.Waddel = 2 * sqrt( STATS.Area/pi);


    %% Features from rectangle with  same area and perimeter as the worm

    tprime = sqrt(STATS.Perimeter^2 - 16* STATS.Area );
    rectBigSide = 0.25*(STATS.Perimeter + tprime);
    rectSmallSide = 0.25*(STATS.Perimeter - tprime);
    STATS.RectBigSide = rectBigSide;
    STATS.RectRatio = rectBigSide/rectSmallSide;


    %% Inertia Features

    Mx = sum( STATS.PixelList(:,1 ))/STATS.Area; %Center of Mass of x
    My = sum( STATS.PixelList(:,2 ))/STATS.Area; %Center of Mass of y

    % Inertia with respect to y axis
    STATS.Ixx = sum(  STATS.PixelList(:,1 ).^2 ) - ( STATS.Area *(Mx^2 ));

    %Inertia with respect to x axis
    STATS.Iyy = sum(  STATS.PixelList(:,2 ).^2 ) - ( STATS.Area *(My^2 ));

    %Inertia with respect to X and Y
    STATS.Ixy = sum (STATS.PixelList(:,1).* STATS.PixelList(:,2)) - ...
                       STATS.Area* Mx *My;

     


     %% Width and thickness features

      % WidthMap  -  the width at each location along the skeleton
      % MaxWidth  -  the maximum width of the animal 
      % MaxWidthLocations - the locations along the skeleton where the animal
      %     has its maximum width
      % Thickness -  the width at the center pointof the skeleton

      %Distance transform reports in x-y coord frame
      distTransform = bwdist(~bwImage);  
      STATS.DistTransform = distTransform;
      STATS.MaxWidth = 2* max(max( distTransform));

      

    
end

