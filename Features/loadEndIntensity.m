function  dl = loadEndIntensity(gsImage,bwImage,sktpAllLocal, dl, i)
%LOADENDINTENSITY Loads the intenisty at the ends into the data list

try

 [intA, intB]  = getEndIntensity(gsImage, bwImage, sktpAllLocal);
 dl(i).IntH = intA;
 dl(i).IntT = intB;

catch
 dl(i).IntH = 0;
 dl(i).IntT = 0;

end

