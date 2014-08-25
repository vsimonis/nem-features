function [ globalPixels ] = localToGlobal( localPixels, totalOffset )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    globalPixels = localPixels + repmat(totalOffset,size(localPixels,1),1);
end

