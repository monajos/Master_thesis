function busify(busname,filename)

fid = fopen(filename,'w');

k=1;
busifyRec(busname,busname);

    function busifyRec(table,name)
        
        
        %elements=evalin('base',[name,'.Élements']);
        elements=evalin('base',[name,'.Elements']);
        for i=1:length(elements)
            name=elements(i).DataType;
            if isequal(name(1:5),'Bus: ')
                name = name(6:end);
            end
            if evalin('base',['exist(''',name,'''',',''var'')'])
                busifyRec([table,'.',elements(i).Name],name);
            else
                dimensi=ones(2,1);
                for d=1:length(elements(i).Dimensions)
                    dimensi(d)=elements(i).Dimensions(d);
                end
                for d1=1:dimensi(1);
                    for d2=1:dimensi(2);
                        str=['vec(',num2str(k),')=',table,'.',elements(i).Name,'(',num2str(d1),',',num2str(d2),');\n'];
                        fprintf(fid,str);
                        k=k+1;
                    end
                end
            end
        end
    end

status = fclose(fid);

end

