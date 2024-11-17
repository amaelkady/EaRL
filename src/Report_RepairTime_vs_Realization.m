function Report_RepairTime_vs_Realization(DEAGG_DATA,C_Data,COMPDATA,N_Story,TimeModel,nRealization,Stripe,COLLAPSE_LOSSES_Per_Ri,DEMOLITION_LOSSES_Per_Ri,ReportFilesPath)

global MainDirectory

% Get the unique component IDs
CIDs = unique(C_Data(:,1));
CIDs = sort(CIDs);

% Trim Matrix
counti=0;
for i=1:size(TimeModel.TimeMatrix,1)
    if TimeModel.TimeMatrix(i,1)~=0
        counti=counti+1;
    else
        break;
    end
    countj=0;
    for j=1:size(TimeModel.TimeMatrix,2)
        if TimeModel.TimeMatrix(i,j)~=0
            countj=countj+1;
            X1(counti,countj)=TimeModel.TimeMatrix(i,j);
        end
    end
end
TimeModel.TimeMatrix=X1;

for Ri=1:nRealization
    IDX_STRIP=find(DEAGG_DATA(:,1)==Stripe & DEAGG_DATA(:,6)==Ri);
    
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
    
    MaxTimeStory=zeros(size(TimeModel.TimeMatrix,1),N_Story+1);
    for i=1:size(TimeModel.TimeMatrix,1)
        if TimeModel.TimeMatrix(i,1)==0; break; end
        for j=1:size(TimeModel.TimeMatrix(i,:),2)
            if TimeModel.TimeMatrix(i,j)==0; break; end
            IDX=find(CIDs==TimeModel.TimeMatrix(i,j)) ;
            for n=1:N_Story+1
                MaxTimeStory(i,n)=max(MaxTimeStory(i,n),DEAGG_STORY_LOSS(IDX,n));
            end
        end
    end
    MaxTimeStory=sum(MaxTimeStory,1); %% Added August 2024 to fix repair time (sequential vs simultaneous repair of different component types at the same storey/floor);

    if TimeModel.SchemeFloor==0; REPAIR_TIME_Per_Ri(Ri,1)=max(sum(MaxTimeStory,2));    end
    if TimeModel.SchemeFloor==1; REPAIR_TIME_Per_Ri(Ri,1)=max(max(MaxTimeStory,[],2)); end
end

counter=1;
Realization_Filtered=0;
REPAIR_TIME_Per_Ri_Filtered=0;
for Ri=1:nRealization
    if COLLAPSE_LOSSES_Per_Ri(Ri,Stripe)==0 && DEMOLITION_LOSSES_Per_Ri(Ri,Stripe)==0
        Realization_Filtered(counter,1)=Ri;
        REPAIR_TIME_Per_Ri_Filtered(counter,1)=REPAIR_TIME_Per_Ri(Ri,1);
        counter=counter+1;
    end
end


cd (ReportFilesPath)
fileX = fopen('Repair Time vs Realizations.txt','wt');
fprintf(fileX,'%s\t%s\n','Realization    ','Repair Time [days]');
fprintf(fileX,'%s\n','-------------------------------------------------------------------------------------------------');    

for i=1:size(Realization_Filtered,1)
    fprintf(fileX,'%d\t%f\n',  Realization_Filtered(i,1), REPAIR_TIME_Per_Ri_Filtered(i,1));
end

fclose(fileX);
cd (MainDirectory)


end