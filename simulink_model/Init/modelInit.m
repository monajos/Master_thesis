function modelInit(f_name)
evalstring = ['load(''' f_name ''')'];
evalin('base',evalstring);
BusDeffinition();
outputBusses();
evalin('base','load aeroDB.mat');
evalin('base','load envDB.mat');

end

