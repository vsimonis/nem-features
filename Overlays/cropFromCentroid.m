function [ imOut] = cropFromCentroid( imIn, centroid, imOutSize)
%CENTROIDCROPPED Crop image around centroid
%   Input Arguments
%  imIn - the image to be cropped
%  centroid - Centroid in format [row col]
%  imOutSize - the size of the desireed image in formt [rows, cols] 

    [rows cols, ~] = size(imIn);
    
    centroidRow = centroid(1);
    centroidCol = centroid(2);
    
    imOutRows = imOutSize(1);
    imOutCols = imOutSize(2);
    
    %The imcrop function uses cartesian coords, not row col format:
    upperLeftX = floor( centroidCol - 0.5*imOutCols -1 );
    upperLeftY = floor( centroidRow - 0.5*imOutRows -1 );
    
    %Adjust the crop window if the window is not on the image
    
    if upperLeftX < 1
        upperLeftX = 1;
    end
   if upperLeftY < 1
        upperLeftY = 1;
   end
   if upperLeftX + imOutCols -1 > cols
       upperLeftX = cols - imOutCols + 1;
   end
   if upperLeftY + imOutRows -1 > rows
       upperLeftY = rows - imOutRows + 1;
   end
        
    %Note the retange is specified in terms of spatial coordinates, not
    %pixels and is of the form minx, miny, width, height
     imOut = imcrop(imIn,[upperLeftX, upperLeftY, imOutCols, imOutRows ]) ;

   
    %Because the rectangle is specified in terms of spatial coordinates, the
    %resulting output image may be one pixel in either direction larger
    %than the specified height in width.  The output image ncludes all 
    %pixels in the input image that are completely or partially enclosed by
    %the rectangle.
    if size(imOut,1)  > imOutSize(1)
        
        %Delete the last row
        imOut(size(imOut,1),: ,:) = [];
    end
    if size(imOut,2)  > imOutSize(2)
        
        %Delete the last col
       imOut(:, size(imOut,2),:) = [];
    end
    
    % If the size of imout is too small, it was cropped to fit the image edge.
    % Add in padding to fit the desired otuput size. 
    actualSize = size(imOut);
    
    padsize = imOutSize - actualSize(1:2);
    padsize(padsize < 0) = 0;
    if max(max(padsize)) > 0
            
        imOut = padarray(imOut,padsize);
    end

end

