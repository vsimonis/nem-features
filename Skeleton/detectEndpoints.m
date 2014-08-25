function [theEnds, peaks]  = detectEndpoints(bwImage, kernelRadius, sigma, threshold)

    %Returns listof endpoints, in nx2 matrix.
    
        % Sigma must be greater than or equal to one
        bwImage = imfill(bwImage, 'holes');
        laii = getLaiiSignature(bwImage, kernelRadius);
        x = bwboundaries(bwImage, 'noholes');
        numRows = size(bwImage,1);
        pixelList = x{1};
        
        laiiAdj = zeros(1,size(pixelList,1));
        for i = 1:size(pixelList,1)
              
            laiiAdj(1,i) = max( 1 - laii( pixelList(i,1), pixelList(i,2) ) - threshold, 0);
                  
        end 
        
        %Shift vector so starts with zeros, so a signal that starts at
        %tendpoint and falls near begin point is not counted as two
        %signals. 
        theShift = 0;
        while  ~ isequal(laiiAdj(1,1:5),[0,0,0,0,0]) && theShift < size(laiiAdj,2) %~ isequal(laiiAdj(1,1:5),[0,0,0,0,0])
            laiiAdj = circshift(laiiAdj,[0,1]);
            theShift = theShift + 1;
        end
        
        %The filter should be wide enough to represent the Gaussian function.
        width = round(4*sigma + 1);
        gaussian = normpdf( -width:width, 0, sigma );
        
        signal = conv(laiiAdj, gaussian,'same');
       
    
        [peaks, locs] = findpeaks(signal);
        
        %Shift the locations of the peaks back so they correspond to the
        %correct location in the perimeter (pixelist)
         locs = locs - theShift;
         for i = 1:length(locs)
             if locs(i) <= 0 
                 locs(i) = length(signal) - abs(locs(i));
             end
         end
               
        
        theEnds = pixelList(locs,:);
       

end