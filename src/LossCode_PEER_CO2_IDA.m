function LossCode_PEER_CO2_IDA(app)
global ProjectPath ProjectName
load (strcat(ProjectPath,ProjectName))

clear COLLAPSE_LOSSES_Per_IM DEMOLITION_LOSSES_Per_IM DEAGG_COMPONENT_REPAIR_COST STORY_REPAIR_COST STORY_REPAIR_COST_SC STORY_REPAIR_COST_NSC_SDR STORY_REPAIR_COST_NSC_ACC SC_REPAIR_COST_PerIM NSC_SDR_REPAIR_COST_PerIM NSC_ACC_REPAIR_COST_PerIM REPAIR_COST_TOTAL_PerIM TOTAL_LOSSES_PerIM TOTAL_REPAIR_TIME_PerIM EAL

app.ProgressText.Value='INITIALIZING CODE';
app.ProgressText.FontColor='y';
app.ProgressBar.Position=[9 5 613 6];
app.ProgressBar.BackgroundColor='w';
pause(0.5);

%%
                         MIDPTS.SDR=RANGE.SDR(1:end-1)+diff(RANGE.SDR)/2;
                         MIDPTS.PFA=RANGE.PFA(1:end-1)+diff(RANGE.PFA)/2;
if Data_Status.RDR==1;   MIDPTS.RDR=RANGE.RDR(1:end-1)+diff(RANGE.RDR)/2; end
if Data_Status.VRD==1;   MIDPTS.VRD=RANGE.VRD(1:end-1)+diff(RANGE.VRD)/2; end

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%---------------------------------------------------------  PRE-CALCULATIONS AND FITTINGS  ----------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%

%% Get the Median and Sigma values of the EDPs wrt IM values

app.ProgressBar.BackgroundColor='g';
app.ProgressBar.Position=[9 5 613 6];

                       [MEDIAN_IM.SDR,SIGMA_IM.SDR]=Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'SDR',IDAFilename.SDR,N_Story);
                       [MEDIAN_IM.PFA,SIGMA_IM.PFA]=Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'PFA',IDAFilename.PFA,N_Story+1);
if Data_Status.RDR==1; [MEDIAN_IM.RDR,SIGMA_IM.RDR]=Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'RDR',IDAFilename.RDR,1); end
if Data_Status.VRD==1; [MEDIAN_IM.VRD,SIGMA_IM.VRD]=Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'VRD',IDAFilename.VRD,1); end

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%-----------------------------------------------------  REPLACEMENT COST DUE TO COLLAPSE  -----------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%

[COLLAPSE_LOSSES_Per_IM,Pr_Collapse_per_IM]=Get_Collapse_Loss_Per_IM(app,IMpoints,MedianCPS,SigmaCPS,Replacement_Cost);

save(strcat(ProjectPath,ProjectName),'COLLAPSE_LOSSES_Per_IM','-append');

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%-------------------------------------------------  DEMOLITION COST DUE TO RESIDUAL DRIFT  ----------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%

[DEMOLITION_LOSSES_Per_IM,Pr_Demolition_per_IM]=Get_Demolition_Loss_Per_IM_IDA(app,Demolition_Option,IMpoints,MEDIAN_IM,SIGMA_IM,RANGE,MIDPTS,DemolishMedianRDR,DemolishSigmaRDR,DemolishMedianVRD,DemolishSigmaVRD,DemolishCorr,Demolition_Cost,Replacement_Cost,Pr_Collapse_per_IM,TargetIM);

save(strcat(ProjectPath,ProjectName),'COLLAPSE_LOSSES_Per_IM','DEMOLITION_LOSSES_Per_IM','-append');
pause(0.5);

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%---------------------------------------------  REPAIR COST FOR STRUCTURAL/NONSTRUCTURAL COMPONENTS -------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%

app.ProgressText.Value='CALCULATING REPAIR LOSS'; drawnow;

load ('StoryLoss_Fragility_STEEL.mat')

if Units==1; meter2feet=3.28084; end
if Units==2; meter2feet=1.0;     end

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

STORY_REPAIR_COST_SC        = zeros(nIMpoints,N_Story+1);
STORY_REPAIR_COST_NSC_SDR   = zeros(nIMpoints,N_Story+1);
STORY_REPAIR_COST_NSC_ACC   = zeros(nIMpoints,N_Story+1);
STORY_REPAIR_COST           = zeros(nIMpoints,N_Story+1);
SC_REPAIR_COST_PerIM        = zeros(nIMpoints,1); 
NSC_SDR_REPAIR_COST_PerIM   = zeros(nIMpoints,1); 
NSC_ACC_REPAIR_COST_PerIM   = zeros(nIMpoints,1); 
REPAIR_COST_TOTAL_PerIM     = zeros(nIMpoints,1); 

counter=1;
for im=1:nIMpoints % Loop over IM levels
    if IMpoints(1,im)>= min(TargetIM) && IMpoints(1,im)<= max(TargetIM)
    for n=1:N_Story+1 % Loop over Stories/floors 

        if n==N_Story+1
            PEDP_SDR=logncdf(RANGE.SDR,log(0.00001),0.01);
            DPEDP_SDR=abs(diff(PEDP_SDR));
        else
            PEDP_SDR=logncdf(RANGE.SDR,log(MEDIAN_IM.SDR(im,n)),SIGMA_IM.SDR(im,n));
            DPEDP_SDR=abs(diff(PEDP_SDR));                
        end

        PEDP_PFA=logncdf(RANGE.PFA,log(MEDIAN_IM.PFA(im,n)),SIGMA_IM.PFA(im,n));
        DPEDP_PFA=abs(diff(PEDP_PFA));

        PEDP_PGA=logncdf(RANGE.PFA,log(MEDIAN_IM.PFA(im,1)),SIGMA_IM.PFA(im,1));
        DPEDP_PGA=abs(diff(PEDP_PGA));

        if n==1
            SC_Typ_Flag         = 1;
            SC_Ground_Flag      = 1;
            NSC_ACC_Ground_Flag = 1;
            NSC_ACC_Typ_Flag    = 0;
            Roof_Flag           = 0;  
            NSC_SDR_Typ_Flag    = 1; 
            CONTENTS_Typ_Flag   = 1; 
            SC_Flag             = 1;
        elseif n==N_Story+1
            SC_Ground_Flag      = 0;
            NSC_ACC_Ground_Flag = 0;
            NSC_ACC_Typ_Flag    = 0;
            Roof_Flag           = 1;                 
            NSC_SDR_Typ_Flag    = 1; 
            SC_Typ_Flag         = 1;
            CONTENTS_Typ_Flag   = 1;
            SC_Flag             = 0;
        else
            SC_Ground_Flag      = 0;     
            SC_Typ_Flag         = 1;
            NSC_SDR_Typ_Flag    = 1; 
            NSC_ACC_Ground_Flag = 0;
            NSC_ACC_Typ_Flag    = 1;
            Roof_Flag           = 0;       
            CONTENTS_Typ_Flag   = 1; 
            SC_Flag             = 1;
        end

        if Area_Total > 5000*meter2feet^2
            Area5000_Flag=1;
        else
            Area5000_Flag=0;
        end

        % Repair Cost $ per Story
        PDM_SC1      =      SC_COSTmedian_Typ_FAD_PerEDPrange          * Area_FootPrint/100/meter2feet^2 * SC_Typ_Flag * SC_Flag; 
        PDM_SC2      =      SC_COSTmedian_Ground_FAD_PerEDPrange       * Area_FootPrint/100/meter2feet^2 * SC_Ground_Flag * SC_Flag; 
        PDM_NSC_SDR1 = NSC_SDR_COSTmedian_Typ_FAD_PerEDPrange          * Area_FootPrint/100/meter2feet^2 * NSC_SDR_Typ_Flag;
        PDM_NSC_ACC1 = NSC_ACC_COSTmedian_Ground_TAD_PerEDPrange       * Area_Total/100/meter2feet^2     * NSC_ACC_Ground_Flag;
        PDM_NSC_ACC2 = NSC_ACC_COSTmedian_Typ_FAD_PerEDPrange          * Area_FootPrint/100/meter2feet^2 * NSC_ACC_Typ_Flag;
        PDM_NSC_ACC3 = NSC_ACC_COSTmedian_Roof_FAD_PerEDPrange         * Area_FootPrint/100/meter2feet^2 * Roof_Flag;
        PDM_NSC_ACC4 = NSC_ACC_COSTmedian_Roof_TAD_PerEDPrange         * Area_Total/100/meter2feet^2     * Roof_Flag * Area5000_Flag;
        PDM_NSC_ACC5 = NSC_ACC_CONTENTS_COSTmedian_Typ_FAD_PerEDPrange * Area_FootPrint/100/meter2feet^2 * CONTENTS_Typ_Flag;

        PRNC_SC1      = PDM_SC1      * DPEDP_SDR' * (1-Pr_Demolition_per_IM(im,1)) * (1-Pr_Collapse_per_IM(im,1));
        PRNC_SC2      = PDM_SC2      * DPEDP_SDR' * (1-Pr_Demolition_per_IM(im,1)) * (1-Pr_Collapse_per_IM(im,1));
        PRNC_NSC_SDR1 = PDM_NSC_SDR1 * DPEDP_SDR' * (1-Pr_Demolition_per_IM(im,1)) * (1-Pr_Collapse_per_IM(im,1));
        PRNC_NSC_ACC1 = PDM_NSC_ACC1 * DPEDP_PGA' * (1-Pr_Demolition_per_IM(im,1)) * (1-Pr_Collapse_per_IM(im,1));
        PRNC_NSC_ACC2 = PDM_NSC_ACC2 * DPEDP_PFA' * (1-Pr_Demolition_per_IM(im,1)) * (1-Pr_Collapse_per_IM(im,1));
        PRNC_NSC_ACC3 = PDM_NSC_ACC3 * DPEDP_PFA' * (1-Pr_Demolition_per_IM(im,1)) * (1-Pr_Collapse_per_IM(im,1));
        PRNC_NSC_ACC4 = PDM_NSC_ACC4 * DPEDP_PFA' * (1-Pr_Demolition_per_IM(im,1)) * (1-Pr_Collapse_per_IM(im,1));
        PRNC_NSC_ACC5 = PDM_NSC_ACC5 * DPEDP_PFA' * (1-Pr_Demolition_per_IM(im,1)) * (1-Pr_Collapse_per_IM(im,1));

        STORY_REPAIR_COST_SC(im,n)      = PRNC_SC1 + PRNC_SC2;
        STORY_REPAIR_COST_NSC_SDR(im,n) = PRNC_NSC_SDR1;
        STORY_REPAIR_COST_NSC_ACC(im,n) = PRNC_NSC_ACC1 + PRNC_NSC_ACC2 + PRNC_NSC_ACC3 + PRNC_NSC_ACC4 + PRNC_NSC_ACC5;            
        STORY_REPAIR_COST(im,n) = STORY_REPAIR_COST_SC(im,n) + STORY_REPAIR_COST_NSC_SDR(im,n) + STORY_REPAIR_COST_NSC_ACC(im,n);            

        DEAGG_DATA(im,1)=im;            
        DEAGG_DATA(im,2)=n;
        DEAGG_DATA(im,3)=0;
        DEAGG_DATA(im,4)=sum(STORY_REPAIR_COST_SC(im,:));
        DEAGG_DATA(im,5)=sum(STORY_REPAIR_COST_NSC_SDR(im,:));
        DEAGG_DATA(im,6)=sum(STORY_REPAIR_COST_NSC_ACC(im,:));

        clear PEDP_SDR PEDP_ACC PEDP_PGA DPEDP_SDR DPEDP_ACC DPEDP_PGA;  	% Clear these variables before going to the next story
        
    end
    end
    app.ProgressText.Value=['CALCULATING REPAIR LOSS ',num2str(round(im*100/nIMpoints)),'%'];
    app.ProgressBar.Position=[9 5 im/nIMpoints*613 6];
    drawnow
end

SC_REPAIR_COST_PerIM(:,1)      = sum(STORY_REPAIR_COST_SC,2) ;
NSC_SDR_REPAIR_COST_PerIM(:,1) = sum(STORY_REPAIR_COST_NSC_SDR,2);
NSC_ACC_REPAIR_COST_PerIM(:,1) = sum(STORY_REPAIR_COST_NSC_ACC,2);
REPAIR_COST_TOTAL_PerIM(:,1)   = SC_REPAIR_COST_PerIM(:,1) + NSC_SDR_REPAIR_COST_PerIM(:,1) + NSC_ACC_REPAIR_COST_PerIM(:,1);
TOTAL_LOSSES_PerIM = COLLAPSE_LOSSES_Per_IM + DEMOLITION_LOSSES_Per_IM + REPAIR_COST_TOTAL_PerIM;

save(strcat(ProjectPath,ProjectName),'DEAGG_DATA','-append');
save(strcat(ProjectPath,ProjectName),'STORY_REPAIR_COST','STORY_REPAIR_COST_SC','STORY_REPAIR_COST_NSC_SDR','STORY_REPAIR_COST_NSC_ACC','-append');
save(strcat(ProjectPath,ProjectName),'SC_REPAIR_COST_PerIM','NSC_SDR_REPAIR_COST_PerIM','NSC_ACC_REPAIR_COST_PerIM','REPAIR_COST_TOTAL_PerIM','TOTAL_LOSSES_PerIM','-append');
pause(0.5);

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%------------------------------------------------------------  EXPECTED ANNUAL LOSSES ---------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%

if HazardDataStatus==1 && TargetIM_Option==1
    
    app.ProgressText.Value='CALCULATING EXPECTED ANNUAL LOSSES';
    pause(1);

    dMAF=abs(diff(MAF));

    EAL_COLLAPSE        = COLLAPSE_LOSSES_Per_IM'     * dMAF;
    EAL_DEMOLITION      = DEMOLITION_LOSSES_Per_IM'   * dMAF;
    EAL_REPAIR          = REPAIR_COST_TOTAL_PerIM'   * dMAF;
    EAL_REPAIR_SC       = SC_REPAIR_COST_PerIM'      * dMAF;
    EAL_REPAIR_NSC_SDR  = NSC_SDR_REPAIR_COST_PerIM' * dMAF;
    EAL_REPAIR_NSC_ACC  = NSC_ACC_REPAIR_COST_PerIM' * dMAF;

    EAL_TOTAL      = EAL_COLLAPSE+  EAL_DEMOLITION + EAL_REPAIR;

    EAL(1,1)=EAL_COLLAPSE;
    EAL(1,2)=EAL_DEMOLITION;
    EAL(1,3)=EAL_REPAIR_SC;
    EAL(1,4)=EAL_REPAIR_NSC_SDR;
    EAL(1,5)=EAL_REPAIR_NSC_ACC;
    EAL(1,6)=EAL_TOTAL;

    save(strcat(ProjectPath,ProjectName),'EAL','-append');
    pause(0.5);

end

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%

app.ProgressText.Value='SAVING LOSS DATA'; pause(0.5);
app.ProgressText.Value='DONE'; app.ProgressText.FontColor='g';
app.VisualizeButton.Enable='on'; app.ReportButton.Enable='on'; pause(0.5);
app.ProgressBar.Position=[9 5 613 6]; app.ProgressBar.BackgroundColor='g';
drawnow

LossDataStatus=1;

save(strcat(ProjectPath,ProjectName),'LossDataStatus','-append');

