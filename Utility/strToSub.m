function sktp = strToSub( sktpString )

    %STRTOSKTP Converts a delimited string fo pixels to a sktp format
    
    %   sktpString - has rows and columns separated by semicolon and pixels separated
    %   by a pipe
    %
    %   sktp - is an n x 2 matrix where each row is the row and col subscript
    %   of a pixel

     %Get cell array of pixels
     C = strsplit(sktpString, '|');

     %Determien the number of cells
     numPixels = length(C);

     %Pre-allocate a n x 2 array to hold the skeleton points.  NOte the
     %first cell isn't counted because the split on the first pipe makes it
     %empty 
     sktp = zeros(numPixels-1, 2);

     seqnum = 0;
     for i = 2:numPixels
         
         seqnum = seqnum + 1;
         pixelCell = strsplit(C{i}, ';');
         sktp(seqnum,1) = str2num(pixelCell{1});
         sktp(seqnum,2) = str2num(pixelCell{2});
     end
end

