function Report_RepairCostProfile_by_Component(DEAGG_DATA,C_Data,COMPDATA,N_Story,IMpoints,Sa_target,UnitOption,Replacement_Cost,RunMethodology,R_target,nRealization,TargetIM,Stripe,ReportFilesPath)

global MainDirectory

if UnitOption==1
    NormVal=10^6;
    label='Repair cost [M$]';
else
    NormVal=Replacement_Cost/100;
    label='Repair cost [% RC]';
end

Elevation=1:N_Story+1;

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
    
    for i=1:size(CIDs,1)  % Loop over all SC
        for j=1:N_Story+1   % Loop over all stories
            SUM=0.0;
            % find the row index corrosponding to loss at a given story and component and intensity level
            INDX=find(CIDs(i,1)==DEAGG_DATA(:,3) & j==DEAGG_DATA(:,2) & indexSa1==DEAGG_DATA(:,1));
            for k=1:size(INDX,1)
                SUM=SUM+DEAGG_DATA(INDX(k,1),4);
            end
            DEAGG_STORY_LOSS(i,j)=SUM; % the rows of this array represents the component number while the columns represent the story
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
    
else
    
    % Get the unique SC IDs
    CIDs = unique(C_Data(:,1));
    IDX_STRIP=find(DEAGG_DATA(:,1)==Stripe);
    
    DEAGG_STORY_LOSS=zeros(size(CIDs,1),N_Story+1);
    for i=1:size(CIDs,1)
        for j=min(IDX_STRIP):max(IDX_STRIP)
            for n=1:N_Story+1
                if DEAGG_DATA(j,3)==CIDs(i,1) && DEAGG_DATA(j,2)==n && DEAGG_DATA(j,6)==R_target
                    DEAGG_STORY_LOSS(i,n) = DEAGG_STORY_LOSS(i,n) + DEAGG_DATA(j,4);
                end
            end
        end
        Name(i,1)=COMPDATA.C_shortername(CIDs(i,1));
    end
    
    Clabel=unique(Name(:,1),'stable');
    
    DEAGG_STORY_LOSSX=zeros(size(Clabel,1),N_Story+1);
    for i=1:size(Clabel,1)
        for j=1:size(DEAGG_STORY_LOSS,1)
            if Clabel(i,1)==Name(j,1)
                DEAGG_STORY_LOSSX(i,:) = DEAGG_STORY_LOSSX(i,:) + DEAGG_STORY_LOSS(j,:);
            end
        end
        Name(i,1)=COMPDATA.C_shortername(CIDs(i,1));
    end
    
end

MaxLosses=sum(sum(DEAGG_STORY_LOSSX));

cd (ReportFilesPath)
fileX = fopen('Repair Cost Profile Breakdown by Component Name.txt','wt');
if RunMethodology==1
    fprintf(fileX,'%s\n',[num2str(round(MaxLosses/10^6*100)/100),'M$ Repair Loss at IM=', num2str(round(Sa_target*100)/100),'g']);
else
    fprintf(fileX,'%s\n',[num2str(round(MaxLosses/10^6*100)/100),'M$ Loss for IM=', num2str(TargetIM(1,Stripe)),'g, Ri #', num2str(R_target)]);
end
fprintf(fileX,'%s','------------------------');
for i=2:N_Story+1
    fprintf(fileX,'%s','------------------------');
end
fprintf(fileX,'\n');
fprintf(fileX,'%20s\t%s\t','COMPONENT NAME','LEVEL-1   ');
for i=2:N_Story+1
    fprintf(fileX,'%s%d%s\t','LEVEL-',i,'   ');
end
fprintf(fileX,'\n%s','------------------------');
for i=2:N_Story+1
    fprintf(fileX,'%s','------------------------');
end
fprintf(fileX,'\n');


for ii=1:size(Clabel)
    fprintf(fileX,'%20s\t%f\t', Clabel(ii,1), DEAGG_STORY_LOSSX(ii,1)/NormVal);
    for i=2:N_Story+1
        fprintf(fileX,'%f\t',   DEAGG_STORY_LOSSX(ii,i)/NormVal);
    end
    fprintf(fileX,'\n');
end

fclose(fileX);
cd (MainDirectory)

end