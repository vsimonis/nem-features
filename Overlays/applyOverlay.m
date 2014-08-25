function  imgOut  = applyOverlay(rgbImage, indices, theColor )
%APPLYOVERLAY Set the color of pixles in RGB image based on linear indices

%   Input Arguments
%
%   rgbImage - a rgb color image
%   indices - linear indices into the image (not row/col subscripts)
%   theColor - a string representng the color the pixels will be set to
%
%   Outout Arguments
%
%   imgOut - a rgb color image w

    redSlice = rgbImage(:,:,1);
    greenSlice = rgbImage(:,:,2);
    blueSlice = rgbImage(:,:,3);
    
    %Add colors to the color chart by adding rows to the cell array
    colorChart = { ...
        {'red', 255,0,0};...
        {'green',0,255,0};...
        {'blue',0,0,255};...
        {'orange',255,165,0};...
        {'white',255,255,255}...
        };
        
    %Search the color chart for a string matchng the color, and set the
    %pixels represented by the linear indices in the red, green, or blue 
    %slices to the correpsonding values in the chart
    for i = 1: size(colorChart,1)
        colorRow = colorChart{i};
        if strcmp(theColor, colorRow{1})
            redSlice(indices)= colorRow{2};
            greenSlice(indices)= colorRow{3};
            blueSlice(indices) = colorRow{4};
            break;
        end
    end
    
    %Recombine the red, green, and blue slices.
    imgOut = cat(3, redSlice, greenSlice, blueSlice);
    
end

