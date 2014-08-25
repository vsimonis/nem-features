function [ result] = isLoop( bwImage )
%ISLOOP returns integer indicating if worm is looped, and the loop type
  
 eulerNumber = bweuler(bwImage);
 result = 0;
 if eulerNumber ~= 1    %then loop
    result = 1; 
 end
     

