function [ imgOut ] = threshAUHist( imgIn, avg, sd )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%global inum;
imgOut = zeros(size(imgIn, 1), size(imgIn, 2));
%% Gray level histogram
[pixelCount grayLevel] = imhist(imgIn);
auh = 0;
glv = 2;
%glv = 1;

while (auh < avg + sd) & (glv < 255)
   auh = auh + pixelCount(glv);
   glv = glv + 1;
end

thresh = glv - 1;

imgOut = applyThresh(imgIn, thresh);
%imwrite(imgOut, sprintf('AUHIST-%d.jpeg', inum));


end

