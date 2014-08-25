function [ imgOut ] = segWormHist( imgIn )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%% Gray level histogram

%http://www.mathworks.com/matlabcentral/
%answers/83437-how-do-i-find-the-maximum-and-minimum-of-a-histogram-in-matlab
imgOut = zeros(size(imgIn, 1), size(imgIn, 2));
%imgOut = imgIn;
% Maximum value in histogram is BG
[pixelCount grayLevel] = imhist(imgIn);
indMaxBG = find( pixelCount == max(pixelCount));
BGlevel = grayLevel(indMaxBG);
 



%% Nearest minimum below this maximum is threshold 
d1 = zeros(size(pixelCount));

for i = 2:size(pixelCount) - 1
    d1(i) = pixelCount(i+1) - pixelCount(i);
end

neighborhood = min(size(pixelCount - indMaxBG), indMaxBG);

i = 1;
while(d1(indMaxBG - i) > 0)
    posNearMinIndexL = indMaxBG - i;
    i = i + 1;
end

thresh = grayLevel(posNearMinIndexL);

ind = find(imgIn > thresh);
imgOut(ind)= 1;



%% Edge detection

%% Morphological closing
imgOut = imcomplement(imgOut);


SE = strel('disk', 3, 0);
imgOut = imclose(imgOut,SE);
imgOut = bwmorph(imgOut,'close',1);

%Fill in holes in the foreground image
imgOut = imfill(imgOut, 'holes');



%% Keep largest connected component
temp = imgOut;

imgOut = zeros(size(imgIn, 1), size(imgIn, 2));

CC = bwconncomp(temp, 4);
numPix = cellfun(@numel,CC.PixelIdxList);
[biggest, idx] = max(numPix);
imgOut(CC.PixelIdxList{idx}) = 1;





%% Reference: 2012 -- 
% "Locomotion Analysis identifies roles
% of mechanosensory neurons in governming locomotion dynamics
% of C. elegans"

end

