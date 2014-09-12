wd = 'C:\Users\Valerie\Documents\MATLAB\Data';
worm = 'N2_no_food1';
wormpath = sprintf('%s\\%s', wd, worm);
vid = getVidName(wormpath);

interval = 1;

wormVid = VideoReader(wormVid);
props = get(wormVid);
nFrames = props.NumberOfFrames;
first = 1;
last = first + interval;


