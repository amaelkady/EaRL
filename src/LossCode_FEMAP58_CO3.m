function LossCode_FEMAP58_CO3(app)
global MainDirectory ProjectPath ProjectName
cd (ProjectPath)
load (ProjectName)
cd (MainDirectory)

clear COLLAPSE_LOSSES_Per_IM DEMOLITION_LOSSES_Per_IM DEAGG_DATA STORY_REPAIR_COST STORY_REPAIR_COST_SC STORY_REPAIR_COST_NSC_SDR STORY_REPAIR_COST_NSC_ACC SC_REPAIR_COST_PerIM NSC_SDR_REPAIR_COST_PerIM NSC_ACC_REPAIR_COST_PerIM REPAIR_COST_TOTAL_PerIM TOTAL_LOSSES_PerIM TOTAL_REPAIR_TIME_PerIM EAL

app.ProgressText.Value='INITIALIZING CODE';
app.ProgressText.FontColor='y';
app.ProgressBar.Position=[9 5 613 6];
app.ProgressBar.BackgroundColor='w';
pause(0.5);

%%
MIDPTS.SDR=RANGE.SDR(1:end-1)+diff(RANGE.SDR)/2;
MIDPTS.PFA=RANGE.PFA(1:end-1)+diff(RANGE.PFA)/2;

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%---------------------------------------------------------  PRE-CALCULATIONS AND FITTINGS  ----------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%

[REALIZATIONS]=Get_REALIZATIONS(app);

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%-----------------------------------------------------  LOSS DUE TO COLLAPSE  -----------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%


[COLLAPSE_LOSSES_Per_Ri] = Get_Collapse_Loss_Per_Ri(app,CPS_Option,IMpoints,MedianCPS,SigmaCPS,nRealization,nStripe,Demolition_Cost,Replacement_Cost,TargetIM);

COLLAPSE_LOSSES_Per_IM    = zeros(length(IMpoints),1);

cd (ProjectPath)
save(ProjectName,'COLLAPSE_LOSSES_Per_IM','COLLAPSE_LOSSES_Per_Ri','-append');
cd (MainDirectory)

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%---------------------------------------------  DEMOLITION COST DUE TO RESIDUAL DEFORMATIONS  -------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%

[DEMOLITION_LOSSES_Per_Ri] = Get_Demolition_Loss_Per_Ri(app,Demolition_Option,nRealization,nStripe,RANGE,DemolishMedianRDR,DemolishSigmaRDR,DemolishMedianVRD,DemolishSigmaVRD,DemolishCorr,REALIZATIONS,Demolition_Cost,Replacement_Cost,COLLAPSE_LOSSES_Per_Ri);

DEMOLITION_LOSSES_Per_IM    = zeros(length(IMpoints),1);

cd (ProjectPath)
save(ProjectName,'DEMOLITION_LOSSES_Per_IM','DEMOLITION_LOSSES_Per_Ri','-append');
cd (MainDirectory)


%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%---------------------------------------------  REPAIR COST FOR STRUCTURAL/NONSTRUCTURAL COMPONENTS -------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%

app.ProgressText.Value='CALCULATING REPAIR LOSS'; drawnow;

load ('StoryLoss_Fragility_RC.mat')

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

counter=1;

for im=1:nStripe            % Loop over IM levels
    for Ri=1:nRealization   % Loop over realizations
        for n=1:N_Story+1   % Loop over Stories 

            if nStripe==1
                [Ri_SDR]=Get_Realization_EDP_SI('SDR',N_Story,1,REALIZATIONS,n,Ri);
                [Ri_PFA]=Get_Realization_EDP_SI('PFA',N_Story,2,REALIZATIONS,n,Ri);
                [Ri_PGA]=Get_Realization_EDP_SI('PGA',N_Story,2,REALIZATIONS,n,Ri);
            else
                [Ri_SDR]=Get_Realization_EDP_MS('SDR',N_Story,1,REALIZATIONS,n,Ri,im);
                [Ri_PFA]=Get_Realization_EDP_MS('PFA',N_Story,2,REALIZATIONS,n,Ri,im);
                [Ri_PGA]=Get_Realization_EDP_MS('PGA',N_Story,2,REALIZATIONS,n,Ri,im);
            end

            if n==1
                Ground_Flag=1;
                Typ_Flag=0;
                Roof_Flag=0;  
                SC_Flag=1;
            elseif n==N_Story+1
                Ground_Flag=0;
                Typ_Flag=0;
                Roof_Flag=1; 
                SC_Flag=0;
            else
                Ground_Flag=0;     
                Typ_Flag=1; 
                Roof_Flag=0;
                SC_Flag=1;
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

            PRNC_SC1      = interp1(MIDPTS.SDR,PDM_SC1,Ri_SDR)      * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost));
            PRNC_SC2      = interp1(MIDPTS.SDR,PDM_SC2,Ri_SDR)      * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost));
            PRNC_SC3      = interp1(MIDPTS.SDR,PDM_SC3,Ri_SDR)      * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost));
            PRNC_NSC_SDR1 = interp1(MIDPTS.SDR,PDM_NSC_SDR1,Ri_SDR) * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost));
            PRNC_NSC_SDR2 = interp1(MIDPTS.SDR,PDM_NSC_SDR2,Ri_SDR) * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost));
            PRNC_NSC_SDR3 = interp1(MIDPTS.SDR,PDM_NSC_SDR3,Ri_SDR) * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost));
            PRNC_NSC_ACC1 = interp1(MIDPTS.PFA,PDM_NSC_ACC1,Ri_PGA) * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost));
            PRNC_NSC_ACC2 = interp1(MIDPTS.PFA,PDM_NSC_ACC2,Ri_PFA) * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost));
            PRNC_NSC_ACC3 = interp1(MIDPTS.PFA,PDM_NSC_ACC3,Ri_PFA) * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost));

            PRNC_SC1(isnan(PRNC_SC1))=0;
            PRNC_SC2(isnan(PRNC_SC2))=0;
            PRNC_SC3(isnan(PRNC_SC3))=0;
            PRNC_NSC_SDR1(isnan(PRNC_NSC_SDR1))=0;
            PRNC_NSC_SDR2(isnan(PRNC_NSC_SDR2))=0;
            PRNC_NSC_SDR3(isnan(PRNC_NSC_SDR3))=0;
            PRNC_NSC_ACC1(isnan(PRNC_NSC_ACC1))=0;
            PRNC_NSC_ACC2(isnan(PRNC_NSC_ACC2))=0;
            PRNC_NSC_ACC3(isnan(PRNC_NSC_ACC3))=0;
            
            DEAGG_DATA(counter,1)=im;
            DEAGG_DATA(counter,2)=Ri;
            DEAGG_DATA(counter,3)=n;
            DEAGG_DATA(counter,4)=PRNC_SC1 + PRNC_SC2 + PRNC_SC3;         
            DEAGG_DATA(counter,5)=PRNC_NSC_SDR1 + PRNC_NSC_SDR2 + PRNC_NSC_SDR3;           
            DEAGG_DATA(counter,6)=PRNC_NSC_ACC1 + PRNC_NSC_ACC2 + PRNC_NSC_ACC3;              
            DEAGG_DATA(counter,7)=PRNC_SC1 + PRNC_SC2 + PRNC_SC3 + PRNC_NSC_SDR1 + PRNC_NSC_SDR2 + PRNC_NSC_SDR3 + PRNC_NSC_ACC1 + PRNC_NSC_ACC2 + PRNC_NSC_ACC3;                      
            DEAGG_DATA(counter,8)=Ri_SDR;                      
            DEAGG_DATA(counter,9)=Ri_PFA;                      
            DEAGG_DATA(counter,10)=Ri_PGA;  
            
            counter=counter+1;
        
        end
    end
    app.ProgressText.Value=['CALCULATING REPAIR LOSS FOR ',num2str(nRealization), ' REALIZATIONS AT STRIPE #',num2str(im)];    app.ProgressBar.Position=[9 5 im/nStripe*613 6];  drawnow            
end

cd (ProjectPath)
pause(0.5);
save(ProjectName,'DEAGG_DATA','REALIZATIONS','-append');
pause(0.5);
cd (MainDirectory)

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

end

function [Ri_EDP] = Get_Realization_EDP_MS(EDP_Type,N_Story,Ci_level,REALIZATIONS,n,Ri,im)
    if strcmp(EDP_Type,'SDR')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; evalc(['Ri_EDP=REALIZATIONS.SDR_S',num2str(im),'(Ri, n)']); end
        if Ci_level==2 && n>1;         evalc(['Ri_EDP=REALIZATIONS.SDR_S',num2str(im),'(Ri, n-1)']); end
    elseif strcmp(EDP_Type,'PFA')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; evalc(['Ri_EDP=REALIZATIONS.PFA_S',num2str(im),'(Ri, n)']); end
        if Ci_level==2 && n>1;         evalc(['Ri_EDP=REALIZATIONS.PFA_S',num2str(im),'(Ri, n)']); end
    elseif strcmp(EDP_Type,'PGA')==1
        evalc(['Ri_EDP=REALIZATIONS.PFA_S',num2str(im),'(Ri, 1)']);
    end
end

function [Ri_EDP] = Get_Realization_EDP_SI(EDP_Type,N_Story,Ci_level,REALIZATIONS,n,Ri)
    if strcmp(EDP_Type,'SDR')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; Ri_EDP=REALIZATIONS.SDR(Ri, n); end
        if Ci_level==2 && n>1;         Ri_EDP=REALIZATIONS.SDR(Ri, n-1); end
    elseif strcmp(EDP_Type,'PFA')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; Ri_EDP=REALIZATIONS.PFA(Ri, n); end
        if Ci_level==2 && n>1;         Ri_EDP=REALIZATIONS.PFA(Ri, n); end
    elseif strcmp(EDP_Type,'PGA')==1
        Ri_EDP=REALIZATIONS.PFA(Ri, 1);
    end
end