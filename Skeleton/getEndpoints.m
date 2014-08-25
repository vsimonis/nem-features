function endpoints = getEndpoints( skelImage )
%GETENDPOINTS Get a n x 2 matrix of endpoint pixels
%  Given a binary image of a skeleton, returns an n x 2 list of endpoint
%  pixels, where n is the number of pixels.
%
     x = bwmorph(skelImage, 'endpoints');
     [row ,col ] = find(x);
     endpoints = [row col];

end

