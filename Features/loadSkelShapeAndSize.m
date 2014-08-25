function [ output_args ] = loadSkelShapeAndSize( segmentedArea, distTransform, sktp, dl, i )
%LOADSKELSHAPEANDSIZE Loads the skeleton shape and size into the datalist.
 
    STATS = getSkelShapeAndSize( segmentedArea, distTransform, sktp); 

    try
    
        dl(i).Length = STATS.Length;
        dl(i).SkelNumPixels = STATS.SkelNumPixels ;
        dl(i).LengthToPixels = STATS.LengthToPixels;
        dl(i).Fatness = STATS.Fatness;
        dl(i).Thickness = STATS.Thickness;
    catch
        dl(i).Length = 0;
        dl(i).SkelNumPixels = 0;
        dl(i).LengthToPixels = 0;
        dl(i).Fatness =0;
        dl(i).Thickness = 0;
    end
    
end

