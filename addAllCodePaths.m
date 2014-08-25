function  addAllCodePaths()
%ADDALLCODEPATHS Adds code paths to all subdirectoreis of the specified
%directory
    currentFolder = pwd();
    addpath(genpath(currentFolder)); 
    addpath(strcat(currentFolder,'\' ) );

end

