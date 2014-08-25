function [ output_args ] = closeProcess(  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    timeSpent = toc;
    fprintf(g, 'Execution Time: %s \n', timeSpent);
    fclose(f);
    fclose(g);

end

