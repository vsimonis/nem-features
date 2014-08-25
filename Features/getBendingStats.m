function [ STATS ] = getBendingStats(sktp)
%getBendingStats = returns info about the vectors connecting skel points
  
  % Calculate vectors (i.e., row distance, and col distance between 
  % successive points on the skeleton
  sktv = zeros(size(sktp) );
  sktv(2:size(sktv,1) ,: ) = sktp(2 : size(sktp,1),:) - sktp(1:size(sktp,1)-1, :);
   
  %Calculate the magnitude of the vectors (distance between points)  
  sktvMag= zeros(size(sktp,1 ),1);
  sktvMag(:)  = sqrt( sktv(:,1).^2 + sktv(:,2).^2 );
   
  %Calculate the angle between successive vectors
  phi = zeros( size(sktv,1),1);
  dotProduct = zeros(size(sktv,1),1);
  
  for i = 2:size(sktv,1)-1
         
      dotProduct(i) = dot( sktv(i,:), sktv(i+1,:) ) ;
          
      phi(i) = acosd( dotProduct(i) / ( sktvMag(i) * sktvMag(i+1) ));
      if phi(i) < 0.01
          phi(i) = 0;
      end
      
  end
  
     
  % Calculate featurs from the skeleton vectors
  STATS.SktvAglAve = mean(abs(phi));
  STATS.SktvDisAve = mean(abs(sktvMag)); 
  STATS.SktvDisMax = max(abs(sktvMag));
  STATS.SktvDisMin = min(sktvMag(2:size(sktvMag,1)));
  STATS.SktvAglMax = max(abs(phi));

end

