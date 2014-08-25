function pixelString = subToStr( sktp )
%SKTPTOSTRING Convert list of skeleton points to a string
%  Row and col are delimited by a semicolon and pixels are delimited by a 
% pipe

numPoints = size(sktp,1);
pixelString = '';

for i = 1:numPoints
    newPixel = sprintf('%s;%s', num2str(sktp(i,1)), num2str(sktp(i,2) ));
    pixelString = sprintf('%s|%s', pixelString, newPixel);
    
end

