function [ index ] = getLineSegmentIndices(bwImage, A,B)
%GETLINESEGMENTINDICES  Get linear indices for line segment betweeen two
%points in an imag
%
%   Input Arguments
%
%   bwImage - binary image 
%   A - pixel endpoint A
%   B - pixel endpoint B
%
% Return Value
%
% index - the linear index of pixels representing the line segment

     
    %Get the image size
    [r,c] = size(bwImage);                 
    
    %Get a set of row points for the line
    rpts = linspace(A(1,1),B(1,1),100);   
    
    %Get a set of column points for the line 
    cpts = linspace(A(1,2),B(1,2),100);   
    
    %Get a linear index for the line
    index = sub2ind([r c],round(rpts),round(cpts));  
    index = unique(index);
end

