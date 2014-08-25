function rgbImage = gray2rgb( grayScaleImage )
%GRAY2RGB Convert gray scale image to RGB image format

    %Reproduce the image in a third dimension 
    rgbImage = repmat(grayScaleImage,[1 1 3]);
    
end

