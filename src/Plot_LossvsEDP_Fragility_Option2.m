function Plot_LossvsEDP_Fragility_Option2 (Units,StructuralSystem,Luxury_Level,Area_FootPrint,Area_Total)

load ('StoryLoss_Fragility_STEEL.mat')

if Units==1
    meter2feet=3.28084;
else
    meter2feet=1.0;
end

indxSystem=StructuralSystem;
indxLuxury=Luxury_Level;

if Area_FootPrint < 750*meter2feet^2
    indxFloorArea=1;
elseif 750*meter2feet^2 < Area_FootPrint && Area_FootPrint < 1500*meter2feet^2
    indxFloorArea=2;
elseif Area_FootPrint > 1500*meter2feet^2
    indxFloorArea=3;
end

if Area_Total < 2000*meter2feet^2
    indxTotalArea=1;
elseif 2000*meter2feet^2 < Area_Total && Area_Total < 5000*meter2feet^2
    indxTotalArea=2;
elseif Area_Total > 5000*meter2feet^2
    indxTotalArea=3;
end

SDR_Range=0:0.001:1.0;
MIDPTS.SDR=SDR_Range(1:end-1)+diff(SDR_Range)/2;

PFA_Range=0:0.01:5.0;
MIDPTS.PFA=PFA_Range(1:end-1)+diff(PFA_Range)/2;

% Structural Floor-Area-Dependant (FAD) Repair Costs: Typical Story
SC_EDPval_Typ_FAD     = cell2mat(costfun(indxSystem*indxFloorArea).costpar(:,1));
SC_COSTvals_Typ_FAD   = cell2mat(costfun(indxSystem*indxFloorArea).costpar(:,3));
SC_COSTmedian_Typ_FAD = SC_COSTvals_Typ_FAD(:,1);
SC_COSTmedian_Typ_FAD_PerEDPrange =pchip(SC_EDPval_Typ_FAD,SC_COSTmedian_Typ_FAD, MIDPTS.SDR);

% Structural Floor-Area-Dependant (FAD) Repair Costs: Ground Floor
SC_EDPval_Ground_FAD     = cell2mat(costfun(10).costpar(:,1));
SC_COSTvals_Ground_FAD   = cell2mat(costfun(10).costpar(:,3));
SC_COSTmedian_Ground_FAD = SC_COSTvals_Ground_FAD(:,1);
SC_COSTmedian_Ground_FAD_PerEDPrange =pchip(SC_EDPval_Ground_FAD,SC_COSTmedian_Ground_FAD, MIDPTS.SDR);

% Non-Structural SDR-Sensitive Floor-Area-Dependant (FAD) Repair Costs: Typical Story
NSC_SDR_EDPval_Typ_FAD     = cell2mat(costfun(11).costpar(:,1));
NSC_SDR_COSTvals_Typ_FAD   = cell2mat(costfun(11).costpar(:,3));
NSC_SDR_COSTmedian_Typ_FAD = NSC_SDR_COSTvals_Typ_FAD(:,1);
NSC_SDR_COSTmedian_Typ_FAD_PerEDPrange =pchip(NSC_SDR_EDPval_Typ_FAD,NSC_SDR_COSTmedian_Typ_FAD, MIDPTS.SDR);

% Non-Structural ACC-Sensitive Total-Area-Dependant (TAD) Repair Costs: Typical Story
NSC_ACC_EDPval_Ground_TAD     = cell2mat(costfun(11+indxTotalArea).costpar(:,1));
NSC_ACC_COSTvals_Ground_TAD   = cell2mat(costfun(11+indxTotalArea).costpar(:,3));
NSC_ACC_COSTmedian_Ground_TAD = NSC_ACC_COSTvals_Ground_TAD(:,1);
NSC_ACC_COSTmedian_Ground_TAD_PerEDPrange =pchip(NSC_ACC_EDPval_Ground_TAD,NSC_ACC_COSTmedian_Ground_TAD, MIDPTS.PFA);

% Non-Structural ACC-Sensitive Floor-Area-Dependant (FAD) Repair Costs: Typical Story
NSC_ACC_EDPval_Typ_FAD     = cell2mat(costfun(15).costpar(:,1));
NSC_ACC_COSTvals_Typ_FAD   = cell2mat(costfun(15).costpar(:,3));
NSC_ACC_COSTmedian_Typ_FAD = NSC_ACC_COSTvals_Typ_FAD(:,1);
NSC_ACC_COSTmedian_Typ_FAD_PerEDPrange =pchip(NSC_ACC_EDPval_Typ_FAD,NSC_ACC_COSTmedian_Typ_FAD, MIDPTS.PFA);

% Non-Structural ACC-Sensitive Floor-Area-Dependant (FAD) Repair Costs: Roof
NSC_ACC_EDPval_Roof_FAD     = cell2mat(costfun(16).costpar(:,1));
NSC_ACC_COSTvals_Roof_FAD   = cell2mat(costfun(16).costpar(:,3));
NSC_ACC_COSTmedian_Roof_FAD = NSC_ACC_COSTvals_Roof_FAD (:,1);
NSC_ACC_COSTmedian_Roof_FAD_PerEDPrange =pchip(NSC_ACC_EDPval_Roof_FAD,NSC_ACC_COSTmedian_Roof_FAD, MIDPTS.PFA);

% Non-Structural ACC-Sensitive Total-Area-Dependant (TAD) Repair Costs:Roof
% ONLY IF TOTAL AREA > 5000 m2
NSC_ACC_EDPval_Roof_TAD     = cell2mat(costfun(17).costpar(:,1));
NSC_ACC_COSTvals_Roof_TAD   = cell2mat(costfun(17).costpar(:,3));
NSC_ACC_COSTmedian_Roof_TAD = NSC_ACC_COSTvals_Roof_TAD(:,1);
NSC_ACC_COSTmedian_Roof_TAD_PerEDPrange =pchip(NSC_ACC_EDPval_Roof_TAD,NSC_ACC_COSTmedian_Roof_TAD, MIDPTS.PFA);

% Non-Structural ACC-Sensitive Floor-Area-Dependant (FAD) Contents Repair Costs: Typical Story
NSC_ACC_CONTENTS_EDPval_Typ_FAD     = cell2mat(costfun(17+indxLuxury).costpar(:,1));
NSC_ACC_CONTENTS_COSTvals_Typ_FAD   = cell2mat(costfun(17+indxLuxury).costpar(:,3));
NSC_ACC_CONTENTS_COSTmedian_Typ_FAD = NSC_ACC_CONTENTS_COSTvals_Typ_FAD(:,1);
NSC_ACC_CONTENTS_COSTmedian_Typ_FAD_PerEDPrange =pchip(NSC_ACC_CONTENTS_EDPval_Typ_FAD,NSC_ACC_CONTENTS_COSTmedian_Typ_FAD, MIDPTS.PFA);

figure('position',[500 300 750 350],'color','white');
subplot(1,2,1)
plot(MIDPTS.SDR,SC_COSTmedian_Typ_FAD_PerEDPrange/1000,'-k','linewidth',2);
set(gca, 'fontname', 'times', 'fontsize',17);
hold on; grid on; box on;
plot(MIDPTS.SDR,SC_COSTmedian_Ground_FAD_PerEDPrange/1000,'--k','linewidth',2);
plot(MIDPTS.SDR,NSC_SDR_COSTmedian_Typ_FAD_PerEDPrange/1000,'-b','linewidth',2);
set(gca,'Xlim',[0 0.2]);
set(gca,'Ylim',[0 max(SC_COSTmedian_Typ_FAD_PerEDPrange/1000)]);
xlabel ('SDR [rad]', 'fontname', 'times', 'fontsize',17);
ylabel ('Loss [10^3 $]', 'fontname', 'times', 'fontsize',17);
h=legend('SC-Typ.','SC-Ground','NSC-SDR-Typ.');
set(h,'fontsize',10,'location','southeast');
t=title('Loss values are per 100 m^2');
set(t,'fontsize',12);
subplot(1,2,2);
set(gca, 'fontname', 'times', 'fontsize',17);
hold on; grid on; box on;
plot(MIDPTS.PFA,NSC_ACC_COSTmedian_Typ_FAD_PerEDPrange/1000,'-r','linewidth',2)
plot(MIDPTS.PFA,NSC_ACC_COSTmedian_Ground_TAD_PerEDPrange/1000,'--r','linewidth',2)
plot(MIDPTS.PFA,NSC_ACC_COSTmedian_Roof_FAD_PerEDPrange/1000,':r','linewidth',2)
plot(MIDPTS.PFA,NSC_ACC_COSTmedian_Roof_TAD_PerEDPrange/1000,'-.r','linewidth',2)
plot(MIDPTS.PFA,NSC_ACC_CONTENTS_COSTmedian_Typ_FAD_PerEDPrange/1000,'-g','linewidth',2)
set(gca,'Xlim',[0 5])
set(gca,'Ylim',[0 max(NSC_ACC_COSTmedian_Typ_FAD_PerEDPrange/1000)])
xlabel ('PFA [g]', 'fontname', 'times', 'fontsize',17);
ylabel ('Loss [10^3 $]', 'fontname', 'times', 'fontsize',17);
h=legend('NSC-FAD-Typ.','NSC-TAD-Ground','NSC-FAD-Roof','NSC-TAD-Roof','NSC-Contents-Typ.');
set(h,'fontsize',10,'location','southeast');
t=title('Loss values are per 100 m^2');
set(t,'fontsize',12);