function neighborhood = getNeighborhood(pixel);
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

  d = [ 1 0; -1 0; 1 1; 0 1; -1 1; 1 -1; 0 -1; -1 -1]; 
  neighborhood = d+repmat(pixel,[8 1]);
end

