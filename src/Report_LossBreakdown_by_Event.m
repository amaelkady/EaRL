function Report_LossBreakdown_by_Event(DEAGG_DATA,COLLAPSE_LOSSES_Per_IM,DEMOLITION_LOSSES_Per_IM,COLLAPSE_LOSSES_Per_Ri,DEMOLITION_LOSSES_Per_Ri,IMpoints,Sa_target,UnitOption,Replacement_Cost,N_Story,RunMethodology,R_target,nRealization,TargetIM,Stripe,Component_Option,ReportFilesPath)
global MainDirectory

if UnitOption==1
    NormVal=10^6;
    label='Loss [M$]';
else
    NormVal=Replacement_Cost/100;
    label='Loss [% RC]';
end

if RunMethodology==1
    
    % Get index of target IM point
    for i=1:length(IMpoints)-1
        if Sa_target>=IMpoints(1,i) && Sa_target<IMpoints(1,i+1)
            indexSa1=i;
            break
        end
    end
    
    % Get Repair cost losses for SC and NSC at target IM
    INDX_SC      =find(indexSa1==DEAGG_DATA(:,1) & DEAGG_DATA(:,5)==1);
    INDX_NSC_SDR =find(indexSa1==DEAGG_DATA(:,1) & DEAGG_DATA(:,5)==2);
    INDX_NSC_ACC =find(indexSa1==DEAGG_DATA(:,1) & DEAGG_DATA(:,5)==3);
    
    SUM=0.0;
    for k=1:size(INDX_SC,1)
        SUM=SUM+DEAGG_DATA(INDX_SC(k,1),4);
    end
    REPAIR_COST_SC=SUM;
    
    SUM=0.0;
    for k=1:size(INDX_NSC_SDR,1)
        SUM=SUM+DEAGG_DATA(INDX_NSC_SDR(k,1),4);
    end
    REPAIR_COST_NSC_SDR=SUM;
    
    SUM=0.0;
    for k=1:size(INDX_NSC_ACC,1)
        SUM=SUM+DEAGG_DATA(INDX_NSC_ACC(k,1),4);
    end
    REPAIR_COST_NSC_ACC=SUM;
    
    X = [COLLAPSE_LOSSES_Per_IM(indexSa1,1) DEMOLITION_LOSSES_Per_IM(indexSa1,1) REPAIR_COST_SC REPAIR_COST_NSC_SDR REPAIR_COST_NSC_ACC];
    
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
    
    counter=1;
    for Ri=1:size(REPAIR_COST_Per_Ri,1)
        if COLLAPSE_LOSSES_Per_Ri(Ri,Stripe)==0 && DEMOLITION_LOSSES_Per_Ri(Ri,Stripe)==0
            Realization_Filtered(counter,1)=Ri;
            REPAIR_COST_Per_Ri_Filtered(counter,1)=REPAIR_COST_Per_Ri(Ri,1);
            counter=counter+1;
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
    
    X = [COLLAPSE_LOSSES_Per_Ri(R_target,Stripe) DEMOLITION_LOSSES_Per_Ri(R_target,Stripe) sum(STORY_REPAIR_COST_SC_Per_Ri(R_target,:)) sum(STORY_REPAIR_COST_NSC_SDR_Per_Ri(R_target,:)) sum(STORY_REPAIR_COST_NSC_ACC_Per_Ri(R_target,:))];
    
end

cd (ReportFilesPath)
fileX = fopen('Loss Breakdown by Event.txt','wt');
if RunMethodology==1
    fprintf(fileX,'%s\n',[num2str(round(sum(X/10^6)*100)/100),'M$ Loss at IM=', num2str(round(Sa_target*100)/100),'g']);
else
    fprintf(fileX,'%s\n',[num2str(round(sum(X/10^6)*100)/100),'M$ Loss at IM=', num2str(round(TargetIM(1,Stripe)*100)/100),'g, Ri #', num2str(R_target)]);
end
fprintf(fileX,'%s\n','----------------------------');

fprintf(fileX,'%s\t%s\n','EVENT     ',label);
fprintf(fileX,'%s\n','----------------------------');
fprintf(fileX,'%s\t%f\n', 'Collapse  ', X(1,1)/NormVal);
fprintf(fileX,'%s\t%f\n', 'Demolition', X(1,2)/NormVal);
fprintf(fileX,'%s\t%f\n', 'SC        ', X(1,3)/NormVal);
fprintf(fileX,'%s\t%f\n', 'NSC-SDR   ', X(1,4)/NormVal);
fprintf(fileX,'%s\t%f',   'NSC-ACC   ', X(1,5)/NormVal);


fclose(fileX);
cd (MainDirectory)

end