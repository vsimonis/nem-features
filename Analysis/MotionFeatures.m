%% Load data list

%clear
close all

video = {'N2-nofood1', 'n2-no-food2', 'tph1-no-food'};
env.WorkingDir = 'C:\Users\Valerie\Documents\MATLAB\Corrections';

for i = 1:3
    v = video{i}
    for file = dir(sprintf('%s\\%s', env.WorkingDir, v))'
        if ~isempty(strfind(file.name, '.mat')) && ~isempty(strfind(file.name, 'Corrected'))
            env.MatFile = sprintf('%s\\%s\\%s', env.WorkingDir, v, file.name);
        elseif ~isempty(strfind(file.name, 'frameAdjusted'))
            env.ExclusionFile = sprintf('%s\\%s\\%s', env.WorkingDir, v, file.name);
        end
    end
    
    %load(env.MatFile)
    
    
    
    %% Load exclusion list
    fid = fopen(env.ExclusionFile);
    excl = textscan( fid, '%d', 'delimiter', '\n');
    excl = excl{1};
    excl = excl + 1; %adjust for 0 index from Kyle
    
    
    %% Build inclusion list, cuz duh
    all = [ 1:1:size(dl,2)];
    all = all';
    
    maxFrame = 0;
    
    if i == 1
        maxFrame = 20000;
    elseif i == 2
        maxFrame = 20000;
    else
        maxFrame = 20000;
    end
    
    all = all(all < maxFrame);
    
    Lia =  ismember( all,excl);
    incl = all(~Lia);
    
    di = dl(incl);
    de = dl(excl);

    %% scatter the trails before exclusion
%     pathPlots(dl, v, 'allFrames');
        pathPlots(di, v, 'incl');
%     pathPlots(de, v, 'excl');
    
% 
%     %% Calculate motion features
%     for j = 1:maxFrame
%         dl = loadTrajectoryInfo(dl,j);
%     end
%     
%     %% plot motion features
%     scatter( vertcat(dl.ElapsedTime), vertcat(dl.InstantVelocity) )
%     

    
end