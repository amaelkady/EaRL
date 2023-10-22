
function Plot_Collapse_Fragility(app)

if app.radio2.Value==1
    CollapseSDR=app.edit1.Value;
    [EmpDist, MedianCPS, CollapseSigmaSA]=Get_Collapse_Fragility_IDA(CollapseSDR);
    CollapseMedianSA=exp(MedianCPS);
    RangeX1=0.001:0.01:max(EmpDist(:,1))+0.5;
    PCollapse = logncdf(RangeX1,log(CollapseMedianSA),CollapseSigmaSA);
    
    figure('position',[500 300 350 300],'color','white');
    scatter(EmpDist(:,1),EmpDist(:,2),'ok','MarkerFaceColor','r');
    box on; grid on; hold on;
    set(gca, 'fontname', 'times', 'fontsize',15);
    plot(RangeX1,PCollapse,'-k','linewidth',2);
    text(CollapseMedianSA*1.1,0.5,['\mu_{IM}=',num2str(round(CollapseMedianSA*1000)/1000),' g'], 'fontname', 'times', 'fontsize',13);
    text(CollapseMedianSA*1.1,0.4,['\sigma_{ln(IM)}=',num2str(round(CollapseSigmaSA*100)/100)], 'fontname', 'times', 'fontsize',13);
    xlabel ('IM [g]');
    ylabel ('P(Collapse)');
    set(gca,'XLim',[0.0 max(EmpDist(:,1))+0.5])
    set(gca,'YLim',[0 1])
    h=legend('Empirical dist.','Fitted logn. CDF','Location','SouthEast');
    set(h, 'fontsize',13);
end

if app.radio3.Value==1
    CollapseMedianSA = app.edit2.Value;
    CollapseSigmaSA  = app.edit3.Value;
    RangeX1=0.001:0.05:CollapseMedianSA*2.5;
    PCollapse = logncdf(RangeX1,log(CollapseMedianSA),CollapseSigmaSA);
    
    figure('position',[500 300 350 300],'color','white');
    plot(RangeX1,PCollapse,'-k','linewidth',2);
    box on; grid on; hold on;
    scatter(CollapseMedianSA,0.5,'ok','MarkerFaceColor','r');
    text(CollapseMedianSA*1.15,0.5,['\mu_{IM}=',num2str(round(CollapseMedianSA*1000)/1000),' g'], 'fontname', 'times', 'fontsize',13);
    text(CollapseMedianSA*1.15,0.4,['\sigma_{ln(IM)}=',num2str(round(CollapseSigmaSA*100)/100)], 'fontname', 'times', 'fontsize',13);
    xlabel ('IM [g]');
    ylabel ('P(Collapse)');
    set(gca,'XLim',[0.0 max(RangeX1)])
    set(gca,'YLim',[0 1])
    set(gca, 'fontname', 'times', 'fontsize',16);
end

if app.radio4.Value==1
    
    Pcollapse    = app.edit4.Value/100;
    PcollapseSa  = app.edit5.Value;
    CollapseSigmaSA     = app.edit6.Value;
    % Get the median Sa at collaspe that satisifies the entered data
    count=1;
    for Sa=0.01:0.01:5
        Probability = logncdf(PcollapseSa,log(Sa),CollapseSigmaSA);
        SA(count,1)=Sa;
        Diff(count,1)=abs(Probability-Pcollapse);
        count=count+1;
    end
    [MinErr, indexMin]=min(Diff);
    CollapseMedianSA=SA(indexMin,1);
    RangeX1=0.001:0.01:CollapseMedianSA*2.5;
    PCollapse = logncdf(RangeX1,log(CollapseMedianSA),CollapseSigmaSA);
    
    figure('position',[500 300 350 300],'color','white');
    plot(RangeX1,PCollapse,'-k','linewidth',2);
    box on; grid on; hold on;
    scatter(CollapseMedianSA,0.5,'ok','MarkerFaceColor','r');
    plot([PcollapseSa PcollapseSa],[0 Pcollapse],'--k');
    plot([0 PcollapseSa],[Pcollapse Pcollapse],'--k');
    scatter(PcollapseSa,Pcollapse,'ok','MarkerFaceColor','g');
    text(CollapseMedianSA*1.15,0.5,['\mu_{IM}=',num2str(round(CollapseMedianSA*1000)/1000),' g'], 'fontname', 'times', 'fontsize',13);
    text(CollapseMedianSA*1.15,0.4,['\sigma_{ln(IM)}=',num2str(round(CollapseSigmaSA*100)/100)], 'fontname', 'times', 'fontsize',13);
    xlabel ('IM [g]');
    ylabel ('P(Collapse)');
    set(gca,'XLim',[0.0 max(RangeX1)])
    set(gca,'YLim',[0 1])
    set(gca, 'fontname', 'times', 'fontsize',16);
end

end