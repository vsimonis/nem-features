function [ phi, theta] = getLineAngles( pixelA, pixelB, rows)
%UNTITLED2 Summary of this function goes here
%   theta - angle to rotate the line so end B is at the origin (left)
%   phi - the angle of the vector AB with respect to the horizontal
%   measured  counterclockwise

    ptAx = pixelA(1,2);
    ptAy = rows - pixelA(1,1);
    ptBx = pixelB(1,2);
    ptBy = rows - pixelB(1,1);

    %% Calculate the rotation angle 
    yDiff = ptBy -ptAy;
    xDiff = ptBx - ptAx;
    
    % ...head (B) is  in upper left 
    if xDiff < 0 && yDiff > 0
        
        theta = atand( abs(yDiff/xDiff));
        phi = 180 - atand( abs(yDiff/xDiff));
    % ... head (B) is in upper right quadrant
    elseif xDiff > 0 && yDiff > 0 
        theta = 180 - atand( abs(yDiff/xDiff) );
        phi =  atand( abs(yDiff/xDiff) );
     % ... head is in botton left quadrant
    elseif xDiff < 0 && yDiff < 0 
        theta = - atand( abs( yDiff/xDiff)) ;
        phi = 180 + atand( abs( yDiff/xDiff));
     % ... head is in botton right quadrant
    elseif xDiff > 0 && yDiff < 0 
         theta = 180 + atand( abs(yDiff/xDiff) );
         phi = 360 - atand( abs(yDiff/xDiff) );
    elseif xDiff == 0 && yDiff < 0
        phi = 270;
        theta = -90;
    elseif xDiff == 0 && yDiff > 0
        phi = 90;
       theta = 90;
    elseif xDiff  < 0 &&  yDiff == 0 
        phi = 180;
        theta = 0;
    elseif xDiff  > 0 &&  yDiff == 0  
        phi = 0;
        theta = 180;
    elseif xDiff == 0 && yDiff == 0
        phi = 1000;
        theta = 1000;
    end

end

