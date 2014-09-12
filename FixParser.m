wd = 'C:\Users\Valerie\Documents\MATLAB\Data\N2_no_food1';


log = getFileByType(wd, 'log');
avi = getFileByType(wd, 'avi');

stepSize = 200 / 1000; %um to mm;
MOVEDUR = .220;
moveoffset = 2;
fname = sprintf('%s\\%s', wd, log);
fid = fopen(log);
T = textscan( fid, '%s%s%s%*s%s%s%s', 'delimiter', '\t','EndOfLine', '\n');

%% Format indices
% 1 - date/time
% 2 - level
% 3 - emitter
% 4 - msg
% 5 - msg (cont'd)
% 6 - msg (cont'd)

T1 = [ T{1}, T{2}, T{3}, T{4}];

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

%mr = mr + 2; %add 2 to every move row to offset time it takes motors to respond

r = vertcat( wr, mr);
r = sort(r);

%% Filter out unwanted cols
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
        F(i).elapsedTimez = 0;
    else
        F(i).deltaTime = ( F2(i,1) - F2(i-1,1) )* 24 * 3600; %in s
        F(i).elapsedTimez = ( F2(i,1) - F2(1,1) )* 24 * 3600; %in s
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
j = 0;
[~,n] = size(F);
et=[];
dt =[];
for i = 1:n
    if strcmp(F(i).msg, 'wrote frame')
        j = j + 1; %index for wf
        H(j).xmove = 0;
        H(j).ymove = 0;
        H(j).elapsedTime = F(i).elapsedTimez(1);
        if moving
            
            if timeElapsed <= MOVEDUR
                dt = H(j).elapsedTime - H(j-1).elapsedTime
                timeElapsed = timeElapsed + dt ;
                movedDist = totalDist * dt / MOVEDUR;
                H(j).xmove = movedDist * unitV(1);
                H(j).ymove = movedDist * unitV(2);
                cumStepX = cumStepX + H(j).xmove;
                cumStepY = cumStepY + H(j).ymove;
                
                if abs(totalStepX) == 1 && cumStepX == 0
                    H(j).xmove = totalStepX;
                    cumStepX = cumStepX + H(j).xmove;
                end
                
                if abs(totalStepX) == 1 && cumStepY == 0
                    H(j).ymove = totalStepY;
                    cumStepY = cumStepY + H(j).ymove;
                end
                
                
                if abs(cumStepX) > abs(totalStepX)
                    
                    H(j).xmove = totalStepX - (cumStepX - H(j).xmove);
                end
                
                if abs(cumStepY) > abs(totalStepY)
                    H(j).ymove = totalStepY - (cumStepY - H(j).ymove);
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
        speed = totalDist / 100; %in s
        timeElapsed = 0;
        cumStepX = 0;
        cumStepY = 0;
        moving = 1;
        
        
        
    end
end



%% to workable format
% G = struct2cell(F);
% 
% 
% G1 = transpose(G(:,:));
% msg = vertcat(G1(:,2));
% msg = vertcat(msg{:,1});
x = vertcat(H.xmove); %x step directions --> col
y = vertcat (H.ymove);%y step directions --> row


cameraSteps = horzcat(y, x); % as [row,col]
epoch = vertcat(H.elapsedTime);

save fixParser cameraSteps epoch
clear
load fixParser




