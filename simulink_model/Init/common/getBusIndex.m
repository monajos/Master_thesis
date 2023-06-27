function index=getBusIndex(busName,signalName)

if ~iscell(signalName)
    signalName={signalName};
end

names=getBusTable(busName)';
index=NaN(size(signalName));
[r,c]=find(strcmp(repmat(names(:),1,length(signalName)),repmat(signalName(:)',length(names),1)));
index(c)=r;

end

