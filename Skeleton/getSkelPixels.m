function [ sktp ] = getSkelPixels( imSkel )
%getSkelPoints Returns a list of subscripts for points on a skeleton image
%
%   Input Arguments
%
% imSkel - a black and white image of the skeleton
    %Get an image with the skeleton endpoints
     x =  bwmorph(imSkel,'endpoints');

     %Get the endpoint coordinates for the skeleton
     [row, col] = find(x);
     endpoints = [row col];

     %Trace the boundary starting at the first endpoint.  This will trace the
     %skeleton twice, and return a list of rows and cols
     sktp = bwtraceboundary(imSkel, endpoints(1,:),'E');

     if size(endpoints,1) ==1
         sktp = endpoints;
     else
         %Truncate the list of points after the second endpoint
         [~,Locb] = ismember(endpoints(2,:),sktp,'rows'); 
         sktp = sktp(1:Locb, :);
     end
  

end

