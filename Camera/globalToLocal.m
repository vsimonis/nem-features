function [ localPixels ] = globalToLocal( globalPixels, totalOffset )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    localPixels = globalPixels - repmat(totalOffset,size(globalPixels,1),1);

end

