function [segment, endpoints, branchpoints, curvEndpoints, peaks] = getSkelSegments(bwImage, env, isLoopPosture);
%REMOVEMINENDSEGMENT Removes the end segment from skeleton with min num of
%pixels. 

%   Removes the ends segment from an existing binary image of a skelton
%   that has the minimum number of pixels.  An end segment is defined as a
%   segment containing an endpoint.
%   Returns a binary image of the skeleton ande a nx2 list of pixel
%   subscripts, with each row representing an endpoint. 

%% Get the skeleton

 %Get the skeleton with spurs
    skeleton = bwmorph(bwImage, 'skel', inf);

 %% Pre-process to get skeleton one pixel in width throughout
    
% %Remove a pixel from 3x2 and 3x3 blocks that sometimes form when more 
% %than one branch spur comes from branchpoints that are adjacent.
% skeleton = filter3by3Blocks(skeleton);
% skeleton = filter3by2Blocks(skeleton);

skeleton = bwmorph(bwImage,'thin',inf);

%Get the branchpoints 
bp = bwmorph(skeleton, 'branchpoints');
[row ,col]  = find(bp);%Get endpoints
branchpoints = [row,col];

%Get endpoints
endpoints = getEndpoints(skeleton);

%Get a structure array of pixels in each segment, excluding branchpoints
if isempty(branchpoints)
        
    segment.PixelList = getSkelPixels(skeleton);
else
    segment = getSegmentLists( skeleton);
end

 %Get the endpoints based on the curvature of the bw image
 [curvEndpoints, peaks] =  getEndpointsFromCurvature(bwImage, ...
                                                    env.KernelRadius,... 
                                                    env.Sigma, ...
                                                    env.Threshold,...
                                                    env.SigmaAdjusted);	

%% if it is a loop, first use special processing to determine good segments

if isLoopPosture

    %Obtain a  matrix D where rows represent each skeleton endpoint and
    %columns represent endpoints identified by curvature.  D contains the 
    %distance from each skeleton endpoint to each curvature endpoint.  
    D = pdist2(endpoints, curvEndpoints, 'euclidean');

    %Find the index of the skeleton endpoints that is closest to each
    %curvature endpoints.
    indexMatches =[];
    for i = 1: size(D,2)
            index = find(D(:,i) == min(D(:,i)));
            indexMatches = [indexMatches, index(1)];
          
    end


    %Delete the segments with endpoints that are not associated with the
    % curvature endpoints

        for i = 1:length(segment)

            %If the segment contains an endpoint, and that endpoint is not
            %assocated with a curvature endpoint, delete the segment 
            if ~isempty(find(ismember(endpoints,segment(i).PixelList,'rows'),1))   && ...
                    isempty(find(ismember(endpoints(indexMatches,:),segment(i).PixelList,'rows'),1)) 

                    pixels = segment(i).PixelList;
                    indices = sub2ind(size(bwImage), pixels(:,1), pixels(:,2) );
                    skeleton(indices) = 0;

            end
        end


        %The segments includes the branchpoints, so add the branchpoints back
        %in
        indices = sub2ind(size(bwImage), branchpoints(:,1), branchpoints(:,2) );
        skeleton(indices) = 1;

        %Get the new skeleton
        skeleton = bwmorph(skeleton, 'skel', inf);
        endpoints = getEndpoints(skeleton);

        bp = bwmorph(skeleton, 'branchpoints');
        [row ,col]  = find(bp);%Get endpoints
        branchpoints = [row,col];

        segment = getSegmentLists( skeleton);
end


if size(endpoints,1) > 2

    %Create a table for segment information

    segmentTable = zeros(length(segment),5);
    for segmentInd = 1:length(segment)
        pixelList = segment(segmentInd).PixelList;
        numPixels = size(pixelList,1);

        %Determine the branchpoints and endpoint that are associated with 
        %each segment
        [~,bp1] = ismember( pixelList(1,:), branchpoints, 'rows');
        [~,bp2] = ismember( pixelList(end,:), branchpoints, 'rows');
        [~,ep1] = ismember( pixelList(1,:), endpoints,'rows');
        [~,ep2]= ismember( pixelList(end,:), endpoints, 'rows');

        segmentTable(segmentInd,:) = [bp1, bp2, ep1, ep2, numPixels];
    end

    numEndpoints = size(endpoints,1);
    while numEndpoints > 2

        %Find segment in the matrix with an endpoint by 
        z1  = find(segmentTable(:,3) );
        z2 = find(segmentTable(:,4) );
        z = [z1;z2];
        indOfRowsWithEps = unique(z);
        rowsWithEps= segmentTable(indOfRowsWithEps,:);

        %concatenate the orignal index of the table to the front of each
        %row
        rowsWithEps = [indOfRowsWithEps,rowsWithEps];

        %Find the segment with endpoints that has minimum length
        minEpSubtableInd  =  rowsWithEps(:,6) == min(rowsWithEps(:,6));
        deleteSegInd = rowsWithEps(minEpSubtableInd, 1);

        %Take the first index to delete
        deleteSegInd = deleteSegInd(1,1);

        %Find the branchpoint ind that the deleted segment connects with
        bpInd = segmentTable(deleteSegInd,1:2);
        bpInd = bpInd(bpInd > 0);

        %Find index of other segments with this branchpoint
        x1 = segmentTable(:,1);
        y1 = find(x1 == bpInd);
        x2 = segmentTable(:,2);
        y2 = find(x2 == bpInd);
        z = [y1;y2];
        z = z(z ~= deleteSegInd);
        segWithSameBp = unique(z);


        if size(segWithSameBp,1) > 2
            %If there are more than two other segments with this branchpoint,
            %removal of the segmetn does not alter the remaining topology, 

            %Delete the segment with the removed endpoint
            %Delete the endpoint containing segment from the segment table
            %and the segement lists
            segmentTable = removerows(segmentTable,'ind',deleteSegInd);
            segment(deleteSegInd) = [];

            %Delete the segment table row with the endpoint

         elseif size(segWithSameBp,1) == 1
            %If there is one other segment with the index, then the reamining topology consists 
            % only of a single lo0p with this branchpont at both ends. This is not
            % an allowable configuration

        elseif size(segWithSameBp,1) == 2
            % Removal of this segment , causes the two other segemtns to become
            % one.

            %Create the new segment consisting of the two 


            %Merge the found segments
            %Get the table rows of the other segmetns that share the branchpoint
            otherSegments = segmentTable(segWithSameBp,:);

             %Ge the pixel lists of the segmetns
             segment1 = segment(segWithSameBp(1,1)).PixelList;
             segment2 = segment(segWithSameBp(2,1)).PixelList;

             %If the firstpixel is the branchpoint, reverse the segemnt 
             if otherSegments(1,1) == bpInd
                 segment1 = reverserows( segment1);
             end
             %if the first pixel of the second segment is not the brnachpoint
             %reverse the segment
             if otherSegments(2,2) == bpInd
                segment2  = reverserows( segment2);
             end

             %Merge the segments, but only include the branchpoint once
             segment2 = segment2(2:end,:);
             newSegmentList = [segment1;segment2];

            %The the bp1 forthe first segments

              [~,bp1] = ismember(newSegmentList(1,:),branchpoints, 'rows');
              [~,bp2] = ismember(newSegmentList(end,:),branchpoints, 'rows');
              [~,ep1]= ismember(newSegmentList(1,:),endpoints, 'rows');
              [~,ep2] = ismember(newSegmentList(end,:),endpoints, 'rows');


            %Delete the endpoint containing segment from the segment table
            %and the segement lists
            deleteInd = [deleteSegInd;segWithSameBp];
            segmentTable = removerows(segmentTable,'ind',deleteInd);
            segment(deleteInd) = [];

           %Add the new segment 
           segment(length(segment)+1).PixelList = newSegmentList;
           numPixels = size(newSegmentList,1);
           segmentTable =  [segmentTable;[bp1, bp2, ep1, ep2, numPixels]];


        end    

    %The number of endpoints is the number of non-zero values in the 3rd
    %and 4th columns of the segment table
    numEndpoints = size( find(segmentTable(:,3:4)),1);

    end
    %Get the cu
    bpIndices = [segmentTable(:,1); segmentTable(:,2)];
    bpIndices = bpIndices(bpIndices > 0);
    bpIndices = unique(bpIndices);
    branchpoints = branchpoints(bpIndices,:);

    epIndices = [segmentTable(:,3); segmentTable(:,4)];
    epIndices = epIndices(epIndices > 0);
    epIndices = unique(epIndices);
    endpoints = endpoints(epIndices,:);


end

  %if the endpoints greater than 2 had to be eliminaed by segment size,
  % also eleiminate the curvature endpoint and its peak associated with 
  % that endpointc urvature had to be eliminated based 
  if size(curvEndpoints,1) > 2  
      index = assocLocations(curvEndpoints, endpoints);
      curvEndpoints = curvEndpoints(index,:);
      peaks = peaks(index);
  end
  
   
end

