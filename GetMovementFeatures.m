%% Fix Elapsed TIme
addAllCodePaths();
env = setGlobalEnv('Valerie', 'n2_no_food2');
featureFile = sprintf('%s\\%s\\%s', env.WorkingDir, env.StudyInstanceName, env.AllFeaturesMat);
load(featureFile);
numFrames = size(dl,2);

for i = 1:numFrames    
    dl(i).ElapsedTime = dl(i).ElapsedTime{1} * 1000; % out of cell and in seconds
end

for i = 1:numFrames
    dl = loadTrajectoryInfo(dl,i);
end
