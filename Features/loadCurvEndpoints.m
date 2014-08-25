function dl = loadCurvEndpoints(curvEndpoints, dl, i)
%LOADCURVENDPOINTS Summary of this function goes here

    if isempty(curvEndpoints)
         numEnds = 0;
    else
         numEnds = size(curvEndpoints,1);
    end

    if numEnds == 0
        dl(i).Curv_HeadRow = 1;
        dl(i).Curv_HeadCol = 1;
        dl(i).Curv_TailRow = 1;
        dl(i).Curv_TailCol = 1;
    elseif numEnds == 1
        dl(i).HeadCurvPtRow = 1;
        dl(i).HeadCurvPtCol = 1;
        dl(i).TailCurvPtRow = curvEndpoints(1,1);
        dl(i).TailCurvPtCol = curvEndpoints(1,2);
    elseif numEnds == 2
        
        localHeadRow = dl(i).HeadRow - dl(i).TotalOffsetRows;
        localHeadCol = dl(i).HeadCol - dl(i).TotalOffsetCols;
        localTailRow = dl(i).TailRow - dl(i).TotalOffsetRows;
        localTailCol = dl(i).TailCol - dl(i).TotalOffsetCols;
        
        index = assocLocation(curvEndpoints, [localHeadRow,localHeadCol; localTailRow, localTailCol];
        
        
        dl(i).HeadCurvPtRow = curvEndpoints(index(1),1);
        dl(i).HeadCurvPtCol = curvEndpoints(index(1),2);
        dl(i).TailCurvPtRow = curvEndpoints(index(2),1);
        dl(i).TailCurvPtCol = curvEndpoints(index(2),2);
        
        
    end

end

