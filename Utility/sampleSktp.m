function [ newSktp  sktpIndices ] = sampleSktp( oldSktp, pixelsInNewSktp )
%CreateSktp - Create a new skeleton point list by sampling an existing one
%   

    pixelsInOldSktp = size(oldSktp,1);
    sktpIndices = zeros(pixelsInNewSktp,1);
    newSktp = zeros(pixelsInNewSktp, 2);

    %Assign the head and tail pixels
    newSktp(1,:) = oldSktp(1,:);
    newSktp(pixelsInNewSktp,:) = oldSktp(pixelsInOldSktp,:);
    
    %Assign ones in between
    index = 1;
    step = floor(pixelsInOldSktp / (pixelsInNewSktp - 1));
    oldIndex = 1;
    sktpIndices(1) = 1;
    for newIndex = 2:pixelsInNewSktp - 1
    
      index = index + 1;
      oldIndex = oldIndex + step;
      sktpIndices(index) = oldIndex;
      newSktp(newIndex,:) = oldSktp(oldIndex,:);
      
    end

    %Reet the last pixel in the list, since the loop may not terminate on the
    %exact last pixel
    newSktp(pixelsInNewSktp,:) = oldSktp(pixelsInOldSktp,:);
    sktpIndices(pixelsInNewSktp) = pixelsInOldSktp;  


end


