datadir = 'C:\Users\vsimonis\Documents\MATLAB\Data\'

subdirs = dir(datadir)
[nDirs, ~] = size(subdirs)
summaryMat = zeros(nDirs,7)
summaryMat = mat2cell(summaryMat)
i = 1
for subdir = subdirs'
    currentdir = sprintf('%s%s', datadir,subdir.name)
    for file = dir(currentdir)'
        file.name
        if ~isempty(strfind(file.name, '.avi'))
            avi = sprintf('%s\\%s', currentdir,file.name)
            summaryMat{ i, 1} = file.name
            try
                v = VideoReader( avi );
                summaryMat{i, 2} = v.NumberOfFrames
                summaryMat{i, 3} = v.Duration
                summaryMat{i, 4} = v.Duration / 60
                summaryMat{i, 5} = v.Height
                summaryMat{i, 6} = v.Width
                summaryMat{i, 7} = v.FrameRate
            catch Error
                summaryMat{i,2} = Error.message
            end
            i = i + 1;
        elseif ~isempty(strfind(file.name, '.log'))
            log = sprintf('%s\%s', currentdir,file.name)
        end
    end
end


