function length = getLengthFromPixels( list )
%GETLENGTHFROMPIXELS Returns the Euclidean length

length = 0;
 for i = 2:size(list,1)
     A = list(i,:);
     B = list(i-1,:);
     length = length + getDist(A,B);
 end
end

