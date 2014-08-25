function  newList  = extendList( list1,list2, estLength )
%EXTENDLIST  Adds pixels from list2 to list1 until estimated total length
%is reached

%Get length of first segment
length = 0;
 for i = 2:size(list1,1)
     A = list1(i,:);
     B = list1(i-1,:);
     length = length + getDist(A,B);
 end
 
  %Add pixels to list until estimated total length is reached
  newList = list1;
  
  
  for j = 2:size(list2,1);
      length = length + getDist(newList(size(newList,1),:), list2(j,:) );
     if length < estLength
         newList = [newList;list2(j,:)];
     else
         break;
     end
  end
  
end

