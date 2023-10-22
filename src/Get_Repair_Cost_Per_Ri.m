function [CIDs, Elevation, CollapseCount, DemolitionCount, PlacardCount, InjuryCount, CasualtyCount, Realization_Filtered, REPAIR_COST_Per_Ri, REPAIR_COST_Per_Ri_Filtered, STORY_REPAIR_COST_SC_Per_Ri, STORY_REPAIR_COST_NSC_SDR_Per_Ri, STORY_REPAIR_COST_NSC_ACC_Per_Ri, MCAC, lambda, AreaMCAC]=Get_Repair_Cost_Per_Ri(Stripe)

global MainDirectory ProjectName ProjectPath
cd (ProjectPath); load (ProjectName); cd (MainDirectory)

if Component_Option==1
    CIDs        = unique(C_Data(:,1),'sorted');
else
    CIDs=0;
end

Elevation   = 1:N_Story+1;

% Count collpases and demolitions
CollapseCount=0;
DemolitionCount=0;
for Ri=1:nRealization
    if COLLAPSE_LOSSES_Per_Ri(Ri,Stripe)~=0;   CollapseCount   = CollapseCount   + 1; end
    if DEMOLITION_LOSSES_Per_Ri(Ri,Stripe)~=0; DemolitionCount = DemolitionCount + 1; end
end

% Count Placard
PlacardCount=0;
if Placardstatus==1 && Component_Option==1
    for i=1:size(DEAGG_DATA,1)
        if DEAGG_DATA(i,1)==Stripe && DEAGG_DATA(i,16)==1;  PlacardCount = PlacardCount + 1;  end
    end
end

% Count Injuries and casualties
InjuryCount=0;
CasualtyCount=0;
if Casualtystatus==1 && Component_Option==1
    for i=1:size(DEAGG_DATA,1)
        if DEAGG_DATA(i,1)==Stripe
            InjuryCount = InjuryCount + DEAGG_DATA(i,13);
        end
        if DEAGG_DATA(i,1)==Stripe
            CasualtyCount = CasualtyCount + DEAGG_DATA(i,14);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
sizex=nRealization-CollapseCount-DemolitionCount;
Realization_Filtered=zeros(sizex,1);
REPAIR_COST_Per_Ri_Filtered=zeros(sizex,1);
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


MCAC=0;
lambda=0;
AreaMCAC=0;
if HazardDataStatus ==1
    %% Annual Rate of Exceeding the repair cost
    MCAC=0.0:(max(0.01,max(REPAIR_COST_Per_Ri)*1.1)-min(REPAIR_COST_Per_Ri))/50:max(0.01,max(REPAIR_COST_Per_Ri)*1.1);
    lambda=normcdf(MCAC,mean(REPAIR_COST_Per_Ri_Filtered),std(REPAIR_COST_Per_Ri_Filtered));
    lambda=1-lambda;
    HazardSlope = abs(diff(MAF));
    for i=1:length(IMpoints)-1
        if TargetIM(1,Stripe)>=IMpoints(1,i) && TargetIM(1,Stripe)<IMpoints(1,i+1)
            indexSa1=i;
            break
        end
    end
    HazardSlope_at_TargetIM=abs((MAF(indexSa1,1)-MAF(indexSa1-1,1))/(IMpoints(1,indexSa1)-IMpoints(1,indexSa1-1)));
    lambda=lambda*HazardSlope_at_TargetIM;
    MCAC(end+1)=max(max(MCAC),0.001);
    lambda(end+1)=0.0;
    AreaMCAC=0;
    for i=1:size(MCAC,2)-1
        AreaMCAC=AreaMCAC+(MCAC(i+1)-MCAC(i))*(lambda(i+1)+lambda(i))/2;
    end
end
