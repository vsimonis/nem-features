function [ indices ] = assocLocations( listA, listB )
%ASSOCLOCATIONS associates two sets of points by  Euclidean distance

%Pairs points from list A abd list B by minimum Euclidean distance.

%Obtain a  matrix D where rows represent each element in listA and
 %columns represent elements in listB.  D contains the 
 %distance from each element in listA to each element in listB.  
 D = pdist2(listA, listB, 'euclidean');
 
 % Finds the index of each point in listA that is closest to each point in list B
 % If two points are equidistance, the first index is selected.
 indices =[];
 for i = 1: size(D,2)
     index = find(D(:,i) == min(D(:,i)));
     indices = [indices, index(1)];
    
 end

end

