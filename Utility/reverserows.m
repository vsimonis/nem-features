function [ matB ] = reverserows( matA )
%REVERSEROWS Reverses the order of rows in a matrix
%   Reverses the order of an n x2 column vector
  
   rows = size(matA, 1);
   matB = zeros(size(matA));
   matB(1:rows, :) = matA(rows:-1:1, :) ;

end

