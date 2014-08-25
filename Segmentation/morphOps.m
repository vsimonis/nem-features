function [ imgOut ] = morphOps( imgIn, SizeSE )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%% Take the negative
imgOut = imcomplement(imgIn);


%% Keep largest connected component
temp = imgOut;
imgOut = zeros(size(imgIn));
CC = bwconncomp(temp, 4);
numPix = cellfun(@numel,CC.PixelIdxList);
[biggest, idx] = max(numPix);
imgOut(CC.PixelIdxList{idx}) = 1;

%% Morphological closing

SE = strel( 'disk', SizeSE,0);
imgOut = imerode(imdilate(imgOut, SE), SE);

%Note that an erosion can create more than one connected 
%out of  a single connected component, so we need to get the largest 
%connected component again.
temp = imgOut;
imgOut = zeros(size(imgIn));
CC = bwconncomp(temp, 4);
numPix = cellfun(@numel,CC.PixelIdxList);
[biggest, idx] = max(numPix);
imgOut(CC.PixelIdxList{idx}) = 1;
% imgOut = imgIn;

end

