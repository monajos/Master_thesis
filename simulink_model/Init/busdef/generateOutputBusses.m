% Skript zur automatischen Erstellung der Busdefinitionen f�r ausg�nge 
% buscreator auf toplevelebene muss manuell markiert werden (f�r gcb und
% gcs), toplevel outports sind durch terminatoren zu ersetzen. toplevel
% input busse m�ssen vordefiniert sein in busses.mat






%handels von allen ports organisieren
currsys=get_param(gcs,'Handle');
outports=find_system(currsys,'BlockType','Outport');
inports=find_system(currsys,'BlockType','Inport');

%Ports von Busdefinition befreien, aber nicht toplevel inputs
for o=1:length(outports)
    set_param(outports(o),'UseBusObject','off');
    name=get_param(outports(o),'Name');
    for i=1:length(inports)
        if isequal(name,get_param(inports(i),'Name'))
            set_param(inports(i),'UseBusObject','off');
        end
    end
    
end

% Busobjekte neu erstellen und auch in Datei schreiben
Simulink.Bus.createObject(bdroot,gcb,'temp.m')

% ports wieder an Busdefinitionen koppeln, bevor handels gecleaerd werden
for o=1:length(outports)
    if exist(get_param(outports(o),'Name'),'var') set_param(outports(o),'UseBusObject','on', 'BusObject',get_param(outports(o),'Name')); end
end
for i=1:length(inports)
    if exist(get_param(inports(i),'Name'),'var') set_param(inports(i),'UseBusObject','on','BusObject',get_param(inports(i),'Name')); end
end

% workspace l�schen (da sind die Busse zum teil doppelt, da sie von Simulink automatisch
% in "slBusxyz_busname" umbenannt werden um alte nicht zu �berschreiben
clear;

%alte busse laden und temp. m-file ausf�hren, das busse als cell
%zur�ckgibt, aber nichts in den Workspace schreiben
load('busses.mat');
cellobj=temp(false);

%cell manipulieren, um slBus-Pr�fix wegzukriegen
cellobj=removeSlBus(cellobj);

%busobjekte im Workspace erstellen, alte werden ggf. �berschrieben
Simulink.Bus.cellToObject(cellobj);

%tempor�re dinge l�schen
clear cellobj;
delete('temp.m');

