


function dotIndices = getDotIndices( imageSize, dotPosition, dotRadius)
%GETDOTINDICES Returns the linear indices of a dot of specified size and
%location on an image
%
%  Input ArgumentseSize
%
%  imageSize = image size in [rows,cols]
%  dotPosition = center of dot in format [row,col]
%  dotRadius = the radius of the dot in pixels
        
        rows = imageSize(1);
        cols = imageSize(2);
        [rr cc] = meshgrid(1:cols,1:rows);
        colPos = dotPosition(1);
        rowPos = dotPosition(2);
        C = sqrt(   (rr - rowPos).^2+ (cc - colPos).^2  )  <= dotRadius;
        dotIndices = find(C);
      
end

