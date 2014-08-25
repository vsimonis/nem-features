function segment = getSegmentLists(imSkel)

    branchpoints = bwmorph(imSkel, 'branchpoints');
    [row ,col]  = find(branchpoints);
    branchpoint = [row,col];

    endpoint = getEndpoints(imSkel);
    
    %For each branchpoint

    %The branchpoint along with its neighbors define trajectories along
    %different edges of the graph. An edge is defined by beginning an
    %ending branchpoints and neighbors.
    edges = [0,0,0,0,0,0,0,0];
    index = 1;

    for i = 1:size(branchpoint,1)
	
   
        %A segment is defined as all pixels from one end of the edge to another
        branchNeighbors = getNeighbors(imSkel, branchpoint(i,:));

        if ~isempty(branchNeighbors)

            %For each neighbor of the branchpoint (defines a rajectory)
            for j = 1: size(branchNeighbors, 1)

                % if this trajectory is not on an existing defined edge of the graph
                if  isempty(find(ismember([branchNeighbors(j,:),branchpoint(i,:)] , edges(:, end-3: end), 'rows')))...
                    
                     %Initialize the trajectory 
                     pixelList = [branchpoint(i,:); branchNeighbors(j,:)];

                     %Determine if the branchpoint neighbor is itself a
                     %branchpoint or an endpoint, and if so, save the current
                     %list
                     y = find(ismember(branchNeighbors(j,:), endpoint,'rows'));
                     x = find(ismember(branchNeighbors(j,:), branchpoint,'rows'));

                     if ~isempty(x) || ~isempty(y)

                        segment(index).PixelList = pixelList;
                        edges = [edges;[pixelList(1,:), pixelList(2,:), pixelList(end-1,:), pixelList(end,:)]];
                        index = index + 1;
                     else

                         endLoop=0;
                         while endLoop == 0

                             neighbors = getNeighbors(imSkel,pixelList(end,:));

                             %remove old neighbors and last pixel from the neighbors list
                             [~,prevEndInd] = ismember(pixelList(end-1,:),neighbors , 'rows'); 

                             %Select horizontal or vertical moves before
                             %selecting diagonal moves.  If a diagonal move is
                             %required, it must be a move away from the the
                             %pixel prior to he current pixel. 
                             distFromCurrent = zeros(size(neighbors,1),1);
                             for k = 1:size(neighbors,1)
                                 if k == prevEndInd
                                    distFromCurrent(k,1) = 2;
                                 else
                                    distFromCurrent(k,1) = getDist(pixelList(end,:), neighbors(k,:));
                                 end
                             end
                             minDist = min(distFromCurrent);
                             if minDist == 1
                                minIndex = find(distFromCurrent == min(distFromCurrent(:)));
                                newPixel = neighbors(minIndex,:);
                                pixelList = [pixelList; newPixel];
                             else
                                prevNeighbors =  getNeighbors(imSkel, pixelList(end-1,:));
                                z = ismember(neighbors, prevNeighbors,'rows');
                                prevNeighInd = find(z);
                                removeInd = prevEndInd;
                                if ~isempty(prevNeighInd)
                                    try
                                    removeInd = [removeInd,transpose(prevNeighInd)];
                                    catch
                                        disp(i);
                                    end
                                    %neighbors = removerows(neighbors,'ind', prevNeighInd);
                                end
                                newPixelInd = setdiff(1:1:size(neighbors,1), removeInd);
                                newPixel = neighbors(newPixelInd,:);
                                pixelList = [pixelList; newPixel];
                             end

                             x = find(ismember(pixelList(end,:), branchpoint,'rows'));
                             y = find(ismember(pixelList(end,:), endpoint,'rows'));
                            if ~isempty(x) || ~isempty(y)

                                segment(index).PixelList = pixelList;
                                edges = [edges;[pixelList(1,:), pixelList(2,:), pixelList(end-1,:), pixelList(end,:)]];
                                index = index + 1;
                                endLoop = 1;
                            end

                         end
                    end
                end
            end		
        end	
    end
end
