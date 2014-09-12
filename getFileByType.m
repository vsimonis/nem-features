function [ filename ] = getFileByType( currentdir, str )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

for file = dir(currentdir)'
        if ~isempty(strfind(file.name, str))
            filename = sprintf('%s\\%s', currentdir,file.name);
        end
end
end