function Plot_RepairCost_vs_Realization(DEAGG_DATA,COLLAPSE_LOSSES_Per_Ri,DEMOLITION_LOSSES_Per_Ri,UnitOption,Replacement_Cost,nRealization,Stripe,Component_Option)

    if UnitOption==1
        NormVal=10^6;
        label='Loss [M$]';
        str='Cost [M$]';
        str3='Repair Cost [M$]';
    else
        NormVal=Replacement_Cost/100;    
        label='Loss [% \itCost\rm]';
        str='Cost [% \itCost\rm]';
        str3='Repair Cost [% \itCost\rm]';
    end
        
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

            
    figure('Color','w','Position', [500 300 550 350]);
    plot(Realization_Filtered,REPAIR_COST_Per_Ri_Filtered/NormVal,'ok','MarkerFaceColor',[0.9 0.9 0.9],'MarkerEdgeColor',[0.5 0.5 0.5],'MarkerSize',4);
    box on; grid on; hold on;
    plot([0 nRealization],[mean(REPAIR_COST_Per_Ri_Filtered)/NormVal mean(REPAIR_COST_Per_Ri_Filtered)/NormVal],'--r','linewidth',2);
    plot([0 nRealization],[median(REPAIR_COST_Per_Ri_Filtered)/NormVal median(REPAIR_COST_Per_Ri_Filtered)/NormVal],'--b','linewidth',2);
    xlabel ('Realization');
    ylabel (str3);
    set(gca,'XLim',[1 nRealization]);
    Max=ceil(max(REPAIR_COST_Per_Ri_Filtered/NormVal));
    set(gca,'YLim',[0.0 max(ceil(Max),0.01)]);
    app.LossIMplot.FontName='Euclid';
    app.LossIMplot.FontSize=18;
    legend1=legend('Realization data','mean','median');
    set(legend1,'fontname','Euclid','FontSize',12,'Location','NorthWest');
    set(gca, 'fontname', 'Courier', 'fontsize',16);

end