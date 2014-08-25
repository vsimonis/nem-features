 function result = getSktpMovement(curSktp, prevSktp)
    % SKTPMOVEMENT Returns the mean distance  sktp points move 
    % Measured from previous frame
     diff = size(curSktp,1) - size(prevSktp,1);
     if diff < 0   
        prevSktpAdj = prevSktp(1:size(curSktp,1),:);
        curSktpAdj = curSktp;
     elseif diff > 0
         curSktpAdj = curSktp(1:size(prevSktp,1),:);
         prevSktpAdj = prevSktp;
     else
        prevSktpAdj = prevSktp;
        curSktpAdj = curSktp;
     end
         
     z = getDist( curSktpAdj, prevSktpAdj );
    
    result = mean(z);
  end

