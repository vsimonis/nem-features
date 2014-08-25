function output = gettimestamp
%TIMESTAMP Returns a filename safe time stamp

output = strcat(datestr(clock,'yyyy-mm-dd-HH-MM'),'m',datestr(clock,'ss'),'s'); 

end

