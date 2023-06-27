function table=getBusTable(busname)
persistent busses busTable;


if isempty(busses)
    vars=evalin('base','whos');
    for k=1:length(vars)
        if isequal(vars(k).class,'Simulink.Bus')
            busses.(vars(k).name)=evalin('base',vars(k).name);
        end
    end
end

table=getBusTableRec(busname);
busTable.(busname)=table;


    function table=getBusTableRec(busname)
        
        
        
        
        if ~isfield(busTable,busname)
            table={};
            elements=busses.(busname).Elements;
            for i=1:length(elements)
                name=elements(i).DataType;
                if isequal(name(1:5),'Bus: ')
                    name = name(6:end);
                end
                if isfield(busses,name)
                    table=[table,getBusTableRec(name)];
                else
                    dimensi=ones(2,1);
                    for d=1:length(elements(i).Dimensions)
                        dimensi(d)=elements(i).Dimensions(d);
                    end
                    for d1=1:dimensi(1);
                        for d2=1:dimensi(2);
                            table=[table,elements(i).Name];
                            if(dimensi(1)>1)
                                table{end}=[table{end},'_',num2str(d1)];
                            end
                            if(dimensi(2)>1)
                                table{end}=[table{end},'_',num2str(d2)];
                            end
                        end
                    end
                    
                end
                
            end
            
        else
            table=busTable.(busname);
        end
        
    end

end