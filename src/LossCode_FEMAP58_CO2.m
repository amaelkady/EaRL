function LossCode_FEMAP58_CO2(app)
global MainDirectory ProjectPath ProjectName
cd (ProjectPath)
load (ProjectName)
cd (MainDirectory)

clear COLLAPSE_LOSSES_Per_IM DEMOLITION_LOSSES_Per_IM DEAGG_DATA

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

load ('StoryLoss_Fragility_STEEL.mat')

if Units==1; meter2feet=3.28084;  end
if Units==2; meter2feet=1.0;      end

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
                SC_Typ_Flag=1;
                SC_Ground_Flag=1;
                NSC_ACC_Ground_Flag=1;
                NSC_ACC_Typ_Flag=0;
                Roof_Flag=0;  
                NSC_SDR_Typ_Flag=1; 
                CONTENTS_Typ_Flag=1; 
                SC_Flag=1;
            elseif n==N_Story+1
                SC_Ground_Flag=0;
                NSC_ACC_Ground_Flag=0;
                NSC_ACC_Typ_Flag=0;
                Roof_Flag=1;                 
                NSC_SDR_Typ_Flag=1; 
                SC_Typ_Flag=1;
                CONTENTS_Typ_Flag=1; 
                SC_Flag=0;
            else
                SC_Ground_Flag=0;     
                SC_Typ_Flag=1;
                NSC_SDR_Typ_Flag=1; 
                NSC_ACC_Ground_Flag=0;
                NSC_ACC_Typ_Flag=1;
                Roof_Flag=0;       
                CONTENTS_Typ_Flag=1; 
                SC_Flag=1;
            end

            if Area_Total > 5000*meter2feet^2
                Area5000_Flag=1;
            else
                Area5000_Flag=0;
            end

            % Repair Cost $ per Story
            PDM_SC1      =      SC_COSTmedian_Typ_FAD_PerEDPrange          * Area_FootPrint/100/meter2feet^2 * SC_Typ_Flag      * SC_Flag; 
            PDM_SC2      =      SC_COSTmedian_Ground_FAD_PerEDPrange       * Area_FootPrint/100/meter2feet^2 * SC_Ground_Flag   * SC_Flag; 
            PDM_NSC_SDR1 = NSC_SDR_COSTmedian_Typ_FAD_PerEDPrange          * Area_FootPrint/100/meter2feet^2 * NSC_SDR_Typ_Flag;
            PDM_NSC_ACC1 = NSC_ACC_COSTmedian_Ground_TAD_PerEDPrange       * Area_Total/100/meter2feet^2     * NSC_ACC_Ground_Flag;
            PDM_NSC_ACC2 = NSC_ACC_COSTmedian_Typ_FAD_PerEDPrange          * Area_FootPrint/100/meter2feet^2 * NSC_ACC_Typ_Flag;
            PDM_NSC_ACC3 = NSC_ACC_COSTmedian_Roof_FAD_PerEDPrange         * Area_FootPrint/100/meter2feet^2 * Roof_Flag;
            PDM_NSC_ACC4 = NSC_ACC_COSTmedian_Roof_TAD_PerEDPrange         * Area_Total/100/meter2feet^2     * Roof_Flag * Area5000_Flag;
            PDM_NSC_ACC5 = NSC_ACC_CONTENTS_COSTmedian_Typ_FAD_PerEDPrange * Area_FootPrint/100/meter2feet^2 * CONTENTS_Typ_Flag;

            PRNC_SC1      = interp1(MIDPTS.SDR,PDM_SC1,Ri_SDR)      * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost));
            PRNC_SC2      = interp1(MIDPTS.SDR,PDM_SC2,Ri_SDR)      * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost));
            PRNC_NSC_SDR1 = interp1(MIDPTS.SDR,PDM_NSC_SDR1,Ri_SDR) * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost));
            PRNC_NSC_ACC1 = interp1(MIDPTS.PFA,PDM_NSC_ACC1,Ri_PGA) * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost));
            PRNC_NSC_ACC2 = interp1(MIDPTS.PFA,PDM_NSC_ACC2,Ri_PFA) * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost));
            PRNC_NSC_ACC3 = interp1(MIDPTS.PFA,PDM_NSC_ACC3,Ri_PFA) * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost));
            PRNC_NSC_ACC4 = interp1(MIDPTS.PFA,PDM_NSC_ACC4,Ri_PFA) * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost));
            PRNC_NSC_ACC5 = interp1(MIDPTS.PFA,PDM_NSC_ACC5,Ri_PFA) * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost));

            PRNC_SC1(isnan(PRNC_SC1))=0;
            PRNC_SC2(isnan(PRNC_SC2))=0;
            PRNC_NSC_SDR1(isnan(PRNC_NSC_SDR1))=0;
            PRNC_NSC_ACC1(isnan(PRNC_NSC_ACC1))=0;
            PRNC_NSC_ACC2(isnan(PRNC_NSC_ACC2))=0;
            PRNC_NSC_ACC3(isnan(PRNC_NSC_ACC3))=0;
            PRNC_NSC_ACC4(isnan(PRNC_NSC_ACC4))=0;
            PRNC_NSC_ACC5(isnan(PRNC_NSC_ACC5))=0;
            
            DEAGG_DATA(counter,1)=im;
            DEAGG_DATA(counter,2)=Ri;
            DEAGG_DATA(counter,3)=n;
            DEAGG_DATA(counter,4)=PRNC_SC1 + PRNC_SC2;           
            DEAGG_DATA(counter,5)=PRNC_NSC_SDR1;           
            DEAGG_DATA(counter,6)=PRNC_NSC_ACC1 + PRNC_NSC_ACC2 + PRNC_NSC_ACC3 + PRNC_NSC_ACC4 + PRNC_NSC_ACC5;              
            DEAGG_DATA(counter,7)=PRNC_SC1 + PRNC_SC2+PRNC_NSC_SDR1+PRNC_NSC_ACC1 + PRNC_NSC_ACC2 + PRNC_NSC_ACC3 + PRNC_NSC_ACC4 + PRNC_NSC_ACC5;                      
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