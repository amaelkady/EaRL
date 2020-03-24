function Plot_Population_Model(OccupancyName,PopModel,Units)

if Units==1; unitlabel='sq. feet'; else  unitlabel='sq. meter'; end

figure('position',[500 300 850 300],'color','white');

subplot(1,2,1)
sgtitle (['Occupancy: ',OccupancyName,' -> Peak population: ',num2str(PopModel.PeakPopP),' people per ', num2str(PopModel.PeakPopArea),' ', unitlabel])
hold on; grid on; box on;
plot(PopModel.PopVarPerHourDay(:,1)*100,'-k','linewidth',2)
plot(PopModel.PopVarPerHourDay(:,2)*100,'-r','linewidth',2)
set(gca,'XLim',[1 24])
set(gca,'YLim',[0 110])
legend1=legend('Weekday','Weekend');
set(legend1,'location','southwest');
ylabel ('Variation');
xticks(1:24);
yticks(0:20:100);
xticklabels({'Midnight','','','','','','06:00 am','','','','','','Noon','','','','','','06:00 pm','','','','','11:00 pm'});
rotateXLabels( gca(), 90)
set(gca, 'fontname', 'times', 'fontsize',14);

subplot(1,2,2)
hold on; grid on; box on;
plot(PopModel.PopVarPerMonth(:,1)*100,'-k','linewidth',2)
plot(PopModel.PopVarPerMonth(:,2)*100,'-r','linewidth',2)
set(gca,'XLim',[1 12])
set(gca,'YLim',[0 110])
legend1=legend('Weekday','Weekend');
set(legend1,'location','southwest');
ylabel ('Variation');
xticks(1:12);
yticks(0:20:100);
xticklabels({'Jan','Feb','Mar','Apr','May','June','July','Aug','Sep','Oct','Nov','Dec'});
rotateXLabels( gca(), 90)
set(gca, 'fontname', 'times', 'fontsize',16);

end