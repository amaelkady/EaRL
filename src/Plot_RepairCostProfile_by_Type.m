function []=Plot_RepairCostProfile_by_Type(DEAGG_DATA,STORY_REPAIR_COST_SC,STORY_REPAIR_COST_NSC_SDR,STORY_REPAIR_COST_NSC_ACC,N_Story,IMpoints,Sa_target,UnitOption,Replacement_Cost,RunMethodology,R_target,nRealization,TargetIM,Stripe,Component_Option)
    
if UnitOption==1
    NormVal=10^6;
    label='Repair cost [M$]';
else
    NormVal=Replacement_Cost/100;    
    label='Repair cost [% \itCost\rm]';
end

if RunMethodology==1
    
    for i=1:length(IMpoints)-1
        if Sa_target>=IMpoints(1,i) && Sa_target<IMpoints(1,i+1)
            indexSa1=i;
            break
        end
    end   

    figure('Color','w','Position', [500 300 350 350]);
    Elevation=1:N_Story+1;
    plot(STORY_REPAIR_COST_SC(indexSa1,:)/NormVal,Elevation,'-or','linewidth',2);
    grid on; box on; hold on;
    plot(STORY_REPAIR_COST_NSC_SDR(indexSa1,:)/NormVal,Elevation,'--*g','linewidth',2);
    plot(STORY_REPAIR_COST_NSC_ACC(indexSa1,:)/NormVal,Elevation,'--*','linewidth',2,'Color',[1 0.7 0]);
    set(gca, 'fontname', 'Courier', 'fontsize',18);
    xlabel (label,'fontsize',18);
    ylabel ('Story/Floor','fontsize',18);
    Max1=max(max(STORY_REPAIR_COST_SC(indexSa1,:)));
    Max2=max(max(STORY_REPAIR_COST_NSC_SDR(indexSa1,:)));
    Max3=max(max(STORY_REPAIR_COST_NSC_ACC(indexSa1,:)));
    MaxLosses=1.5*ceil(max([Max1;Max2;Max3])*10/NormVal)/10;
    set(gca,'Xlim',[0.0 max(MaxLosses,0.01)]);
    set(gca,'Ylim',[1 N_Story+1]);
    set(gca,'YTick',Elevation)
    legend1=legend ('SC','NSC-SDR','NSC-ACC');
    set(legend1,'fontname', 'Courier', 'fontsize',14,'Location','northeast');
    Max1=sum(sum(STORY_REPAIR_COST_SC(indexSa1,:)));
    Max2=sum(sum(STORY_REPAIR_COST_NSC_SDR(indexSa1,:)));
    Max3=sum(sum(STORY_REPAIR_COST_NSC_ACC(indexSa1,:)));
    MaxLosses=Max1+Max2+Max3;
    title(gca,[num2str(round(MaxLosses/10^6*100)/100),'M$ in repairs at IM=', num2str(round(Sa_target*100)/100),'g'], 'fontname', 'Courier', 'fontsize',12);


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

    %% Plot Losses Profile
    figure('Color','w','Position', [500 300 350 350]);
    Elevation=1:N_Story+1;
    plot(STORY_REPAIR_COST_SC_Per_Ri(R_target,:)/NormVal,Elevation,'-or','linewidth',2);
    grid on; box on; hold on;
    plot(STORY_REPAIR_COST_NSC_SDR_Per_Ri(R_target,:)/NormVal,Elevation,'--*g','linewidth',2);
    plot(STORY_REPAIR_COST_NSC_ACC_Per_Ri(R_target,:)/NormVal,Elevation,'--*','linewidth',2,'Color',[1.0 0.7 0.0]);
    set(gca, 'fontname', 'Courier', 'fontsize',18);
    xlabel (label,'fontsize',18);
    ylabel ('Story/Floor','fontsize',18);
    Max1=max(max(STORY_REPAIR_COST_SC_Per_Ri(R_target,:)));
    Max2=max(max(STORY_REPAIR_COST_NSC_SDR_Per_Ri(R_target,:)));
    Max3=max(max(STORY_REPAIR_COST_NSC_ACC_Per_Ri(R_target,:)));
    MaxLosses=1.5*ceil(max([Max1;Max2;Max3])*10/NormVal)/10;
    set(gca,'Xlim',[0.0 max(MaxLosses,0.01)]);
    set(gca,'Ylim',[1 N_Story+1]);
    set(gca,'YTick',Elevation)
    legend1=legend ('SC','NSC-SDR','NSC-ACC');
    set(legend1,'fontname', 'Courier', 'fontsize',14,'Location','northeast');
    Max1=sum(sum(STORY_REPAIR_COST_SC_Per_Ri(R_target,:)));
    Max2=sum(sum(STORY_REPAIR_COST_NSC_SDR_Per_Ri(R_target,:)));
    Max3=sum(sum(STORY_REPAIR_COST_NSC_ACC_Per_Ri(R_target,:)));
    MaxLosses=Max1+Max2+Max3;
    title(gca,[num2str(round(MaxLosses/10^6*100)/100),'M$ Loss for IM=', num2str(TargetIM(1,Stripe)),'g, Ri #', num2str(R_target)], 'fontname', 'Courier', 'fontsize',12);
    
end



end