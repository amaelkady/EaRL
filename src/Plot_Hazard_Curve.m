function Plot_Hazard_Curve(HazardCurveData,HazardOption)

IM=HazardCurveData(:,1);
MAF=HazardCurveData(:,2);
COEFF=polyfit(log(IM),log(MAF),4);

% PLOT
figure('position',[500 300 450 350],'color','white');
scatter (IM,MAF, 'ko','MarkerEdgeColor','r','MarkerFaceColor','r','SizeData',10);
grid on; box on; hold on;
clear MAF;
counter=1;
for im=0.001:0.001:3.0
    IM(counter,1)=im;
    MAF(counter,1)=COEFF(1)*log(im)^4+COEFF(2)*log(im)^3+COEFF(3)*log(im)^2+COEFF(4)*log(im)^1+COEFF(5);
    counter=counter+1;
end
plot(IM,exp(MAF),'-k','linewidth',2)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
set(gca, 'fontname', 'Courier', 'fontsize',14);
xlabel ('IM [g]', 'fontname', 'Courier', 'fontsize',14);
ylabel ('MAFE, \it\lambda', 'fontname', 'Courier', 'fontsize',14);
set(gca,'Xlim',[0.01 3.0]);
if HazardOption==1
    h=legend('Extracted USGS data','Fitted 4th-degree poly.');
    set(h,'location','SouthWest','fontsize',10);
else
    h=legend('Imported data','Fitted 4th-degree poly.');
    set(h,'location','SouthWest','fontsize',10);
end

end