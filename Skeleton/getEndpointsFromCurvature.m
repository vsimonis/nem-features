function [ endpoints, peaks ] = getEndpointsFromCurvature( bwImage, kernelRadius, sigma, threshold, sigmaAdjusted)
%GETENDPOINTSFROMCURVATURE 
%   Detects endpoints with a specified kernelRadius, sigma and threshold. 
%   Automatically adjusts sigma until at most 2 enpoints are detected.
%   sigma = 1; 
    [endpoints,  peaks] = detectEndpoints(bwImage, kernelRadius, sigma, threshold);
    if sigmaAdjusted
        
        counter = 0;
        while size(endpoints,1) > 2 && counter < 10
            counter = counter + 1;
            sigma = sigma * 1.2;
            [endpoints, peaks] = detectEndpoints(bwImage, kernelRadius, sigma, threshold);
        end
    end
    
end
    
    
    

