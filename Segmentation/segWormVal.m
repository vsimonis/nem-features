
function [imgOut] = segWormVal(imgIn)

T = threshAUHist(imgIn, 3250,10);
%T = threshAUHist(imgIn, 4223,19);
imgOut = morphOps(T, 3);

end

