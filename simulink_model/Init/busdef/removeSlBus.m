function cellobj=removeSlBus(cellobj)

for k=1:length(cellobj)
    if iscell(cellobj{k}) cellobj{k}=removeSlBus(cellobj{k});
    elseif isa(cellobj{k},'char') cellobj{k}=regexprep(cellobj{k},'slBus\d*_',''); end
end


    
    