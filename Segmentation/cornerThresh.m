function [bwImage, flag] = cornerThresh(imIn, estArea, seSize)
%CORNERTHRESH - Returns a segmented image and flag indicating loop posture
    
   %% Determine level based on the minimum intensity of the background
   [rows, cols] = size(imIn);
   
   %The background is sampled at four corners
   level1 = mean(mean( imIn(1:200, 1:200) )); 
   level2 = mean(mean( imIn(1:200, cols-200:cols) )); 
   level3 = mean(mean( imIn(rows-200:rows, 1:200) )); 
   level4 = mean(mean( imIn(rows-200:rows, cols-200:cols))); 
   level = min( [level1,level2,level3,level4] ); 
   thres = level/256; 
   bwImage = im2bw(imIn, thres);
   
   %Do a closing operation to smooth the contour
    bwImage = ~bwImage;
    se = strel('disk', 2,0);
    bwImage = imclose(bwImage, se);
    
    %Select the connected component closest to size of the estimated area
    bwImage = imclose(bwImage, se);
    x = regionprops(bwImage,'Area','Centroid', 'PixelList');
    dist = abs([x.Area] - estArea);
    idx = find(dist == min(dist ));
    y = x(idx).PixelList;
    indices = sub2ind(size(bwImage),y(:,2), y(:,1));
    newImage = false(size(bwImage));
    newImage(indices) = 1;
    bwImage = newImage;
    
    
    
    %Deal with cases where the segmentation has holes 
    flag = isLoop(bwImage);
    if flag
        bwImage = keepOnlyLargestHole(bwImage);
    end
    

    
    
   end

