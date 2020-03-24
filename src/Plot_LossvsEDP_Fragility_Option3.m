function Plot_LossvsEDP_Fragility_Option3 (Units,N_Story,Replacement_Cost,FrameType,DuctilityType)

if Units==1
    meter2feet=3.28084;
else
    meter2feet=1.0;
end

if DuctilityType==1
    indxDuctility=1;
elseif DuctilityType==2
    indxDuctility=2;
end

if FrameType==1
    indxFrame=1;
elseif FrameType==2
    indxFrame=2;
end

if N_Story < 5
    indxRise=1;
elseif 5 < N_Story && N_Story < 10
    indxRise=2;
elseif N_Story > 10
    indxRise=3;
end

load ('StoryLoss_Fragility_RC.mat')

SDR_Range=0:0.001:0.2;
MIDPTS.SDR=SDR_Range(1:end-1)+diff(SDR_Range)/2;

PFA_Range=0:0.01:10.0;
MIDPTS.PFA=PFA_Range(1:end-1)+diff(PFA_Range)/2;

% Structural Repair Costs: 1st Story
SC_EDPval_Ground     = cell2mat(costfun(indxDuctility*indxFrame*indxRise).costpar(:,1));
SC_COSTvals_Ground   = cell2mat(costfun(indxDuctility*indxFrame*indxRise).costpar(:,3));
SC_COSTmedian_Ground = SC_COSTvals_Ground(:,1) * Replacement_Cost/N_Story;
SC_COSTmedian_Ground_PerEDPrange = pchip(SC_EDPval_Ground,SC_COSTmedian_Ground, MIDPTS.SDR);

% Non-Structural SDR-Sensitive Repair Costs: 1st Story
NSC_SDR_EDPval_Ground     = cell2mat(costfun(indxDuctility*indxFrame*indxRise+1).costpar(:,1));
NSC_SDR_COSTvals_Ground   = cell2mat(costfun(indxDuctility*indxFrame*indxRise+1).costpar(:,3));
NSC_SDR_COSTmedian_Ground = NSC_SDR_COSTvals_Ground(:,1) * Replacement_Cost/N_Story;
NSC_SDR_COSTmedian_Ground_PerEDPrange =pchip(NSC_SDR_EDPval_Ground,NSC_SDR_COSTmedian_Ground, MIDPTS.SDR);

% Non-Structural ACC-Sensitive Repair Costs: 1st Story
NSC_ACC_EDPval_Ground     = cell2mat(costfun(indxDuctility*indxFrame*indxRise+2).costpar(:,1));
NSC_ACC_COSTvals_Ground   = cell2mat(costfun(indxDuctility*indxFrame*indxRise+2).costpar(:,3));
NSC_ACC_COSTmedian_Ground = NSC_ACC_COSTvals_Ground(:,1) * Replacement_Cost/N_Story;
NSC_ACC_COSTmedian_Ground_PerEDPrange =pchip(NSC_ACC_EDPval_Ground,NSC_ACC_COSTmedian_Ground, MIDPTS.PFA);

% Structural Repair Costs: Typical Story
SC_EDPval_Typ     = cell2mat(costfun(indxDuctility*indxFrame*indxRise+3).costpar(:,1));
SC_COSTvals_Typ   = cell2mat(costfun(indxDuctility*indxFrame*indxRise+3).costpar(:,3));
SC_COSTmedian_Typ = SC_COSTvals_Typ(:,1) * Replacement_Cost/N_Story;
SC_COSTmedian_Typ_PerEDPrange = pchip(SC_EDPval_Typ,SC_COSTmedian_Typ, MIDPTS.SDR);

% Non-Structural SDR-Sensitive Repair Costs: Typical Story
NSC_SDR_EDPval_Typ     = cell2mat(costfun(indxDuctility*indxFrame*indxRise+4).costpar(:,1));
NSC_SDR_COSTvals_Typ   = cell2mat(costfun(indxDuctility*indxFrame*indxRise+4).costpar(:,3));
NSC_SDR_COSTmedian_Typ = NSC_SDR_COSTvals_Typ(:,1) * Replacement_Cost/N_Story;
NSC_SDR_COSTmedian_Typ_PerEDPrange =pchip(NSC_SDR_EDPval_Typ,NSC_SDR_COSTmedian_Typ, MIDPTS.SDR);

% Non-Structural SDR-Sensitive Repair Costs: Typical Story
NSC_ACC_EDPval_Typ     = cell2mat(costfun(indxDuctility*indxFrame*indxRise+5).costpar(:,1));
NSC_ACC_COSTvals_Typ   = cell2mat(costfun(indxDuctility*indxFrame*indxRise+5).costpar(:,3));
NSC_ACC_COSTmedian_Typ = NSC_ACC_COSTvals_Typ(:,1) * Replacement_Cost/N_Story;
NSC_ACC_COSTmedian_Typ_PerEDPrange =pchip(NSC_ACC_EDPval_Typ,NSC_ACC_COSTmedian_Typ, MIDPTS.PFA);

% Structural Repair Costs: Roof
SC_EDPval_Roof   = cell2mat(costfun(indxDuctility*indxFrame*indxRise+6).costpar(:,1));
SC_COSTvals_Roof  = cell2mat(costfun(indxDuctility*indxFrame*indxRise+6).costpar(:,3));
SC_COSTmedian_Roof  = SC_COSTvals_Roof(:,1) * Replacement_Cost/N_Story;
SC_COSTmedian_Roof_PerEDPrange = pchip(SC_EDPval_Roof,SC_COSTmedian_Roof, MIDPTS.SDR);

% Non-Structural SDR-Sensitive Repair Costs: Roof
NSC_SDR_EDPval_Roof   = cell2mat(costfun(indxDuctility*indxFrame*indxRise+7).costpar(:,1));
NSC_SDR_COSTvals_Roof  = cell2mat(costfun(indxDuctility*indxFrame*indxRise+7).costpar(:,3));
NSC_SDR_COSTmedian_Roof  = NSC_SDR_COSTvals_Roof(:,1) * Replacement_Cost/N_Story;
NSC_SDR_COSTmedian_Roof_PerEDPrange =pchip(NSC_SDR_EDPval_Roof,NSC_SDR_COSTmedian_Roof, MIDPTS.SDR);

% Non-Structural SDR-Sensitive Repair Costs: Roof
NSC_ACC_EDPval_Roof   = cell2mat(costfun(indxDuctility*indxFrame*indxRise+8).costpar(:,1));
NSC_ACC_COSTvals_Roof  = cell2mat(costfun(indxDuctility*indxFrame*indxRise+8).costpar(:,3));
NSC_ACC_COSTmedian_Roof  = NSC_ACC_COSTvals_Roof(:,1) * Replacement_Cost/N_Story;
NSC_ACC_COSTmedian_Roof_PerEDPrange =pchip(NSC_ACC_EDPval_Roof,NSC_ACC_COSTmedian_Roof, MIDPTS.PFA);

figure('position',[500 300 950 350],'color','white');
subplot(1,3,1)
set(gca, 'fontname', 'times', 'fontsize',17);
hold on; grid on; box on;
plot(MIDPTS.SDR,SC_COSTmedian_Typ_PerEDPrange/1000,'-k','linewidth',2);
plot(MIDPTS.SDR,SC_COSTmedian_Ground_PerEDPrange/1000,'--k','linewidth',2);
plot(MIDPTS.SDR,SC_COSTmedian_Roof_PerEDPrange/1000,':k','linewidth',2);
set(gca,'Xlim',[0 0.2]);
set(gca,'Ylim',[0 max([max(SC_COSTmedian_Typ_PerEDPrange);max(SC_COSTmedian_Ground_PerEDPrange);max(SC_COSTmedian_Roof_PerEDPrange)])/1000]);
xlabel ('SDR [rad]', 'fontname', 'times', 'fontsize',17);
ylabel ('Loss [10^3 $]', 'fontname', 'times', 'fontsize',17);
h=legend('SC-Typ.','SC-Ground','SC-Roof');
set(h,'fontsize',10,'location','southeast');
t=title('Loss values are per story/floor');
set(t,'fontsize',12);
subplot(1,3,2);
set(gca, 'fontname', 'times', 'fontsize',17);
hold on; grid on; box on;
plot(MIDPTS.SDR,NSC_SDR_COSTmedian_Typ_PerEDPrange/1000,'-b','linewidth',2)
plot(MIDPTS.SDR,NSC_SDR_COSTmedian_Ground_PerEDPrange/1000,'--b','linewidth',2)
plot(MIDPTS.SDR,NSC_SDR_COSTmedian_Roof_PerEDPrange/1000,':b','linewidth',2)
set(gca,'Xlim',[0 0.2]);
set(gca,'Ylim',[0 max([max(NSC_SDR_COSTmedian_Typ_PerEDPrange);max(NSC_SDR_COSTmedian_Ground_PerEDPrange);max(NSC_SDR_COSTmedian_Roof_PerEDPrange)])/1000]);
xlabel ('SDR [rad]', 'fontname', 'times', 'fontsize',17);
ylabel ('Loss [10^3 $]', 'fontname', 'times', 'fontsize',17);
h=legend('NSC-Typ.','NSC-Ground','NSC-Roof');
set(h,'fontsize',10,'location','southeast');
t=title('Loss values are per story/floor');
set(t,'fontsize',12);
subplot(1,3,3);
set(gca, 'fontname', 'times', 'fontsize',17);
hold on; grid on; box on;
plot(MIDPTS.PFA,NSC_ACC_COSTmedian_Typ_PerEDPrange/1000,'-r','linewidth',2)
plot(MIDPTS.PFA,NSC_ACC_COSTmedian_Ground_PerEDPrange/1000,'--r','linewidth',2)
plot(MIDPTS.PFA,NSC_ACC_COSTmedian_Roof_PerEDPrange/1000,':r','linewidth',2)
set(gca,'Xlim',[0 10])
set(gca,'Ylim',[0 max([max(NSC_ACC_COSTmedian_Typ_PerEDPrange);max(NSC_ACC_COSTmedian_Ground_PerEDPrange);max(NSC_ACC_COSTmedian_Roof_PerEDPrange)])/1000]);
xlabel ('PFA [g]', 'fontname', 'times', 'fontsize',17);
ylabel ('Loss [10^3 $]', 'fontname', 'times', 'fontsize',17);
h=legend('NSC-Typ.','NSC-Ground','NSC-Roof');
set(h,'fontsize',10,'location','southeast');
t=title('Loss values are per story/floor');
set(t,'fontsize',12);