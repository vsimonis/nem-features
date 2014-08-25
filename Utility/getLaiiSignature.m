
function laii = getLaiiSignature(bwImage, kernelRadius)
         se = strel('disk', 1);
        bwImageFilled = bwmorph(bwImage, 'fill');
        bwImageFilled = imclose(bwImageFilled, se);
        dbBwImageFilled = double(bwImageFilled);
        
       
        [rr cc] = meshgrid(1:2*kernelRadius);
        C = sqrt(   (rr-kernelRadius).^2+(cc-kernelRadius).^2  )     <=kernelRadius;
        areaFilled = filter2(C, dbBwImageFilled);
        areaOfCircle = length(find(C));
        laii = areaFilled ./ areaOfCircle;
 end



