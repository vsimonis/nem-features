function result = getMeanSktpMovement(dataList,n, seqNum)
    %GETMEANSKTPMOVEMENT Returns ave over last n observations
    
    %   If observations is less than n, then takes ave over all observations. 
    if  seqNum > n
       result = mean([dataList(seqNum - n: seqNum).SktpMovement]);
    else
        result = mean([dataList(1: seqNum).SktpMovement]);
    end
end

