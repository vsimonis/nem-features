%% Full Run

% 1. User goes into GlobalEnv and sets -- to change later 
    % globalEnv.StudyInstanceName:  ie: 'Run1'
    % globalEnv.EndFrame ie: 50000;
    % globalEnv.EstArea: ie: 560;
    
% 2. Computer probes directory and sets the environment

'Setting global environment'
env = setGlobalEnv('Valerie', 'n2_no_food2');

'Extracting Contour and Skel'
% 3. Extract Contour and Skeleton
extractContourAndSkel( env )

'Updating environment'
% 4. Update environment (ie: load files)
env = setGlobalEnv('Valerie', 'n2_no_food2');

'Creating Seg Video'
% 5. Create Seg Video 
createSegVideo( env )


