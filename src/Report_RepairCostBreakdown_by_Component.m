function []= Report_RepairCostBreakdown_by_Component(DEAGG_DATA,C_Data,COMPDATA,N_Story,IMpoints,Sa_target,UnitOption,Replacement_Cost,RunMethodology,R_target,nRealization,TargetIM,Stripe,ReportFilesPath)

global MainDirectory

if UnitOption==1
    NormVal=10^6;
    label='Repair cost [M$]';
else
    NormVal=Replacement_Cost/100;
    label='Repair cost [% RC]';
end

if RunMethodology==1
    
    % Get index of target IM point
    for i=1:length(IMpoints)-1
        if Sa_target>=IMpoints(1,i) && Sa_target<IMpoints(1,i+1)
            indexSa1=i;
            break
        end
    end
    
    % Get the unique SC IDs
    CIDs = unique(C_Data(:,1));
    
    DEAGG_STORY_LOSS=zeros(size(CIDs,1),N_Story+1);
    % Get Repair cost losses at target IM
    for i=1:size(CIDs,1)  % Loop over all Components
        for n=1:N_Story+1   % Loop over all stories
            INDX =find(CIDs(i,1)==DEAGG_DATA(:,3) & n==DEAGG_DATA(:,2) & indexSa1==DEAGG_DATA(:,1));
            SUM=0.0;
            for k=1:size(INDX,1)
                SUM=SUM+DEAGG_DATA(INDX(k,1),4);
            end
            DEAGG_STORY_LOSS(i,n)=SUM;
        end
        Name(i,1)=COMPDATA.C_shortername(CIDs(i,1));
    end
    
    Clabel=unique(Name(:,1),'stable');
    
    DEAGG_STORY_LOSSX=zeros(size(Clabel,1),N_Story+1);
    % Sum up repair costs for components with similar "short names"
    for i=1:size(Clabel,1)
        SUM=0.0;
        for j=1:size(DEAGG_STORY_LOSS,1)  % Loop over all Componentss
            if Clabel(i,1)==Name(j,1)
                SUM=SUM+DEAGG_STORY_LOSS(j,:);
            end
        end
        DEAGG_STORY_LOSSX(i,:)=SUM;
    end
    
    DEAGG_STORY_LOSSX=sum(DEAGG_STORY_LOSSX,2);
    
else
    
    % Get the unique SC IDs
    CIDs = unique(C_Data(:,1));
    IDX_STRIP=find(DEAGG_DATA(:,1)==Stripe & DEAGG_DATA(:,6)==R_target);
    
    DEAGG_STORY_LOSS=zeros(size(CIDs,1),1);
    for i=1:size(CIDs,1)
        for j=min(IDX_STRIP):max(IDX_STRIP)
            if DEAGG_DATA(j,3)==CIDs(i,1)
                DEAGG_STORY_LOSS(i,1) = DEAGG_STORY_LOSS(i,1) + DEAGG_DATA(j,4);
            end
        end
        Name(i,1)=COMPDATA.C_shortername(CIDs(i,1));
    end
    
    Clabel=unique(Name(:,1),'stable');
    DEAGG_STORY_LOSSX=zeros(size(Clabel,1),1);
    for i=1:size(Clabel,1)
        for j=1:size(DEAGG_STORY_LOSS,1)
            if Clabel(i,1)==Name(j,1)
                DEAGG_STORY_LOSSX(i,1) = DEAGG_STORY_LOSSX(i,1) + DEAGG_STORY_LOSS(j,1);
            end
        end
        Name(i,1)=COMPDATA.C_shortername(CIDs(i,1));
    end
    

end

MaxLosses=sum(sum(DEAGG_STORY_LOSSX));

cd (ReportFilesPath)
fileX = fopen('Repair Cost Breakdown by Component Name.txt','wt');
if RunMethodology==1
    fprintf(fileX,'%s\n',[num2str(round(MaxLosses/10^6*100)/100),'M$ Loss at IM=', num2str(round(Sa_target*100)/100),'g']);
else
    fprintf(fileX,'%s\n',[num2str(round(MaxLosses/10^6*100)/100),'M$ Loss for IM=', num2str(TargetIM(1,Stripe)),'g, Ri #', num2str(R_target)]);
end
fprintf(fileX,'%s\n','----------------------------------');

fprintf(fileX,'%20s\t%s\n','COMPONENT NAME',label);
fprintf(fileX,'%s\n','----------------------------------');
for i=1:size(Clabel)
    fprintf(fileX,'%20s\t%f\n', Clabel(i,1), DEAGG_STORY_LOSSX(i,1)/NormVal);
end

fclose(fileX);
cd (MainDirectory)

end