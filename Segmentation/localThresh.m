function bwImage = localThresh(position, meanArea, windSize, imIn)
%Calculates new position based on the centroid of a window surrounding the 
%old position
 if iDatarow == 1
%                     position = env.EstPosition;  
%                     estArea = env.EstArea; 
%                 else
%                     position = [dataList(iDatarow-1).CentroidRow, dataList(iDatarow-1).CentroidCol];
%                     estArea = dataList(iDatarow-1).Area;
%                 end
%                 windowSize = env.WindowSize;  
%                 bwImage = localThresh(position, estArea, windowSize, gsImage);
%                 %Segment the image and get black and white frame
%                 %bwImage = segFunct(gsImage);
    [rows cols, ~] = size(imIn);
    
  
    
    
   %% Determine level based on a window around the worm 
  
%     rowPos = position(1);
%     colPos = position(2);
%     windRows = windSize(1);
%     windCols = windSize(2);
%     
%       
%     %The imcrop function uses cartesian coords, not row col format:
%     beginCol = floor( colPos - 0.5*windCols -1 );
%     endCol = floor( colPos + 0.5*windCols -1 );
%     beginRow = floor( rowPos - 0.5*windRows -1 );
%     endRow = floor( rowPos + 0.5*windRows -1 );
%     
%     %Adjust the  window if the window is not on the image
%     
%     if beginCol < 1
%         endCol = endCol - beginCol;
%         beginCol = 1;
%     end
%    if endCol > cols
%         beginCol = beginCol - (endCol - cols);
%         endCol = cols;
%    end
%    if beginRow < 1
%        endRow = endRow - beginRow;
%        beginRow = 1;
%    end
%    if endRow > rows
%        beginRow = beginRow - (endRow - rows);
%        endRow = rows;
%    end
%    [level, em] = graythresh( imIn(beginRow:endRow, beginCol:endCol) ); 
%    bwImage = im2bw(imIn,level);
    
   %% Determine level based on the minimum intensity of the background
   
    
   level1 = mean(mean( imIn(1:200, 1:200) )); 
   level2 = mean(mean( imIn(1:200, cols-200:cols) )); 
   level3 = mean(mean( imIn(rows-200:rows, 1:200) )); 
   level4 = mean(mean( imIn(rows-200:rows, cols-200:cols))); 
   level = min( [level1,level2,level3,level4] ); 
   thres = level/256; 
   bwImage = im2bw(imIn, thres);
   
   
    
    bwImage = ~bwImage;
    se = strel('disk', 2,0);
    bwImage = imclose(bwImage, se);
    %bwImage = imfill(bwImage);
    x = regionprops(bwImage,'Area','Centroid', 'PixelList');
    dist = abs([x.Area] - meanArea);
    idx = find(dist == min(dist ));
    y = x(idx).PixelList;
    indices = sub2ind(size(bwImage),y(:,2), y(:,1));
    newImage = false(size(bwImage));
    newImage(indices) = 1;
    bwImage = newImage;
    
%     for i = 1: length(x)
%         centroid = x(i).Centroid;
%         area(i) = x(i).Area;
%         if area(i) > 2000 && area(i) < 3000
%             index = i;
%         end
%     end
    
    
    
    
   end

