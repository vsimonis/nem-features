function [ imOut] = keepOnlyLargestHole(bwImage)
%UNTITLED Summary of this function goes here
%   Assumptions
   compImage = ~bwImage;
   filledObject = imfill(bwImage, 'holes');
   filledObjectProps = regionprops( filledObject, 'Area','PixelIdxList');
   holes = regionprops(compImage, 'Area','PixelIdxList');
   
   %For each identified background region
   removeIdxList = [];
   maxArea = 0;
   maxAreaIndex = 0;
   
   for i = 1:length(holes)
        %Check to make sure it is not the surrounding background
       if holes(i).Area < filledObjectProps.Area
         x =  ismember(holes(i).PixelIdxList, filledObjectProps(1).PixelIdxList);
         if isempty(find(~x))
             if holes(i).Area > maxArea
                 maxArea = holes(i).Area;
                 if maxAreaIndex ~= 0
                      removeIdxList = [removeIdxList; holes(maxAreaIndex).PixelIdxList];
                 end
                 maxAreaIndex = i;
             else
                 removeIdxList = [removeIdxList; holes(i).PixelIdxList];
             end
         end
       end
   end
   
    bwImage( removeIdxList) = 1;
    imOut = bwImage;
    
             
   
    

end

