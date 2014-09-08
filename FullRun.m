%% Full Run
 addAllCodePaths();
% 1. User goes into GlobalEnv and sets -- to change later 
    % globalEnv.StudyInstanceName:  ie: 'Run1'
    % globalEnv.EndFrame ie: 50000;
    % globalEnv.EstArea: ie: 560;
   
    
% 2. Computer probes directory and sets the environment

'Setting global environment'
env = setGlobalEnv('vsimonis', 'tph-1_no_food');

'Extracting Contour and Skel'
% 3. Extract Contour and Skeleton
extractContourAndSkel( env )

'Updating environment'
% 4. Update environment (ie: load files)
%env = setGlobalEnv('vsimonis', 'tph-1_no_food');


'Creating Seg Video'
% 5. Create Seg Video 
%createSegVideo( env )


