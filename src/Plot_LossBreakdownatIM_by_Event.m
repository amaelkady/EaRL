function []=Plot_LossBreakdownatIM_by_Event(COLLAPSE_LOSSES_Per_IM,DEMOLITION_LOSSES_Per_IM,SC_REPAIR_COST_PerIM,NSC_SDR_REPAIR_COST_PerIM,NSC_ACC_REPAIR_COST_PerIM,IMpoints,Sa_target,Loss_PieChart,UnitOption,Replacement_Cost)

figure('Color','w','Position', [500 300 450 350]);
set(gca, 'fontname', 'Courier', 'fontsize',18);
    
if UnitOption==1
    NormVal=10^6;
    label='Loss [M$]';
else
    NormVal=Replacement_Cost/100;    
    label='Loss [% \itCost\rm]';
end

if Loss_PieChart == 1
    for i=1:length(IMpoints)-1
        if Sa_target>=IMpoints(1,i) && Sa_target<IMpoints(1,i+1)
            %indexSa1=i;
            X = [COLLAPSE_LOSSES_Per_IM(i,1) DEMOLITION_LOSSES_Per_IM(i,1) SC_REPAIR_COST_PerIM(i,1) NSC_SDR_REPAIR_COST_PerIM(i,1) NSC_ACC_REPAIR_COST_PerIM(i,1)];
            break
        end
    end
    pie(X);
    %labels = {'Collapse','Demolition','SC','NSC-SDR','NSC-ACC'};
    set(gca, 'fontname', 'Courier', 'fontsize',18);
    colormap([0 0 0;      %// black
              0 0 1;      %// blue
              1 0 0;      %// red
              0 1 0;      %// green
              1 0.7 0])   %// yellow
    %  set(h(2:2:6),'FontSize',14);     
    %  legend(labels,'Location','southoutside','Orientation','horizontal','Fontsize',9)
    %  columnlegend(2,labels,'location','southoutside')      
    % gridLegend(gca,2,labels,'Orientation','Horizontal','Fontsize',8)
else
    % Bar Chart Option 

    for i=1:length(IMpoints)-1
    if Sa_target>=IMpoints(1,i) && Sa_target<IMpoints(1,i+1)
        %indexSa1=i;
        X = [COLLAPSE_LOSSES_Per_IM(i,1) DEMOLITION_LOSSES_Per_IM(i,1) SC_REPAIR_COST_PerIM(i,1) NSC_SDR_REPAIR_COST_PerIM(i,1) NSC_ACC_REPAIR_COST_PerIM(i,1)];
        break
    end
    end
    bar(1,X(1,1)/NormVal,'barwidth',1,'facecolor','k');
    grid on; box on; hold on;
    bar(2,X(1,2)/NormVal,'barwidth',1,'facecolor','b');
    bar(3,X(1,3)/NormVal,'barwidth',1,'facecolor','r');
    bar(4,X(1,4)/NormVal,'barwidth',1,'facecolor','g');
    bar(5,X(1,5)/NormVal,'barwidth',1,'facecolor',[1 0.7 0]);
    ylabel (label,'fontsize',18);
    set(gca,'Ylim',[0.0 ceil(1.1*max(X)/NormVal)]);
    set(gca,'Xlim',[0 6]);
    set(gca,'XTick',[1 2 3 4 5])
    set(gca, 'fontname', 'Courier', 'fontsize',18);
    labels = {'Collapse','Demolition','SC','NSC-SDR','NSC-ACC'};
    set( gca(), 'XTickLabel', labels )
    rotateXLabels(gca(), 45)
end

title(gca,[num2str(round(sum(X/10^6)*100)/100),'M$ Total Loss at IM=', num2str(round(Sa_target*100)/100),'g'], 'fontname', 'Courier', 'fontsize',14);

end