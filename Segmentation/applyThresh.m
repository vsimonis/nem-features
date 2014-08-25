function [ imgOut ] = applyThresh( imgIn, t )
%APPLYTHRESH Applies threshold t to imgIn and returns imgOut

imgOut = zeros(size(imgIn, 1), size(imgIn, 2));
% ind = find(imgIn > t);
% imgOut(ind)= 1;

imgOut(imgIn > t)= 1;

end

