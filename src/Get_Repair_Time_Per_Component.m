function [Time_Loss_Per_Component,Time_Loss_Per_Component_Per_Story]=Get_Repair_Time_Per_Component(Stripe,TimeModel,R_target,COMPDATA,DEAGG_DATA,N_Story,CIDs)

IDX_STRIP=find(DEAGG_DATA(:,1)==Stripe & DEAGG_DATA(:,6)==R_target);
Time_Loss_Per_Story=zeros(size(CIDs,1),N_Story+1);
for i=1:size(CIDs,1)
    for n=1:N_Story+1
        for j=min(IDX_STRIP):max(IDX_STRIP)
            if DEAGG_DATA(j,3)==CIDs(i,1) && DEAGG_DATA(j,2)==n
                nunits=DEAGG_DATA(j,10);
                if nunits==0; nunits=10^9; end
                if TimeModel.SchemeSameComp==0; Time_Loss_Per_Story(i,n) = Time_Loss_Per_Story(i,n) + DEAGG_DATA(j,11);         end
                if TimeModel.SchemeSameComp==1; Time_Loss_Per_Story(i,n) = Time_Loss_Per_Story(i,n) + DEAGG_DATA(j,11)/nunits;  end
            end
        end
    end
    Name(i,1)=COMPDATA.C_shortername(CIDs(i,1));
end

Clabel=unique(Name(:,1),'stable');
Time_Loss_Per_Component_Per_Story=zeros(size(Clabel,1),N_Story+1);
for i=1:size(Clabel,1)
    for j=1:size(Time_Loss_Per_Story,1)
        if Clabel(i,1)==Name(j,1)
            Time_Loss_Per_Component_Per_Story(i,:) = Time_Loss_Per_Component_Per_Story(i,:) + Time_Loss_Per_Story(j,:);
        end
    end
end
Time_Loss_Per_Component=sum(Time_Loss_Per_Component_Per_Story,2);

end