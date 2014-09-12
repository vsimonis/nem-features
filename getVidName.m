function [ vidName ] = getVidName( currentdir )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

for file = dir(currentdir)'
        if ~isempty(strfind(file.name, '.avi'))
            vidName = sprintf('%s\\%s', currentdir,file.name);
        end
end
end

