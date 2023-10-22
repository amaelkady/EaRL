function Plot_Univariate_LognCDF (MedianX, SigmaX)

    RangeX=0.001:0.001:MedianX*2.5;
    PDemolition = logncdf(RangeX,log(MedianX),SigmaX);
    figure('position',[500 300 450 350],'color','white');
    plot(RangeX,PDemolition,'-k','linewidth',2);
    box on; grid on; hold on;
    scatter(MedianX,0.5,'ok','MarkerFaceColor','r')
    xlabel ('RDR [rad]');
    ylabel ('P(Demolition)');
    set(gca,'XLim',[0.0 max(RangeX)])
    set(gca,'YLim',[0 1])
    set(gca, 'fontname', 'times', 'fontsize',16);
    text(MedianX*1.1,0.5,['\mu_{\itRDR}\rm=',num2str(MedianX),' rad'],'fontname','times','fontsize',15)
    text(MedianX*1.1,0.4,['\sigma_{\rmln\itRDR}\rm=',num2str(SigmaX)],'fontname','times','fontsize',15)

end
