function LossCode_PEER_CO3(app)
global MainDirectory ProjectPath ProjectName
cd (ProjectPath)
load (ProjectName)
cd (MainDirectory)

clear COLLAPSE_LOSSES_Per_IM DEMOLITION_LOSSES_Per_IM DEAGG_COMPONENT_REPAIR_COST STORY_REPAIR_COST STORY_REPAIR_COST_SC STORY_REPAIR_COST_NSC_SDR STORY_REPAIR_COST_NSC_ACC SC_REPAIR_COST_PerIM NSC_SDR_REPAIR_COST_PerIM NSC_ACC_REPAIR_COST_PerIM REPAIR_COST_TOTAL_PerIM TOTAL_LOSSES_PerIM TOTAL_REPAIR_TIME_PerIM EAL

app.ProgressText.Value='INITIALIZING CODE';
app.ProgressText.FontColor='y';
app.ProgressBar.Position=[9 5 613 6];
app.ProgressBar.BackgroundColor='w';
pause(0.5);

%%
                         MIDPTS.SDR=RANGE.SDR(1:end-1)+diff(RANGE.SDR)/2;
                         MIDPTS.PFA=RANGE.PFA(1:end-1)+diff(RANGE.PFA)/2;
                         MIDPTS.RDR=RANGE.RDR(1:end-1)+diff(RANGE.RDR)/2;
if Data_Status.VRD==1;   MIDPTS.VRD=RANGE.VRD  (1:end-1)+diff(RANGE.VRD)/2;     end

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%------------------------------------------------------------  LOSS DUE TO COLLAPSE  ----------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%

[COLLAPSE_LOSSES_Per_IM,Pr_Collapse_per_IM]=Get_Collapse_Loss_Per_IM(app,IMpoints,MedianCPS,SigmaCPS,Replacement_Cost);

cd (ProjectPath)
save(ProjectName,'COLLAPSE_LOSSES_Per_IM','-append');
cd (MainDirectory)

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%---------------------------------------------  DEMOLITION COST DUE TO RESIDUAL DEFORMATIONS  -------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%

[DEMOLITION_LOSSES_Per_IM,Pr_Demolition_per_IM]=Get_Demolition_Loss_Per_IM(app,Demolition_Option,IMpoints,nStripe,EDP_Data,RANGE,MIDPTS,DemolishMedianRDR,DemolishSigmaRDR,DemolishMedianVRD,DemolishSigmaVRD,DemolishCorr,Demolition_Cost,Replacement_Cost,Pr_Collapse_per_IM,TargetIM);

cd (ProjectPath)
save(ProjectName,'DEMOLITION_LOSSES_Per_IM','-append');
cd (MainDirectory)

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%---------------------------------------------  REPAIR COST FOR STRUCTURAL/NONSTRUCTURAL COMPONENTS -------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%

app.ProgressText.Value='CALCULATING REPAIR LOSS';  drawnow;

load ('StoryLoss_Fragility_RC.mat')

if Units==1; meter2feet=3.28084;  end
if Units==2; meter2feet=1.0;      end

indxDuctility=DuctilityType;
indxFrame=FrameType;

if N_Story < 5
    indxRise=1;
elseif 5 < N_Story && N_Story < 10
    indxRise=2;
elseif N_Story > 10
    indxRise=3;
end

% Structural Repair Costs: 1st Story
SC_EDPval_Ground     = cell2mat(costfun(indxDuctility*indxFrame*indxRise).costpar(:,1));
SC_COSTvals_Ground   = cell2mat(costfun(indxDuctility*indxFrame*indxRise).costpar(:,3));
SC_COSTmedian_Ground = SC_COSTvals_Ground(:,1) * Replacement_Cost/N_Story;
SC_COSTmedian_Ground_PerEDPrange = pchip(SC_EDPval_Ground,SC_COSTmedian_Ground, MIDPTS.SDR);

% Non-Structural SDR-Sensitive Repair Costs: 1st Story
NSC_SDR_EDPval_Ground     = cell2mat(costfun(indxDuctility*indxFrame*indxRise+1).costpar(:,1));
NSC_SDR_COSTvals_Ground   = cell2mat(costfun(indxDuctility*indxFrame*indxRise+1).costpar(:,3));
NSC_SDR_COSTmedian_Ground = NSC_SDR_COSTvals_Ground(:,1) * Replacement_Cost/N_Story;
NSC_SDR_COSTmedian_Ground_PerEDPrange = pchip(NSC_SDR_EDPval_Ground,NSC_SDR_COSTmedian_Ground, MIDPTS.SDR);

% Non-Structural ACC-Sensitive Repair Costs: 1st Story
NSC_ACC_EDPval_Ground     = cell2mat(costfun(indxDuctility*indxFrame*indxRise+2).costpar(:,1));
NSC_ACC_COSTvals_Ground   = cell2mat(costfun(indxDuctility*indxFrame*indxRise+2).costpar(:,3));
NSC_ACC_COSTmedian_Ground = NSC_ACC_COSTvals_Ground(:,1) * Replacement_Cost/N_Story;
NSC_ACC_COSTmedian_Ground_PerEDPrange = pchip(NSC_ACC_EDPval_Ground,NSC_ACC_COSTmedian_Ground, MIDPTS.PFA);

% Structural Repair Costs: Typical Story
SC_EDPval_Typ     = cell2mat(costfun(indxDuctility*indxFrame*indxRise+3).costpar(:,1));
SC_COSTvals_Typ   = cell2mat(costfun(indxDuctility*indxFrame*indxRise+3).costpar(:,3));
SC_COSTmedian_Typ = SC_COSTvals_Typ(:,1) * Replacement_Cost/N_Story;
SC_COSTmedian_Typ_PerEDPrange = pchip(SC_EDPval_Typ,SC_COSTmedian_Typ, MIDPTS.SDR);

% Non-Structural SDR-Sensitive Repair Costs: Typical Story
NSC_SDR_EDPval_Typ     = cell2mat(costfun(indxDuctility*indxFrame*indxRise+4).costpar(:,1));
NSC_SDR_COSTvals_Typ   = cell2mat(costfun(indxDuctility*indxFrame*indxRise+4).costpar(:,3));
NSC_SDR_COSTmedian_Typ = NSC_SDR_COSTvals_Typ(:,1) * Replacement_Cost/N_Story;
NSC_SDR_COSTmedian_Typ_PerEDPrange = pchip(NSC_SDR_EDPval_Typ,NSC_SDR_COSTmedian_Typ, MIDPTS.SDR);

% Non-Structural SDR-Sensitive Repair Costs: Typical Story
NSC_ACC_EDPval_Typ     = cell2mat(costfun(indxDuctility*indxFrame*indxRise+5).costpar(:,1));
NSC_ACC_COSTvals_Typ   = cell2mat(costfun(indxDuctility*indxFrame*indxRise+5).costpar(:,3));
NSC_ACC_COSTmedian_Typ = NSC_ACC_COSTvals_Typ(:,1) * Replacement_Cost/N_Story;
NSC_ACC_COSTmedian_Typ_PerEDPrange = pchip(NSC_ACC_EDPval_Typ,NSC_ACC_COSTmedian_Typ, MIDPTS.PFA);

% Structural Repair Costs: Roof
SC_EDPval_Roof      = cell2mat(costfun(indxDuctility*indxFrame*indxRise+6).costpar(:,1));
SC_COSTvals_Roof    = cell2mat(costfun(indxDuctility*indxFrame*indxRise+6).costpar(:,3));
SC_COSTmedian_Roof  = SC_COSTvals_Roof(:,1) * Replacement_Cost/N_Story;
SC_COSTmedian_Roof_PerEDPrange = pchip(SC_EDPval_Roof,SC_COSTmedian_Roof, MIDPTS.SDR);

% Non-Structural SDR-Sensitive Repair Costs: Roof
NSC_SDR_EDPval_Roof     = cell2mat(costfun(indxDuctility*indxFrame*indxRise+7).costpar(:,1));
NSC_SDR_COSTvals_Roof   = cell2mat(costfun(indxDuctility*indxFrame*indxRise+7).costpar(:,3));
NSC_SDR_COSTmedian_Roof = NSC_SDR_COSTvals_Roof(:,1) * Replacement_Cost/N_Story;
NSC_SDR_COSTmedian_Roof_PerEDPrange = pchip(NSC_SDR_EDPval_Roof,NSC_SDR_COSTmedian_Roof, MIDPTS.SDR);

% Non-Structural SDR-Sensitive Repair Costs: Roof
NSC_ACC_EDPval_Roof     = cell2mat(costfun(indxDuctility*indxFrame*indxRise+8).costpar(:,1));
NSC_ACC_COSTvals_Roof   = cell2mat(costfun(indxDuctility*indxFrame*indxRise+8).costpar(:,3));
NSC_ACC_COSTmedian_Roof = NSC_ACC_COSTvals_Roof(:,1) * Replacement_Cost/N_Story;
NSC_ACC_COSTmedian_Roof_PerEDPrange = pchip(NSC_ACC_EDPval_Roof,NSC_ACC_COSTmedian_Roof, MIDPTS.PFA);

STORY_REPAIR_COST_SC        = zeros(nIMpoints,N_Story+1);
STORY_REPAIR_COST_NSC_SDR   = zeros(nIMpoints,N_Story+1);
STORY_REPAIR_COST_NSC_ACC   = zeros(nIMpoints,N_Story+1);
STORY_REPAIR_COST           = zeros(nIMpoints,N_Story+1);
SC_REPAIR_COST_PerIM        = zeros(nIMpoints,1); 
NSC_SDR_REPAIR_COST_PerIM   = zeros(nIMpoints,1); 
NSC_ACC_REPAIR_COST_PerIM   = zeros(nIMpoints,1); 
REPAIR_COST_TOTAL_PerIM     = zeros(nIMpoints,1); 

Stripe=0;
for im=1:nIMpoints  % Loop over IM levels
    if ismember(IMpoints(1,im),TargetIM)
        Stripe=Stripe+1;
        for n=1:N_Story+1   % Loop over Stories 

            if n==N_Story+1
                PEDP_SDR=logncdf(RANGE.SDR,log(0.00001),0.01);
                DPEDP_SDR=abs(diff(PEDP_SDR));
            else
                evalc(['PEDP_SDR=logncdf(RANGE.SDR,log(EDP_Data.SDRmedian.S',num2str(Stripe),'(1,n)),EDP_Data.SDRsigma.S',num2str(Stripe),'(1,n))']);
                DPEDP_SDR=abs(diff(PEDP_SDR));                
            end

            evalc(['PEDP_PFA=logncdf(RANGE.PFA,log(EDP_Data.PFAmedian.S',num2str(Stripe),'(1,n)),EDP_Data.PFAsigma.S',num2str(Stripe),'(1,n))']);
            DPEDP_PFA=abs(diff(PEDP_PFA));

            evalc(['PEDP_PGA=logncdf(RANGE.PFA,log(EDP_Data.PFAmedian.S',num2str(Stripe),'(1,1)),EDP_Data.PFAsigma.S',num2str(Stripe),'(1,1))']);
            DPEDP_PGA=abs(diff(PEDP_PGA));

            if     n==1;            Ground_Flag=1; Typ_Flag=0; Roof_Flag=0; SC_Flag=1;
            elseif n==N_Story+1;    Ground_Flag=0; Typ_Flag=0; Roof_Flag=1; SC_Flag=0;
            else;                   Ground_Flag=0; Typ_Flag=1; Roof_Flag=0; SC_Flag=1;
            end

            % Repair Cost $ per Story
            PDM_SC1      = SC_COSTmedian_Ground_PerEDPrange     * Ground_Flag   * SC_Flag; 
            PDM_SC2      = SC_COSTmedian_Typ_PerEDPrange        * Typ_Flag      * SC_Flag; 
            PDM_SC3      = SC_COSTmedian_Roof_PerEDPrange       * Roof_Flag     * SC_Flag; 
            PDM_NSC_SDR1 = NSC_SDR_COSTmedian_Ground_PerEDPrange* Ground_Flag;
            PDM_NSC_SDR2 = NSC_SDR_COSTmedian_Typ_PerEDPrange   * Typ_Flag;
            PDM_NSC_SDR3 = NSC_SDR_COSTmedian_Roof_PerEDPrange  * Roof_Flag;
            PDM_NSC_ACC1 = NSC_ACC_COSTmedian_Ground_PerEDPrange* Ground_Flag;
            PDM_NSC_ACC2 = NSC_ACC_COSTmedian_Typ_PerEDPrange   * Typ_Flag;
            PDM_NSC_ACC3 = NSC_ACC_COSTmedian_Roof_PerEDPrange  * Roof_Flag;

            PRNC_SC1      = PDM_SC1      * DPEDP_SDR' * (1-Pr_Demolition_per_IM(im,1)) * (1-Pr_Collapse_per_IM(im,1));
            PRNC_SC2      = PDM_SC2      * DPEDP_SDR' * (1-Pr_Demolition_per_IM(im,1)) * (1-Pr_Collapse_per_IM(im,1));
            PRNC_SC3      = PDM_SC3      * DPEDP_SDR' * (1-Pr_Demolition_per_IM(im,1)) * (1-Pr_Collapse_per_IM(im,1));
            PRNC_NSC_SDR1 = PDM_NSC_SDR1 * DPEDP_SDR' * (1-Pr_Demolition_per_IM(im,1)) * (1-Pr_Collapse_per_IM(im,1));
            PRNC_NSC_SDR2 = PDM_NSC_SDR2 * DPEDP_SDR' * (1-Pr_Demolition_per_IM(im,1)) * (1-Pr_Collapse_per_IM(im,1));
            PRNC_NSC_SDR3 = PDM_NSC_SDR3 * DPEDP_SDR' * (1-Pr_Demolition_per_IM(im,1)) * (1-Pr_Collapse_per_IM(im,1));
            PRNC_NSC_ACC1 = PDM_NSC_ACC1 * DPEDP_PGA' * (1-Pr_Demolition_per_IM(im,1)) * (1-Pr_Collapse_per_IM(im,1));
            PRNC_NSC_ACC2 = PDM_NSC_ACC2 * DPEDP_PFA' * (1-Pr_Demolition_per_IM(im,1)) * (1-Pr_Collapse_per_IM(im,1));
            PRNC_NSC_ACC3 = PDM_NSC_ACC3 * DPEDP_PFA' * (1-Pr_Demolition_per_IM(im,1)) * (1-Pr_Collapse_per_IM(im,1));

            STORY_REPAIR_COST_SC(im,n)      = PRNC_SC1 + PRNC_SC2+ PRNC_SC3;
            STORY_REPAIR_COST_NSC_SDR(im,n) = PRNC_NSC_SDR1 + PRNC_NSC_SDR2 + PRNC_NSC_SDR3;
            STORY_REPAIR_COST_NSC_ACC(im,n) = PRNC_NSC_ACC1 + PRNC_NSC_ACC2 + PRNC_NSC_ACC3;            
            STORY_REPAIR_COST(im,n) = STORY_REPAIR_COST_SC(im,n) + STORY_REPAIR_COST_NSC_SDR(im,n) + STORY_REPAIR_COST_NSC_ACC(im,n);            

            clear PEDP_SDR PEDP_ACC PEDP_PGA DPEDP_SDR DPEDP_ACC DPEDP_PGA;  	% Clear these variables before going to the next story

        end
        app.ProgressText.Value=['CALCULATING REPAIR LOSS AT STRIPE #',num2str(Stripe)];  app.ProgressBar.Position=[9 5 Stripe/nStripe*613 6];  drawnow
    end
end

SC_REPAIR_COST_PerIM(:,1)      = sum(STORY_REPAIR_COST_SC,2) ;
NSC_SDR_REPAIR_COST_PerIM(:,1) = sum(STORY_REPAIR_COST_NSC_SDR,2);
NSC_ACC_REPAIR_COST_PerIM(:,1) = sum(STORY_REPAIR_COST_NSC_ACC,2);
REPAIR_COST_TOTAL_PerIM(:,1)   = SC_REPAIR_COST_PerIM(:,1) + NSC_SDR_REPAIR_COST_PerIM(:,1) + NSC_ACC_REPAIR_COST_PerIM(:,1);
TOTAL_LOSSES_PerIM = COLLAPSE_LOSSES_Per_IM + DEMOLITION_LOSSES_Per_IM + REPAIR_COST_TOTAL_PerIM;

cd (ProjectPath)
save(ProjectName,'STORY_REPAIR_COST','STORY_REPAIR_COST_SC','STORY_REPAIR_COST_NSC_SDR','STORY_REPAIR_COST_NSC_ACC','-append');
pause(0.5);
save(ProjectName,'SC_REPAIR_COST_PerIM','NSC_SDR_REPAIR_COST_PerIM','NSC_ACC_REPAIR_COST_PerIM','REPAIR_COST_TOTAL_PerIM','TOTAL_LOSSES_PerIM','-append');
pause(0.5);
cd (MainDirectory)

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

    cd (ProjectPath)
    pause(0.5);
    save(ProjectName,'EAL','-append');
    pause(0.5);
    cd (MainDirectory)

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

cd (ProjectPath)
save(ProjectName,'LossDataStatus','-append');
cd (MainDirectory)

