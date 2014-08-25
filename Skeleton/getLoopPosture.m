function posture = getLoopPosture( dataList, curFrame, ends, numRows)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% ends in a column list of row, col subscripts of the ends of the skeleton
     
%Posture:
        % 0 - Unknown
        % 1 - No Loop
        % 2 - Delta
        % 3 - Gamma
        % 4 - Omega

numEnds = size(ends,1);
       
if curFrame == 1
            
    posture = 0; % Unknown loop
                
else %Its a loop on a frame that is not the first frame
              
        if numEnds == 1
                
            % if one end is visible , then posture is delta  
            posture = 2; 
                    
        elseif dataList(curFrame-1).Posture == 0
                
             %If prior frame is unknown, then so is this one
             posture = 0;
             
        elseif dataList(curFrame-1).Posture == 3
                
            % If the previous frame is a gamma, and there are two ends visible,
            % then posture is gamma
            posture = 3;
            
        elseif dataList(curFrame-1).Posture == 4
            % If the previous frame is a omega, and there are two ends visible,
            % then posture is omega
            posture = 4;
        
        elseif dataList(curFrame-1).Posture == 2
            %Two ends are visible, and previous posture is a delta
            % determine alpha or omega based on prior frames
            
            k = 1;
            while dataList(curFrame - k).IsLoop == 1 && curFrame ~= 1
                k = k+1;
            end
            beforeLoopFrame = curFrame - k;
            deltaFrame = curFrame - k +1;

            %Verify that endA and B in each frame corresponds to eachother

            %Location of end A and B just before entering loop
            A1  = [dataList(beforeLoopFrame).HeadRow, dataList(beforeLoopFrame).HeadCol] ;
            B1 = [dataList(beforeLoopFrame).TailRow, dataList(beforeLoopFrame).TailCol] ;     
            [phi1, ~] = getLineAngles(A1, B1, numRows);

            %Locations of end A and end B during delta posture
            A2  = [dataList(deltaFrame).HeadRow, dataList(deltaFrame).HeadCol] ;
            B2 = [dataList(deltaFrame).TailRow,dataList(deltaFrame).TailCol] ;    
            [phi2, ~] = getLineAngles(A2, B2, numRows);
            if getSmallestAngleBetween(phi1, phi2) > 90
                temp = A2;
                A2 = B2;
                B2 = temp;
                [phi2, ~] = getLineAngles(A2, B2, numRows);
            end

            %Check the alignment 0f the skewers from the first delta to
            %the curframe

            if deltaFrame < curFrame-1;
                phiPrev = phi2;
                for m = deltaFrame+1:curFrame - 1
                      P1  = [dataList(m).HeadRow, dataList(m).HeadCol] ;
                      P2 = [dataList(m).TailRow,dataList(m).TailCol] ;    
                      [phi, ~] = getLineAngles(P1, P2, numRows);
                     if getSmallestAngleBetween(phi, phiPrev) > 90
                        temp = P1;
                        P1 = P2;
                        P2 = temp;
                        [phi, ~] = getLineAngles(P1, P2, numRows);
                     end
                     phiPrev = phi;
                end
            else
                phiPrev = phi2;
            end

           %Locations of end A and end B during current (gamma or omega)posture
            A3  = ends(1,:) ;
            B3 = ends(2,:) ;    
            [phi3, ~] = getLineAngles(A3, B3, numRows);
             if getSmallestAngleBetween(phiPrev, phi3) > 90
                temp = A3;
                A3 = B3;
                B3 = temp;
            end  



                %Vector from tail to head as head becomes obscured

                AB1 = getVector(A1,B1, numRows);

                %Vector from tail as head becomes obscured to head before it is
                %obscured
                AB2 = getVector(A2,B2, numRows);

                %Vector from tail as head becomes obscured to head after it
                %reapears
                AB3 = getVector(A3,B3, numRows);


                c1 = sign( cross([AB1,0],[AB2,0]));
                c2 = sign( cross([AB2,0],[AB3,0]));
                if c1(3) == c2(3)
                    posture = 3;    %gamma
                else
                    posture = 4;  %omega
                end
        else
                    %previous frame is not a loop and current frame is either
                    %omega or gamma
                    posture = 0; %Unknown
        end
end
end

