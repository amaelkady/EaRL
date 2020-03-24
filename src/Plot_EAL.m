function []=Plot_EAL(EAL,UnitOption,Replacement_Cost)

if UnitOption==1
    NormVal=10^6;
    label='EAL [M$]';
else
    NormVal=Replacement_Cost/100;    
    label='EAL [% \itCost\rm]';
end

figure('Color','w','Position', [500 300 450 350]);
bar(1,EAL(1,1)/NormVal,'barwidth',1,'facecolor',[0.2 0.2 0.2]);
grid on; box on; hold on;
bar(2,EAL(1,2)/NormVal,'barwidth',1,'facecolor','b');
bar(3,EAL(1,3)/NormVal,'barwidth',1,'facecolor','r');
bar(4,EAL(1,4)/NormVal,'barwidth',1,'facecolor','g');
bar(5,EAL(1,5)/NormVal,'barwidth',1,'facecolor',[1 0.7 0]);
set(gca, 'fontname', 'Courier', 'fontsize',15);
ylabel (label,'fontsize',15);
set(gca,'Xlim',[0 6]);
set(gca,'XTick',[1 2 3 4 5])
labels = {'Collapse','Demolition','SC','NSC-SDR','NSC-ACC'};
set(gca,'XTickLabel',labels);
rotateXLabels( gca(), 45) 

end