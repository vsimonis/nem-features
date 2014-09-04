function [dl, totalOffset] = loadCameraInfo(resolution, cameraStep, pixelsPerStep, cropLoc,env, dl,i )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    
    dl(i).Resol = resolution;
    %Load the starting positon of the camera into each row
    dl(i).CameraStartRow = env.CameraStartRow;
    dl(i).CameraStartCol = env.CameraStartCol;

    %Load the number of steps the camera takes in this frame
    dl(i).CameraStepRows = cameraStep(1); 
    dl(i).CameraStepCols = cameraStep(2);

    %Calculate the offset of the camera since the beginning
    if i == 1

        dl(i).CameraOffsetRows = dl(i).CameraStartRow  + round( dl(i).CameraStepRows *pixelsPerStep)-1;
        dl(i).CameraOffsetCols =  dl(i).CameraStartCol + round( dl(i).CameraStepCols *pixelsPerStep)-1;

    else

       dl(i).CameraOffsetRows= dl(i-1).CameraOffsetRows + round( dl(i).CameraStepRows *pixelsPerStep);
       dl(i).CameraOffsetCols = dl(i-1).CameraOffsetCols + round( dl(i).CameraStepCols *pixelsPerStep);
    end    
           
    %Load the crop location
    dl(i).CropOffsetRows = cropLoc(1)-1;
    dl(i).CropOffsetCols = cropLoc(2)-1;

    %Load the total offset including camera and crop
    dl(i).TotalOffsetRows = dl(i).CameraOffsetRows + dl(i).CropOffsetRows;
    dl(i).TotalOffsetCols = dl(i).CameraOffsetCols + dl(i).CropOffsetCols;

    totalOffset = [dl(i).TotalOffsetRows , dl(i).TotalOffsetCols ];
end

