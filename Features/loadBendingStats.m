
function dl = loadBendingStats(sktpSampleSize, dl, i)

    %Sktp can be in either local or global coordinate system
    [sktp, ~] = sampleSktp(dl(i).Sktp, sktpSampleSize);
    try
        STATS = getBendingStats(sktp);
        dl(i).SktvAglAve =  STATS.SktvAglAve;
        dl(i).SktvDisAveToLength = STATS.SktvDisAve/dl(i).Length;
        dl(i).SktvDisMaxToLength =  STATS.SktvDisMax/dl(i).Length;
        dl(i).SktvDisMinToLength = STATS.SktvDisMin/dl(i).Length;
        dl(i).SktvAglMax =  STATS.SktvAglMax;

    catch 

        dl(i).SktvAglAve =  0;
        dl(i).SktvDisAveToLength = 0;
        dl(i).SktvDisMaxToLength =  0;
        dl(i).SktvDisMinToLength = 0;
        dl(i).SktvAglMax = 0;
    end
end