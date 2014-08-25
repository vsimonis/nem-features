function diff = getSmallestAngleBetween( angleA, angleB)
%UNTITLED3 Summary of this function goes here
%   Calculates the smallest angle between two angles in degrees
   
 diff = angleA - angleB;
 diff = abs( mod(diff+180,360) - 180);
  

end

