env.LogFileName = 'N2_no_food-Thu_14_Aug_2014-150527.log';
env.VideoInputDir = 'C:\Users\vsimonis\Documents\MATLAB\Elegans\N2-1\';
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

T = [ T{1}, T{2}, T{3}, T{4}];

%% Video Start
[startr, ~] = find(~cellfun('isempty', strfind(T,'Start Writing Video')));
[stopr, ~] = find(~cellfun('isempty', strfind(T,'Stop Writing Video')));

%% Frames written
[wr,~] = find( strcmp( T, 'wrote frame'));

%% Frames where motion started
[mr, ~] = find(~cellfun('isempty',strfind(T,'From')));

mr = mr( find( mr > startr)); % & mr < stopr));
wr = wr( find( wr > startr)); % & mr < stopr));

mr = mr( find( mr < stopr) );
wr = wr( find( wr < stopr) );
%% Keep only motion and write rows (starting with "Start Writing Video" and ending with
% "Stop Writing Video")

r = vertcat( wr, mr);
r = sort(r);

%% Filter out un
F = [ T(r, 1), T(r,4) ] ;
convDate = @(f) datenum ( f, 'yyyy-mm-dd HH:MM:SS,FFF');
F1 = cellfun( convDate , F(:,1) );


for i = 2:size(F1)
    F{i,3} = F1(i);
    F{i, 4} = ( F1(i,1) - F1(i-1,1) )* 24 * 3600 * 1000; %in ms
end

totalStepX = 0;
totalStepY = 0;
move = '';
parenExp = '\(([^)]+)\)';
intExp = '(-?\d+)';

for i = 1:size(F)
   
   if strcmp(F{i,2}, 'wrote frame')
       F{i,5} = 0;
       F{i,6} = 0;
   else
       matches = regexp( F{i,2}, parenExp, 'match');
       move = matches(3)      ;
       matches = regexp( move, intExp, 'match');

       
       F{i,5} = str2num(matches{1,1}{1,1});
       F{i,6} = str2num(matches{1,1}{1,2});

   end
end
       


