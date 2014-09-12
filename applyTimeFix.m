wd = 'C:\Users\Valerie\Documents\MATLAB\Good\N2_no_food1_Run2';

study = 'Run1';

cwd = sprintf('%s\\%s', wd, study);

cskelmat = getFileByType(wd, 'mat');

load(cskelmat);
dl = rmfield(dl, 'ElapsedTime');

for i = 1:size(dl,2)
    dl(i).ElapsedTime = epoch(i);
    dl(i).CameraStepRows = cameraSteps(i,1);
    dl(i).CameraStepCols = cameraSteps(i,2);
    if i > 1
        dl(i).DeltaTime = dl(i).ElapsedTime - dl(i-1).ElapsedTime;
        dl(i).TotalOffsetCols = round(dl(i-1).TotalOffsetCols + dl(i).CameraStepCols * dl(i).Resol * 0.2);
        dl(i).TotalOffsetRows = round(dl(i-1).TotalOffsetRows + dl(i).CameraStepRows * dl(i).Resol * 0.2);
        dl(i).GblCentroidCol = dl(i).LclCentroidCol - dl(i).TotalOffsetCols;
        
        dl(i).GblCentroidRow = dl(i).LclCentroidRow - dl(i).TotalOffsetRows;
        dl(i).CameraOffsetCols = dl(i).TotalOffsetCols;
        dl(i).CameraOffsetRows = dl(i).TotalOffsetRows;
        
    end
    
end

