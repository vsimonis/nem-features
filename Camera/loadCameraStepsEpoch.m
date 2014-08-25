function [cameraSteps, resolution, stepSize, epoch] = loadCameraStepsEpoch( env )
%LOADCAMERASTEPS loads the row and column steps of the camera, indexed by
%   Detailed explanation goes here
% Resolution pixel/mm


%% Parse file
stepSize = 200 / 1000; %um to mm;
MOVEDUR = 100; %ms
fname = sprintf('%s%s', env.VideoInputDir, env.LogFileName );
fid = fopen(fname);
T = textscan( fid, '%s%s%s%*s%s%s%s', 'delimiter', '\t','EndOfLine', '\n');

%% Format indices
% 1 - date/time
% 2 - level
% 3 - emitter
% 4 - msg
% 5 - msg (cont'd)
% 6 - msg (cont'd)

T1 = [ T{1}, T{2}, T{3}, T{4}];

%% Video Start
[startr, ~] = find(~cellfun('isempty', strfind(T1,'Start Writing Video')));
[stopr, ~] = find(~cellfun('isempty', strfind(T1,'Stop Writing Video')));

%% Resolution
[resr, ~] = find(~cellfun('isempty', strfind(T{1,4},'1 um')));
decExp = '(\d*\.?\d*$)';
pixPerUmStr = T{1,6}{resr, 1};
matches = regexp( pixPerUmStr, decExp, 'match');
pixPerUm = str2double(matches);
resolution = pixPerUm * 1000; %pix/mm

%% Frames written
[wr,~] = find( strcmp( T1, 'wrote frame'));

%% Frames where motion started
[mr, ~] = find(~cellfun('isempty',strfind(T1,'From')));

mr = mr( find( mr > startr)); % & mr < stopr));
wr = wr( find( wr > startr)); % & mr < stopr));

mr = mr( find( mr < stopr) );
wr = wr( find( wr < stopr) );
%% Keep only motion and write rows (starting with "Start Writing Video" and ending with
% "Stop Writing Video")

r = vertcat( wr, mr);
r = sort(r);

%% Filter out unwanted rows
F1 = [ T1(r, 1), T1(r,4) ] ;
convDate = @(f) datenum ( f, 'yyyy-mm-dd HH:MM:SS,FFF');
F2 = cellfun( convDate , F1(:,1) );


n=size(F2);

%F = struct('datestr',zeros(n,1),'msg', zeros(n,1),
for i = 1:n
    F(i).datestr = F1(i,1);
    F(i).msg = F1(i,2);
    F(i).datetime = F2(i);
    if i < 2
        F(i).deltaTime = 0;
    else
        F(i).deltaTime = ( F2(i,1) - F2(i-1,1) )* 24 * 3600 * 1000; %in ms
    end
end

totalStepX = 0;
totalStepY = 0;
totalDist = 0;
cumStepX = 0;
cumStepY = 0;
unitV = [0,0];
moving = false;
speed = 0;
parenExp = '\(([^)]+)\)';
intExp = '(-?\d+)';

[~,n] = size(F);
for i = 1:n
    if strcmp(F(i).msg, 'wrote frame')
        F(i).xmove = 0;
        F(i).ymove = 0;
        if moving
            if timeElapsed <= MOVEDUR
                timeElapsed = timeElapsed + F(i).deltaTime;
                movedDist = totalDist * F(i).deltaTime / MOVEDUR;
                F(i).xmove = round(movedDist * unitV(1));
                F(i).ymove = round(movedDist * unitV(2));
                cumStepX = cumStepX + F(i).xmove;
                cumStepY = cumStepY + F(i).ymove;
                
                if abs(totalStepX) == 1 & cumStepX == 0
                    F(i).xmove = totalStepX;
                    cumStepX = cumStepX + F(i).xmove;
                end
                
                if abs(totalStepX) == 1 & cumStepY == 0
                    F(i).ymove = totalStepY;
                    cumStepY = cumStepY + F(i).ymove;
                end
                
                
                if abs(cumStepX) > abs(totalStepX)
                    
                    F(i).xmove = totalStepX - (cumStepX - F(i).xmove);
                end
                
                if abs(cumStepY) > abs(totalStepY)
                    F(i).ymove = totalStepY - (cumStepY - F(i).ymove);
                end
                
            else
                timeElapsed = 0;
                moving = 0;
            end
        end
        
    else
        
        matches = regexp( F(i).msg, parenExp, 'match');
        move = matches{1,1}{3}      ;
        matches = regexp( move, intExp, 'match');
        
        totalStepX = str2num(matches{1,1});
        totalStepY = str2num(matches{1,2});
        totalDist = sqrt( totalStepX^2 + totalStepY^2 );
        unitV = 1/totalDist * [totalStepX, totalStepY];
        speed = totalDist / 100; %in ms
        timeElapsed = 0;
        cumStepX = 0;
        cumStepY = 0;
        moving = 1;
        
        
        
    end
end
%% to workable format
G = struct2cell(F);
G = transpose(G(:,:));
msg = vertcat(G(:,2));
msg = vertcat(msg{:,1});
x = vertcat(G{:,5});
y = vertcat (G{:,6});


cameraSteps = horzcat(y, x); % as [row,col]
epoch = vertcat(G(:,3));
end

