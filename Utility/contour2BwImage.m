function bwImage = contour2BwImage(contour, imageSize)
        
    % contourStr is in format: '12;45|34;56|34;67'
    % imageSize is format: [row,col]
        
    %Create an image of all logical zeros
    bwImage = false(imageSize);

   
    %Find the linear indices of the contour row and column subscripts
    indices = sub2ind(imageSize,contour(:,1), contour(:,2) );

    %Set the contour to logical one
    bwImage(indices) = 1;

    %Fill in the contour to create a bw image 
    bwImage = imfill(bwImage, 'holes');
end
