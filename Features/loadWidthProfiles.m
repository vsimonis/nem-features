function dl = loadWidthProfiles(distTransform, range, dl, i)
%LOADWIDTHPROFILES Summary of this function goes here
%   Detailed explanation goes here

    try
       
        [profileA, profileB ] = getWidthProfiles( dl(i).Sktp, distTransform, range );
        dl(i).WidthProfileA = profileA;
        dl(i).WidthProfileB = profileB; 
     catch err
        dl(i).WidthProfileA = 0;
        dl(i).WidthProfileB = 0; 
        rethrow(err);
    end
end

