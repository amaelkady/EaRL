function Report_RepairTimeProfile_by_Type(DEAGG_DATA,C_Data,COMPDATA,N_Story,TimeModel,R_target,TargetIM,Stripe,ReportFilesPath)

global MainDirectory

Elevation=1:N_Story+1;

% Get the unique component IDs
CIDs = unique(C_Data(:,1));
CIDs = sort(CIDs);
IDX_STRIP=find(DEAGG_DATA(:,1)==Stripe & DEAGG_DATA(:,6)==R_target);

DEAGG_STORY_LOSS=zeros(size(CIDs,1),N_Story+1);
for i=1:size(CIDs,1)
    for n=1:N_Story+1
        for j=min(IDX_STRIP):max(IDX_STRIP)
            if DEAGG_DATA(j,3)==CIDs(i,1) && DEAGG_DATA(j,2)==n
                nunits=DEAGG_DATA(j,10);
                if nunits==0; nunits=10^9; end
                if TimeModel.SchemeSameComp==0; DEAGG_STORY_LOSS(i,n) = DEAGG_STORY_LOSS(i,n) + DEAGG_DATA(j,11);         end
                if TimeModel.SchemeSameComp==1; DEAGG_STORY_LOSS(i,n) = DEAGG_STORY_LOSS(i,n) + DEAGG_DATA(j,11)/nunits;  end
            end
        end
    end
    Name(i,1)=COMPDATA.C_shortername(CIDs(i,1));
end

for n=1:N_Story+1
    MaxTimeStory(1,n)=0;
    for i=1:size(TimeModel.TimeMatrix,1)
        if TimeModel.TimeMatrix(i,1)==0; break; end
        for j=1:size(TimeModel.TimeMatrix(i,:),2)
            if TimeModel.TimeMatrix(i,j)==0; break; end
            IDX=find(CIDs==TimeModel.TimeMatrix(i,j)) ;
            MaxTimeStory(1,n)=MaxTimeStory(1,n)+max(DEAGG_STORY_LOSS(IDX,n));
        end
    end
end

Clabel=unique(Name(:,1),'stable');
DEAGG_STORY_LOSSX=zeros(size(Clabel,1),N_Story+1);
for i=1:size(Clabel,1)
    for j=1:size(DEAGG_STORY_LOSS,1)
        if Clabel(i,1)==Name(j,1)
            DEAGG_STORY_LOSSX(i,:) = DEAGG_STORY_LOSSX(i,:) + DEAGG_STORY_LOSS(j,:);
        end
    end
end

MaxTime=max(MaxTimeStory);

STORY_REPAIR_TIME_SC_Per_Ri=zeros(1,N_Story+1);
STORY_REPAIR_TIME_NSC_SDR_Per_Ri=zeros(1,N_Story+1);
STORY_REPAIR_TIME_NSC_ACC_Per_Ri=zeros(1,N_Story+1);
for n=1:N_Story+1
    for i=1:size(Clabel,1)
        INDX_COMP=find(COMPDATA.C_shortername==Clabel(i));
        if strcmp(COMPDATA.C_Category2(INDX_COMP(1),1),"Superstructure")==1
            STORY_REPAIR_TIME_SC_Per_Ri(1,n) = STORY_REPAIR_TIME_SC_Per_Ri(1,n) + DEAGG_STORY_LOSSX(i,n);
        elseif strcmp(COMPDATA.C_Category2(INDX_COMP(1),1),"Superstructure")~=1 && strcmp(COMPDATA.C_EDP(INDX_COMP(1),1),"PFA")~=1
            STORY_REPAIR_TIME_NSC_SDR_Per_Ri(1,n) = STORY_REPAIR_TIME_NSC_SDR_Per_Ri(1,n) + DEAGG_STORY_LOSSX(i,n);
        elseif strcmp(COMPDATA.C_Category2(INDX_COMP(1),1),"Superstructure")~=1 && strcmp(COMPDATA.C_EDP(INDX_COMP(1),1),"PFA")==1
            STORY_REPAIR_TIME_NSC_ACC_Per_Ri(1,n) = STORY_REPAIR_TIME_NSC_ACC_Per_Ri(1,n) + DEAGG_STORY_LOSSX(i,n);
        elseif strcmp(COMPDATA.C_Category2(INDX_COMP(1),1),"Superstructure")~=1 && strcmp(COMPDATA.C_EDP(INDX_COMP(1),1),"PGA")==1
            STORY_REPAIR_TIME_NSC_ACC_Per_Ri(1,n) = STORY_REPAIR_TIME_NSC_ACC_Per_Ri(1,n) + DEAGG_STORY_LOSSX(i,n);
        end
    end
end

cd (ReportFilesPath)
fileX = fopen('Repair Time Profile Breakdown by Component Type.txt','wt');
fprintf(fileX,'%s\n',[num2str(round(MaxTime/10)/10),' days repair time for IM=', num2str(TargetIM(1,Stripe)),'g, Ri #', num2str(R_target)]);
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

fprintf(fileX,'%s\t%f\t', 'SC        ', STORY_REPAIR_TIME_SC_Per_Ri(R_target,1));
for i=2:N_Story+1
    fprintf(fileX,'%f\t',   STORY_REPAIR_TIME_SC_Per_Ri(R_target,i));
end
fprintf(fileX,'\n');
fprintf(fileX,'%s\t%f\t', 'NSC-SDR   ', STORY_REPAIR_TIME_NSC_SDR_Per_Ri(R_target,1));
for i=2:N_Story+1
    fprintf(fileX,'%f\t',   STORY_REPAIR_TIME_NSC_SDR_Per_Ri(R_target,i));
end
fprintf(fileX,'\n');
fprintf(fileX,'%s\t%f\t', 'NSC-ACC   ', STORY_REPAIR_TIME_NSC_ACC_Per_Ri(R_target,1));
for i=2:N_Story+1
    fprintf(fileX,'%f\t',   STORY_REPAIR_TIME_NSC_ACC_Per_Ri(R_target,i));
end

fclose(fileX);
cd (MainDirectory)

end