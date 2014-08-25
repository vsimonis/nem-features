function  v = getVectors( A,B, rows )
%GETVECTOR  Generates vector from A to B
%  
   

x1 =A(:,2);
y1 = rows - A(:,1);
x2 =B(:,2);
y2 = rows - B(:,1);

v = [x2 - x1, y2 - y1];

end

