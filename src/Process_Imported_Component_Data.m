function [C_Data]=Process_Imported_Component_Data(Component_Data,COMPDATA, FRAGDATA)

for i=1:size(Component_Data,1)
    if isnumeric(Component_Data{i,3})==1
        if strcmp(COMPDATA.C_code(Component_Data{i,3},1),'User_BV')==1 || strcmp(COMPDATA.C_code(Component_Data{i,3},1),'User_MV')==1
            C_id=Component_Data{i,3};
            C_type=222;
            C_edp=Component_Data{i,7};
            C_name=Component_Data{i,2};
            save('temp.mat','C_id','C_type','C_edp','C_name');
            waitfor(Module_PredictorData_App);
            load('temp.mat','OK');
            if OK~=1
                return
            end
            delete('temp.mat');
        end
        % Component ID
        C_Data (i,1)=(Component_Data{i,3});
        IDXF=find(C_Data (i,1)==FRAGDATA.C_ID);
        UnitVal  = FRAGDATA.DS_UnitVal (IDXF(1,1));
        % Component Location
        if strcmp(Component_Data{i,4},'Typ.')==1
            C_Data (i,2)=0;
        else
            C_Data (i,2)=(Component_Data{i,4});
        end
        % Number of Cost Units
        C_Data (i,3)=(Component_Data{i,5})/UnitVal;
        % Number of Damage States
        C_Data (i,4)=(Component_Data{i,6});
        % Level Type
        if strcmp(Component_Data{i,8},'Story')==1
            C_Data (i,5)=1;
        else
            C_Data (i,5)=2;
        end
    else
        if strcmp(COMPDATA.C_code(str2double(Component_Data{i,3}),1),'User_BV')==1  || strcmp(COMPDATA.C_code(str2double(Component_Data{i,3}),1),'User_MV')==1
            C_id    = Component_Data{i,3};
            C_type  = 222;
            C_edp   = str2double(Component_Data{i,7});
            C_name  = str2double(Component_Data{i,2});
            save('temp.mat','C_id','C_type','C_edp','C_name');
            waitfor(Module_PredictorData_App);
            load('temp.mat','OK');
            if OK~=1
                return
            end
            delete('temp.mat');
        end
        % Component ID
        C_Data (i,1)=str2double(Component_Data{i,3});
        IDXF=find(C_Data (i,1)==FRAGDATA.C_ID);
        UnitVal  = FRAGDATA.DS_UnitVal (IDXF(1,1));
        
        if strcmp(Component_Data{i,4},'Typ.')==1
            % Component Location
            C_Data (i,2)=0;
        else
            C_Data (i,2)=str2double(Component_Data{i,4});
        end
        % Number of Cost Units
        C_Data (i,3)=str2double(Component_Data{i,5})/UnitVal;
        % Number of Damage States
        C_Data (i,4)=str2double(Component_Data{i,6});
        % Level Type
        if strcmp(Component_Data{i,8},'Story')==1
            C_Data (i,5)=1;
        else
            C_Data (i,5)=2;
        end
    end
end

end