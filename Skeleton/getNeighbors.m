function [ neighbors ] = getNeighbors( image, pixel)
%GETNEIGHBORS Summary of this function goes here
%   Detailed explanation goes here

        %Get the rows and columns of the image that make up the
        %neighborhood
        neighRows = [pixel(1,1)-1: pixel(1,1)+1];
        neighCols = [pixel(1,2)-1 :pixel(1,2)+1];
        
        %Create a 3 x 3 matrix containing a one where there is a neighbor
        % and a zero elesewhere 
        neighborhood = image(neighRows,neighCols);
        neighborhood(2,2) = 0;
       
        %If there is a one in the matrix find its row and column in the 
        % 3 x 3 matrix.  
        [row,col] = find(neighborhood);
        
        if isempty(row)
            neighbors = [];
        else
            %Create a list fo displaements for the neighbors by subtracting
            %2 from each row and column subscript of the 3 x3 matrix 
            displacement = [row-2,col-2];
            
            %Determien the neighbor subscripts by adding the displacement
            %to the original pixel location
            numNeighbors = size(displacement,1);
            neighbors =  displacement+repmat(pixel,[numNeighbors , 1]);
        end
end

