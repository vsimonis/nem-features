function dl = loadSktpSkewerStats( dl, i )
%UNTITLED13 Summary of this function goes here
%   the sktp can be eithe rlocal or global coordinates
    try
        [ skewerStats] = getSkewerStats(dl(i).Sktp, dl(i).Length, dl(i).NumRows);
        dl(i).SkewerAngle = skewerStats.SkewerAngle;
        dl(i).SktAmpRatio = skewerStats.SktAmpRatio ;
        dl(i).SktCmptFactor = skewerStats.SktCmptFactor;
        dl(i).SktElgFactor = skewerStats.SktElgFactor;
        dl(i).SktIxx = skewerStats.Ixx;
        dl(i).SktIyy = skewerStats.Iyy;
        dl(i).SktAglAve =skewerStats.SktAglAve;
        dl(i).Xsym =skewerStats.Xsym;
        dl(i).Ysym = skewerStats.Ysym;
        dl(i).XYsym = skewerStats.XYsym;
        dl(i).TrackAmplitude = skewerStats.TrackAmplitude;
        dl(i).TrackPeriod = skewerStats.TrackPeriod;

    catch err

        writeError( err, iFrame, i);
        dl(i).SkewerAngle = 0;
        dl(i).SktAmpRatio = 0 ;
        dl(i).SktCmptFactor = 0;
        dl(i).SktElgFactor = 0;
        dl(i).SktIxx = 0;
        dl(i).SktIyy = 0;
        dl(i).SktAglAve = 0;
        dl(i).Xsym =0;
        dl(i).Ysym = 0;
        dl(i).XYsym = 0;
        dl(i).TrackAmplitude =0;
        dl(i).TrackPeriod = 0;
    
    end
end

