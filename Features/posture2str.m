function [ posStr ] = posture2str(posture)
%%
% _1_ (posture )
%POSTURE2STR Converts posture code to a descriptive string

    %Posture Codes:

    % 0 - Unknown
    % 1 - No Loop
    % 2 - Delta
    % 3 - Gamma
    % 4 - Omega



    if posture == 1
        posStr = 'No Loop';
    elseif posture == 2
        posStr = 'Delta';
    elseif posture == 3
        posStr = 'Gamma';
    elseif posture == 4
        posStr = 'Omega';
    else
        posStr = 'Unknown';
    end

end

