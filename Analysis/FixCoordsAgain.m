datadir = 'C:\Users\Valerie\Documents\MATLAB\Good';
summat = cell(4,3);
i = 0;
for subdir = dir(datadir)'
    
    move = 0;
    movestart = 0;
    movetime = 0;
    MAXMOVE = 0.210;
    movelist = [];
    
    v = subdir.name;
    vdir = sprintf('%s\\%s', datadir,v);
    if ~strcmp(v, '.')
        if ~strcmp(v, '..')
            
            matfile = getFileByType(vdir , '.mat');
            
            load(matfile);
            for i=1:size(dl,2)
                if dl(i).CameraStepRows ~= 0 || dl(i).CameraStepCols ~= 0
                    if move == 0
                        movestart = dl(i).ElapsedTime;
                        nummoves = nummoves + 1;
                        move = 1;
                        
                    end
                    
                end
                if move == 1 && movetime < MAXMOVE
                    movelist(end + 1) = i;
                    movetime = dl(i).ElapsedTime - movestart;
                elseif movetime > MAXMOVE
                    move = 0;
                    movestart = 0;
                    movetime = 0;
                end
            end
            
            
            
            exclusionFile = getFileByType(vdir, 'frameAdjusted');
            
            fid = fopen(exclusionFile);
            
            excl = textscan( fid, '%d', 'delimiter', '\n');
            excl = excl{1};
            excl = excl + 1; %adjust for 0 index from Kyle
            
            all = [ 1:1:size(dl,2)];
            all = all';
            excl = vertcat(excl, movelist');
            
            Lia =  ismember( all,excl);
            incl = all(~Lia);
            
            
            
            di = dl(incl);
            de = dl(excl);
            
            %% scatter the trails before exclusion
            %     pathPlots(dl, v, 'allFrames');
            
            figure; pathPlots(di, v, 'incl');
            summat{i,1} = v;
            summat{i,2} = nummoves;
            summat{i,3} = size(excl);
            
        end
        
        ends
    i = i + 1;
end




