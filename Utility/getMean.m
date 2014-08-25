function result = getMean(dataList,variable, startIndex, endIndex) 
    %GETMEAN Returns ave over last n observations of specified variable
    
    %   If observations is less than n, then takes ave over all observations.
    if startIndex <=0
        startIndex = 1;
    end
    if endIndex > length(dataList)
        endIndex = length(dataList);
    end
    result = mean([dataList(startIndex: endIndex).(variable)]);
    
end

