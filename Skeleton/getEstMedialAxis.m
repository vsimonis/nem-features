function list = getEstMedialAxis( segment, endpoint, branchpoint,posture, estLength  )


    %Posture
    % 0 - Unknonw
    % 2 - Delta
    % 3 - Gamma
    % 4 - Omega

   if posture == 1
       list = segment.PixelList;
    %% Delta Loop
    
   
   elseif posture == 2 %delta

        
        for k = 1:length(segment)
            pixelList = segment(k).PixelList;

            %Segment 1 is associated with endpoint 1
            if ~isempty(find(ismember(endpoint,pixelList,'rows')))
                segment1 = pixelList;

            else
               loop = pixelList;

             end
        end
        %correctly orient the first segment so the first pixel is the endpoint1
        % and start the skeleton list
        if ~isequal( segment1(1,:), endpoint)
            segment1 = reverserows(segment1);
        end
        list = segment1;


         %Determine the best way to go on the loop Need to select direction
         % that has the smoothest transition,so e use the city block distance
         % between the last displacement vector and the current displacement
         % vector.


        %Previous displacement vector (from last of segment 3 to branchpoint2
        lastElem = size(list,1);
        prevDisp = [ list(lastElem,1) - list(lastElem-1,1),...
                   list(lastElem,2) - list(lastElem-1,2)];

        % Current displacement vector (from branchpoint to the first and last
        % pixels of the loop
        lastElem = size(loop,1);
         curDispToFirst = [ loop(2,1) - loop(1,1),...
                          loop(2,2) - loop(1,2) ];

        curDispToLast = [loop(lastElem-1,1) - loop(lastElem,1)...
                        loop(lastElem-1,2)- loop(lastElem,2) ];   

        %Get the minimum pairwise distances between all 
        %displacements
        D = pdist([prevDisp; curDispToFirst; curDispToLast], 'cityblock');

        %We only care about comparison to the first value.
        D = D(1:2);
        minValue = min(D);
        indexOfMin = find(D == minValue);
        if indexOfMin == 2
           loop = reverserows(loop);
        end
        list = [list;loop(2:lastElem,:)];
        
        %Add part fo the first segment in reverse order until the length is
        %approximately equal to the estimated laength of a worm
        revSeg1 = reverserows(segment1);
        list = extendList(list, revSeg1, estLength);
    
    end

     
    if posture == 4 || posture == 3 || posture == 0
        
       
            endpoint1 = endpoint(1,:);
            endpoint2 = endpoint(2,:);
            
             
                  
            % Identify segment 1 and segment 2  
            usedSegments = [];
            for k = 1:length(segment)
                pixelList = segment(k).PixelList;

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
            config = getSkelGraphConfig(endpoint, branchpoint, segment);
                   
            if config == 1 %Both segmentes connect directly to loop

                %Identify segment 3 and the loop
                seqnum = 0;
                for k = 1:length(segment)

                    if ~ismember(k, usedSegments)

                        seqnum = seqnum+1;
                        if seqnum == 1
                            pixelList1 = segment(k).PixelList;
                        else
                            pixelList2 = segment(k).PixelList;
                        end
                    end
                end
                if size(pixelList1,1) > size(pixelList2,1)
                    loop = pixelList1;
                    segment3 = pixelList2;
                else
                    loop = pixelList2;
                    segment3 = pixelList1;
                end

                if posture == 3 %gamma

                    %correctly orient the first segment so the first pixel is the endpoint1
                    % and start the skeleton list
                    if ~isequal( segment1(1,:), endpoint1)
                        segment1 = reverserows(segment1);
                    end

                    %The list starts with the first segement, including the endpoint and
                    %first branchpoint.
                    list = segment1;

                    %Re-order segment 3 if necessary and add it to the list without the
                    %first element, which is already in the list as a branchpoint.

                     if ~isequal( segment3(1,:), list(size(list,1),:))
                         segment3 = reverserows(segment3);
                     end
                     len3 = size(segment3,1);
                     list = [list;segment3(2:len3, :)];

                      %Re-orient the loop so that it connects to the end of segment3
                      lastElem = size(list,1);
                      if ~isequal( loop(1,:), list(lastElem,:))
                         loop = reverserows(loop);
                     end
                     lastElem = size(loop,1);
                     list = [list;loop(2:lastElem, :)];

                     %Attach segment 3 again,
                     lastElem = size(segment3,1);
                     list = [list;segment3(2:lastElem,:)];

                     %Attach segment2 in correct order
                     lastElem = size(list,1);
                     if ~isequal(segment2(1,:), list(lastElem,:));
                           segment2 = reverserows(segment2);
                     end

                     lastElem = size(segment2,1);
                     list = [list; segment2(2:lastElem,:) ];
                end
            
            if posture == 4 || posture == 0 %Omega
                
                 %correctly orient the first segment so the first pixel is the endpoint1
                % and start the skeleton list
                if ~isequal( segment1(1,:), endpoint1)
                    segment1 = reverserows(segment1);
                end
        
                %The list starts with the first segement, including the endpoint and
                %first branchpoint.
                list = segment1;
                
                %Re-orient the loop so that it connects to the end of segment3
                 lastElem = size(list,1);
                  if ~isequal( loop(1,:), list(lastElem,:))
                     loop = reverserows(loop);
                 end
                 lastElem = size(loop,1);
                 list = [list;loop(2:lastElem, :)];

                
                 %Attach segment2 in correct order
                 lastElem = size(list,1);
                 if ~isequal(segment2(1,:), list(lastElem,:));
                       segment2 = reverserows(segment2);
                 end

                 lastElem = size(segment2,1);
                 list = [list; segment2(2:lastElem,:) ];
            end
        end
        
        if config == 2 %fish shape, one branch connects to teh loop
            
            %Can be either alpha or omega
            %Connect the segments in this order -
            %segment1, segment3, loop, reverse of segment 3, segment2.
            
            %Identify segment 3 and the loop
            for k = 1:length(segment)
                if ~ismember(k, usedSegments)

                    pixelList = segment(k).PixelList;

                    %Segment 3 includes two branchpoints.  If the two 
                    % branchpoints abut each end of the segment, then it is
                    % segment3
                    if    ( ~isempty(find(ismember(branchpoint(1,:),pixelList,'rows'))) )...
                           && ( ~isempty(find(ismember(branchpoint(2,:),pixelList,'rows'))) )

                           segment3 = pixelList;
                            %Wahter doesn't satisfy the above conditions is the loop
                    else
                        loop = pixelList;
                    end
                end
            end
            
             %correctly orient the first segment so the first pixel is the endpoint1
            % and start the skeleton list
            if ~isequal( segment1(1,:), endpoint1)
                segment1 = reverserows(segment1);
            end
            %The list start with the first segement, including the endpoint and
            %first branchpoint.
            list = segment1;   
                
            %Re-order segment 3 if necessary and add it to the list without the
            %first element, which is already in the list as a branchpoint.

             if ~isequal( segment3(1,:), list(size(list,1),:))
                 segment3 = reverserows(segment3);
             end
             len3 = size(segment3,1);
             list = [list;segment3(2:len3, :)];

     
             %Determine which way to go on the loop.  For omega, if segment2 joins
             %branchpoint1 to the left of segment1, then go right.  If segment
             %2 joins branchpoint1 to the right of segment1, then go
             %left. For alpha do the opposite.


             tempSeg2 = segment2;
             if ~isequal(tempSeg2(1,:), endpoint2);
                  tempSeg2 = reverserows(tempSeg2);
             end

             P1 = segment1(size(segment1,1)-1,:);
             P2 = segment1(size(segment1,1),:);
             P3 = tempSeg2(size(tempSeg2,1)-1,:);

             V1 = [P2(1)-P1(1), P2(2)-P1(2)];
             V2 = [P3(1)-P2(1), P3(2)-P2(2)];
            
             
             cp1 = cross([V1,0],[V2,0]);

             Q1 = segment3(size(segment3,1)-1,:);
             Q2 = segment3(size(segment3,1),:);
             Q3 = loop(2,:);

             W1 = [Q2(1)-Q1(1), Q2(2)-Q1(2)];
             W2 = [Q3(1)-Q2(1), Q3(2)-Q2(2)];

             cp2 = cross([W1,0],[W2,0]);
             
             if posture == 4
                 if (cp1(3) > 0 && cp2(3) > 0) || (cp1(3) < 0 && cp2(3) < 0)
                     loop = reverserows(loop);
                 end
             elseif posture == 3
                 if (cp1(3) > 0 && cp2(3) > 0) || (cp1(3) < 0 && cp2(3) < 0)
                    %do nothing 
                 else
                      loop = reverserows(loop);
                 end
             end
             lenLoop = size(loop,1);
             list = [list;loop(2:lenLoop,:)];


            %Attach segment 3 again, only in reverse order
            revSegment3 = reverserows(segment3);
            len3 = size(segment3,1);
            list = [list;revSegment3(2:len3,:)];

             %Attach segment2 in correct order
             lastElem = size(list,1);
             result = isequal(segment2(1,:), list(lastElem,:));
             if result ~= 1
                 segment2 = reverserows(segment2);
             end
            lastElem = size(segment2,1);
            list = [list; segment2(2:lastElem,:) ];
        end

     
    end
  
end

    
                
        
        
