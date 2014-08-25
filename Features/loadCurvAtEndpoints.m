function dl = loadCurvAtEndpoints(curvEndpoints, peaks, dl, i)
%LOADCURVATENPOINTS - Load s data list with the curv at the worm ends.

%  Curvature is calculated using the Local Area Integral Invariant
%  signature with the circular kernel centered at the endpoint. 

    try
        
        localHeadRow = dl(i).HeadRow - dl(i).TotalOffsetRows;
        localHeadCol = dl(i).HeadCol - dl(i).TotalOffsetCols;
        localTailRow = dl(i).TailRow - dl(i).TotalOffsetRows;
        localTailCol = dl(i).TailCol - dl(i).TotalOffsetCols;
        
        index = assocLocation(curvEndpoints, [localHeadRow,localHeadCol; localTailRow, localTailCol];
        dl(i).LaiiHead = peaks(index(1),:);
        dl(i).LaiiTail = peaks(index(2),:);
    catch e
         dl(i).LaiiHead = 0;
         dl(i).LaiiTail = 0;
   end
end

