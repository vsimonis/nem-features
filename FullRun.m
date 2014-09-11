%% Full Run
 addAllCodePaths();
% 1. User goes into GlobalEnv and sets -- to change later 
    % globalEnv.StudyInstanceName:  ie: 'Run1'
    % globalEnv.EndFrame ie: 50000;
    % globalEnv.EstArea: ie: 560;
   
    
% 2. Computer probes directory and sets the environment
vid = 'tph-1_f3';

disp('Setting global environment')
env = setGlobalEnv('vsimonis', vid);

disp('Extracting Contour and Skel')
% 3. Extract Contour and Skeleton
extractContourAndSkel( env )

disp('Updating environment')
% 4. Update environment (ie: load files)
 env = setGlobalEnv('vsimonis', vid);


 disp('Creating Seg Video')
% % 5. Create Seg Video 
 createSegVideo( env )


