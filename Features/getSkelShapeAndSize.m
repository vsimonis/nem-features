function [ STATS ] = getSkelShapeAndSize( segmentedArea, distTransform, sktp )
%getShapeAndSize = returns shape and size features 
%   
% Input Arguments:
%
% bwFrame - logical image
% skeleton - iimage of the skeleton
% sktp - list of pixels in the skeleton
% 
% Returns - structure with shape and size features

   
    

      %% Length Features

       %The perimeter property of the built-in Matlab function counts each pixel
    %twice, so we divide by two to get the Quasi-Euclidean length
    STATS.Length = getLengthFromPixels(sktp);
    STATS.SkelNumPixels = size(1,sktp);
    STATS.LengthToPixels = STATS.Length / STATS.SkelNumPixels;


     %% Width and thickness features

     STATS.Fatness = segmentedArea/STATS.Length;

      %Calculate the thickness at the center point of the skeleton
      skelCenterPtIndex = floor(STATS.SkelNumOfPixels/2);
      centerPointCoords = sktp(skelCenterPtIndex, :);

      STATS.Thickness = 2 * distTransform(centerPointCoords(1,1), centerPointCoords(1,2));

end

