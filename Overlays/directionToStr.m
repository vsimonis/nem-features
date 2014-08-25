function str = directionToStr( direction )
%DIRECTIONTOSTR Converts direction code to string 
%   Detailed explanation goes here
    if direction == 1
        str = 'Forward';
    elseif direction == 2
        str = 'Reverse';
    elseif direction == 0;
        str = 'NA';
    end

end

