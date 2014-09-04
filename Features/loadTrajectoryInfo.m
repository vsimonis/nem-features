function dl = loadTrajectoryInfo(dl, i)

%Delta Time
if i  == 1
    dl(i).DeltaTime = 0;
else
    dl(i).DeltaTime =  dl(i).ElapsedTime - dl(i-1).ElapsedTime;
end

% Delta x
if i == 1
    dl(i).DeltaX = 0;
else
    dl(i).DeltaX = (dl(i).GblCentroidCol - dl(i-1).GblCentroidCol)* dl(i).Resol;
end

% Delta y
if i == 1
    dl(i).DeltaY = 0;
else
    dl(i).DeltaY =  (dl(i-1).GblCentroidRow - dl(i).GblCentroidRow)*dl(i).Resol;
end

% Delta Distance
if i == 1
    dl(i).DeltaDist = 0;
else
    dl(i).DeltaDist = sqrt( ( dl(i).DeltaX )^2 + ( dl(i).DeltaY)^2);
end

% Velocity Vector Angle
if i == 1
    dl(i).VectorAngle = 0;
else
    dl(i).VectorAngle = acos(( dl(i).GblCentroidCol - dl(i-1).GblCentroidCol) /dl(i).DeltaDist);
end

% Intantaneous velocity
if i == 1
    dl(i).InstantVelocity = 0;
else
    dl(i).InstantVelocity = dl(i).DeltaDist /dl(i).DeltaTime;
end


% Instantaneous acceleration
if i == 1
    dl(i).InstantAccel = 0;
else
    dl(i).InstantAccel = (dl(i).InstantVelocity -  dl(i-1).InstantVelocity)/dl(i).DeltaTime;
end

% Total distance travelled
if i ==1
    dl(i).CumDist = 0;
else
    dl(i).CumDist =  dl(i-1).CumDist + dl(i).DeltaDist;
end

% Range
if i == 1
    dl(i).Range = 0;
else
    dl(i).Range = ( sqrt( [(dl(1).GblCentroidCol - dl(i).GblCentroidCol)^2,...
        (dl(1).GblCentroidRow - dl(i).GblCentroidRow)^2] ))...
        * dl(i).Resol;
end

if mod(i,100) == 0
    i
end


end %function