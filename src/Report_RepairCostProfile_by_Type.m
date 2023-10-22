function Report_RepairCostProfile_by_Type(DEAGG_DATA,STORY_REPAIR_COST_SC,STORY_REPAIR_COST_NSC_SDR,STORY_REPAIR_COST_NSC_ACC,N_Story,IMpoints,Sa_target,UnitOption,Replacement_Cost,RunMethodology,R_target,nRealization,TargetIM,Stripe,Component_Option,ReportFilesPath)

global MainDirectory

if UnitOption==1
    NormVal=10^6;
    label='Repair cost [M$]';
else
    NormVal=Replacement_Cost/100;
    label='Repair cost [% RC]';
end

if RunMethodology==1
    
    for i=1:length(IMpoints)-1
        if Sa_target>=IMpoints(1,i) && Sa_target<IMpoints(1,i+1)
            indexSa1=i;
            break
        end
    end
    
    Max1=sum(sum(STORY_REPAIR_COST_SC(indexSa1,:)));
    Max2=sum(sum(STORY_REPAIR_COST_NSC_SDR(indexSa1,:)));
    Max3=sum(sum(STORY_REPAIR_COST_NSC_ACC(indexSa1,:)));
    MaxLosses=Max1+Max2+Max3;
    
    cd (ReportFilesPath)
    fileX = fopen('Repair Cost Profile Breakdown by Component Type.txt','wt');
    fprintf(fileX,'%s\n',[num2str(round(MaxLosses/10^6*100)/100),'M$ Repair Loss for IM=', num2str(round(Sa_target*100)/100),'g']);
    fprintf(fileX,'%s','------------------------');
    for i=2:N_Story+1
        fprintf(fileX,'%s','------------------------');
    end
    fprintf(fileX,'\n');
    fprintf(fileX,'%s\t%s\t','EVENT     ','STORY-1   ');
    for i=2:N_Story+1
        fprintf(fileX,'%s%d%s\t','STORY-',i,'   ');
    end
    fprintf(fileX,'\n%s','------------------------');
    for i=2:N_Story+1
        fprintf(fileX,'%s','------------------------');
    end
    fprintf(fileX,'\n');
    
    fprintf(fileX,'%s\t%f\t', 'SC        ', STORY_REPAIR_COST_SC(indexSa1,1)/NormVal);
    for i=2:N_Story+1
        fprintf(fileX,'%f\t',   STORY_REPAIR_COST_SC(indexSa1,i)/NormVal);
    end
    fprintf(fileX,'\n');
    fprintf(fileX,'%s\t%f\t', 'NSC-SDR   ', STORY_REPAIR_COST_NSC_SDR(indexSa1,1)/NormVal);
    for i=2:N_Story+1
        fprintf(fileX,'%f\t',   STORY_REPAIR_COST_NSC_SDR(indexSa1,i)/NormVal);
    end
    fprintf(fileX,'\n');
    fprintf(fileX,'%s\t%f\t', 'NSC-ACC   ', STORY_REPAIR_COST_NSC_ACC(indexSa1,1)/NormVal);
    for i=2:N_Story+1
        fprintf(fileX,'%f\t',   STORY_REPAIR_COST_NSC_ACC(indexSa1,i)/NormVal);
    end
    
    fclose(fileX);
    cd (MainDirectory)
    
else
    
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
    
    
    if Component_Option==1
        STORY_REPAIR_COST_SC_Per_Ri=zeros(nRealization,N_Story+1);
        STORY_REPAIR_COST_NSC_SDR_Per_Ri=zeros(nRealization,N_Story+1);
        STORY_REPAIR_COST_NSC_ACC_Per_Ri=zeros(nRealization,N_Story+1);
        for Ri=1:nRealization
            for n=N_Story+1:-1:1
                for i=min(IDX_STRIP):max(IDX_STRIP)
                    if DEAGG_DATA(i,6)==Ri && DEAGG_DATA(i,2)==n && DEAGG_DATA(i,5)==1
                        STORY_REPAIR_COST_SC_Per_Ri(Ri,n) = STORY_REPAIR_COST_SC_Per_Ri(Ri,n) + DEAGG_DATA(i,4);
                    elseif DEAGG_DATA(i,6)==Ri && DEAGG_DATA(i,2)==n && DEAGG_DATA(i,5)==2
                        STORY_REPAIR_COST_NSC_SDR_Per_Ri(Ri,n) = STORY_REPAIR_COST_NSC_SDR_Per_Ri(Ri,n) + DEAGG_DATA(i,4);
                    elseif DEAGG_DATA(i,6)==Ri && DEAGG_DATA(i,2)==n && DEAGG_DATA(i,5)==3
                        STORY_REPAIR_COST_NSC_ACC_Per_Ri(Ri,n) = STORY_REPAIR_COST_NSC_ACC_Per_Ri(Ri,n) + DEAGG_DATA(i,4);
                    end
                end
            end
        end
    else
        STORY_REPAIR_COST_SC_Per_Ri=zeros(nRealization,N_Story+1);
        STORY_REPAIR_COST_NSC_SDR_Per_Ri=zeros(nRealization,N_Story+1);
        STORY_REPAIR_COST_NSC_ACC_Per_Ri=zeros(nRealization,N_Story+1);
        for Ri=1:nRealization
            for n=N_Story+1:-1:1
                for i=min(IDX_STRIP):max(IDX_STRIP)
                    if DEAGG_DATA(i,2)==Ri && DEAGG_DATA(i,3)==n
                        STORY_REPAIR_COST_SC_Per_Ri     (Ri,n) = STORY_REPAIR_COST_SC_Per_Ri     (Ri,n) + DEAGG_DATA(i,4);
                        STORY_REPAIR_COST_NSC_SDR_Per_Ri(Ri,n) = STORY_REPAIR_COST_NSC_SDR_Per_Ri(Ri,n) + DEAGG_DATA(i,5);
                        STORY_REPAIR_COST_NSC_ACC_Per_Ri(Ri,n) = STORY_REPAIR_COST_NSC_ACC_Per_Ri(Ri,n) + DEAGG_DATA(i,6);
                    end
                end
            end
        end
    end
    
    Max1=sum(sum(STORY_REPAIR_COST_SC_Per_Ri(R_target,:)));
    Max2=sum(sum(STORY_REPAIR_COST_NSC_SDR_Per_Ri(R_target,:)));
    Max3=sum(sum(STORY_REPAIR_COST_NSC_ACC_Per_Ri(R_target,:)));
    MaxLosses=Max1+Max2+Max3;

    cd (ReportFilesPath)
    fileX = fopen('Repair Cost Profile Breakdown by Component Type.txt','wt');
    fprintf(fileX,'%s\n',[num2str(round(MaxLosses/10^6*100)/100),'M$ Repair Loss for IM=', num2str(TargetIM(1,Stripe)),'g, Ri #', num2str(R_target)]);
    fprintf(fileX,'%s','------------------------');
    for i=2:N_Story+1
        fprintf(fileX,'%s','------------------------');
    end
    fprintf(fileX,'\n');
    fprintf(fileX,'%s\t%s\t','EVENT     ','LEVEL-1   ');
    for i=2:N_Story+1
        fprintf(fileX,'%s%d%s\t','LEVEL-',i,'   ');
    end
    fprintf(fileX,'\n%s','------------------------');
    for i=2:N_Story+1
        fprintf(fileX,'%s','------------------------');
    end
    fprintf(fileX,'\n');
    
        fprintf(fileX,'%s\t%f\t', 'SC        ', STORY_REPAIR_COST_SC_Per_Ri(R_target,1)/NormVal);
    for i=2:N_Story+1
        fprintf(fileX,'%f\t',   STORY_REPAIR_COST_SC_Per_Ri(R_target,i)/NormVal);
    end
        fprintf(fileX,'\n');
        fprintf(fileX,'%s\t%f\t', 'NSC-SDR   ', STORY_REPAIR_COST_NSC_SDR_Per_Ri(R_target,1)/NormVal);
    for i=2:N_Story+1
        fprintf(fileX,'%f\t',   STORY_REPAIR_COST_NSC_SDR_Per_Ri(R_target,i)/NormVal);
    end
        fprintf(fileX,'\n');
        fprintf(fileX,'%s\t%f\t', 'NSC-ACC   ', STORY_REPAIR_COST_NSC_ACC_Per_Ri(R_target,1)/NormVal);
    for i=2:N_Story+1
        fprintf(fileX,'%f\t',   STORY_REPAIR_COST_NSC_ACC_Per_Ri(R_target,i)/NormVal);
    end

    fclose(fileX);
    cd (MainDirectory)
end



end