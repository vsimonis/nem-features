function [ result ] = isNeighbor( pixel1, pixel2 )
%ISNEIGHBOR Given two pixel locations, determines whetehr the two pixels 
% neighbors.  
 
    result = 0;
    d = [ 1 0; -1 0; 1 1; 0 1; -1 1; 1 -1; 0 -1; -1 -1]; 
    neighbors = d+repmat(pixel1(1,:),[8 1]);
    index = ismember(pixel2, neighbors, 'rows');
    if ~isempty(find(index))
        result = 1;
    end

end

