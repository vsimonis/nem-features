function z = getDist( V1, V2 )
%GETDIST REturns the distances between pairs of points
%   Input is two nx2 column vectors of points 
    z = sqrt( (( V1(:,1) - V2(:,1) ).^2) + (( V1(:,2) - V2(:,2)).^2));

end

