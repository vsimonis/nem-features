function config = getSkelGraphConfig( endpoint, branchpoint, segments)

 % GETSKELGRAPHCONFIG - Identifies whether the topology of a looping
 % nematode skeleton  consists of one loop with two branche off of
 % it (configuration one), or two brnaches connected to one branch, 
 % which is connected to the loop (configuration 2).  The two topologies
 % represent the allowable topologies for a nematode in a loop with two 
 %brnaches visible 
    
    %1 - Both segmentes connect directly to loop 
    
    
    %Get the number of endpoints
    endpoint1 = endpoint(1,:);
    endpoint2 = endpoint(2,:);

      
        
    usedSegments = [];

    %Identify segments 1 and 2 that have the endpoints
    for k = 1:length(segments)

        pixelList = segments(k).PixelList;

        %Segment 1 is associated with endpoint 1
        if ~isempty(find(ismember(endpoint1,pixelList,'rows')))
            segment1 = pixelList;
            usedSegments = [usedSegments,k];

         %Segment2 is associated with endpoint 2
        elseif  ~isempty(find(ismember(endpoint2,pixelList,'rows')))
            segment2 = pixelList;
            usedSegments = [usedSegments,k];
        else
            %do nothing
        end
    end
            
    %Determine which configuration by determining whether segment 1 and 2
    %connect to the same branchpoint
    if (    isequal( ismember(branchpoint(1,:), segment1,'rows'),[1])...
          && isequal(ismember(branchpoint(1,:), segment2,'rows'),[1]))...
            ||...
        (    isequal(ismember(branchpoint(2,:), segment1,'rows'),[1])...
          && isequal(ismember(branchpoint(2,:), segment2,'rows'),[1]) )

        config =2; % 'omega';
    else
        config = 1; %'gamma';
    end
   
  
end

