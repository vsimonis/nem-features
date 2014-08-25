function [sktpAll, skewerAngle] = assocEndpointsBySkewerAngle(sktpAll, prevSkewerAngle, rows) 
            
              
    %% Compare previous head and tail position to current position
      
    try
        
        head = sktpAll(1,:);
        tail = sktpAll(end,:);
        [~, skewerAngle] = getLineAngles(tail, head, rows);         
        diff = getSmallestAngleBetween(skewerAngle, prevSkewerAngle);
        if diff > 90
          sktpAll = reverserows(sktpAll);
          [~, skewerAngle] = getLineAngles(head, tail, rows);    
        end
       
    catch err
         
    end
    
end

