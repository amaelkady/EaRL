function [Cost_Loss_Per_Component, Clabel]=Get_Repair_Cost_Breakdown_by_Component(Stripe,R_target,COMPDATA,DEAGG_DATA,CIDs)

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
Cost_Loss_Per_Component=zeros(size(Clabel,1),1);
for i=1:size(Clabel,1)
    for j=1:size(DEAGG_STORY_LOSS,1)
        if Clabel(i,1)==Name(j,1)
            Cost_Loss_Per_Component(i,1) = Cost_Loss_Per_Component(i,1) + DEAGG_STORY_LOSS(j,1);
        end
    end
end