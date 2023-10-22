function []= Report_RepairCost_vs_Realizations(DEAGG_DATA,COLLAPSE_LOSSES_Per_Ri,DEMOLITION_LOSSES_Per_Ri,UnitOption,Replacement_Cost,nRealization,Stripe,Component_Option,ReportFilesPath)

global MainDirectory

if UnitOption==1
    NormVal=10^6;
    str='Cost [M$]';    
else
    NormVal=Replacement_Cost/100;
    str='Cost [% \itCost\rm]';
end

if Component_Option==1
    REPAIR_COST_Per_Ri=zeros(nRealization,1);
    IDX_STRIP=find(DEAGG_DATA(:,1)==Stripe);
    for Ri=1:nRealization
        for i=min(IDX_STRIP):max(IDX_STRIP)
            if DEAGG_DATA(i,6)==Ri
                REPAIR_COST_Per_Ri(Ri,1)=REPAIR_COST_Per_Ri(Ri,1) + DEAGG_DATA(i,4);
            end
        end
    end  
else
    REPAIR_COST_Per_Ri=zeros(nRealization,1);
    IDX_STRIP=find(DEAGG_DATA(:,1)==Stripe);
    for Ri=1:nRealization
        for i=min(IDX_STRIP):max(IDX_STRIP)
            if DEAGG_DATA(i,2)==Ri
                REPAIR_COST_Per_Ri(Ri,1)=REPAIR_COST_Per_Ri(Ri,1) + DEAGG_DATA(i,7);
            end
        end
    end                  
end
            
counter=1;
for Ri=1:size(REPAIR_COST_Per_Ri,1)
    if COLLAPSE_LOSSES_Per_Ri(Ri,Stripe)==0 && DEMOLITION_LOSSES_Per_Ri(Ri,Stripe)==0
        Realization_Filtered(counter,1)=Ri;
        REPAIR_COST_Per_Ri_Filtered(counter,1)=REPAIR_COST_Per_Ri(Ri,1);
        counter=counter+1;
    end
end  
    
%X_Data=1:nRealization;
%X_Data=X_Data';
X_Data=Realization_Filtered;
Y_Data=REPAIR_COST_Per_Ri_Filtered/NormVal;

cd (ReportFilesPath)
fileX = fopen('Repair Cost vs Realizations.txt','wt');

if UnitOption==1
    fprintf(fileX,'%s\t%s\n','Realization    ','Repair Cost [M$]');
else
    fprintf(fileX,'%s\t%s\n','Realization    ','Repair Cost [% Replacement Cost]');
end
fprintf(fileX,'%s\n','-------------------------------------------------------------------------------------------------');    

for i=1:size(X_Data,1)
    fprintf(fileX,'%d\t%f\n',  X_Data(i,1), Y_Data(i,1));
end

fclose(fileX);
cd (MainDirectory)


end