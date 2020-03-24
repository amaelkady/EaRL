function LossCode_PEER_CO1_IDA (app)
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
if Data_Status.RDR==1;   MIDPTS.RDR=RANGE.RDR(1:end-1)+diff(RANGE.RDR)/2;       end
if Data_Status.VRD==1;   MIDPTS.VRD=RANGE.VRD(1:end-1)+diff(RANGE.VRD)/2;       end
if Data_Status.GENS1==1; MIDPTS.GENS1=RANGE.GENS1(1:end-1)+diff(RANGE.GENS1)/2; end
if Data_Status.GENS2==1; MIDPTS.GENS2=RANGE.GENS2(1:end-1)+diff(RANGE.GENS2)/2; end
if Data_Status.GENS3==1; MIDPTS.GENS3=RANGE.GENS3(1:end-1)+diff(RANGE.GENS3)/2; end
if Data_Status.GENF1==1; MIDPTS.GENF1=RANGE.GENF1(1:end-1)+diff(RANGE.GENF1)/2; end
if Data_Status.GENF2==1; MIDPTS.GENF2=RANGE.GENF2(1:end-1)+diff(RANGE.GENF2)/2; end
if Data_Status.GENF3==1; MIDPTS.GENF3=RANGE.GENF3(1:end-1)+diff(RANGE.GENF3)/2; end

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%---------------------------------------------------------  PRE-CALCULATIONS AND FITTINGS  ----------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%

[errorFlag]=Check_Frag_Data (app,COMPDATA,FRAGDATA,C_Data); if errorFlag==1;  return; end

% Get the Median and Sigma values of the EDPs wrt IM values
                            [MEDIAN_IM.SDR,SIGMA_IM.SDR]        = Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'SDR',IDAFilename.SDR,N_Story);
                            [MEDIAN_IM.PFA,SIGMA_IM.PFA]        = Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'PFA',IDAFilename.PFA,N_Story+1);
if Data_Status.RDR==1;      [MEDIAN_IM.RDR,SIGMA_IM.RDR]        = Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'RDR',IDAFilename.RDR,1);              end
if Data_Status.VRD==1;      [MEDIAN_IM.VRD,SIGMA_IM.VRD]        = Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'VRD',IDAFilename.VRD,1);              end
if Data_Status.LINKROT==1;  [MEDIAN_IM.LINKROT,SIGMA_IM.LINKROT]= Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'LINK ROT',IDAFilename.LINKROT,N_Story);end
if Data_Status.BEAMROT==1;  [MEDIAN_IM.BEAMROT,SIGMA_IM.BEAMROT]= Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'BEAM ROT',IDAFilename.BEAMROT,N_Story);end
if Data_Status.COLROT==1;   [MEDIAN_IM.COLROT,SIGMA_IM.COLROT]  = Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'COL ROT',IDAFilename.COLROT,N_Story); end
if Data_Status.PFV==1;      [MEDIAN_IM.PFV,SIGMA_IM.PFV]        = Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'PFV',IDAFilename.PFV,N_Story);        end
if Data_Status.DWD==1;      [MEDIAN_IM.DWD,SIGMA_IM.DWD]        = Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'DWD',IDAFilename.DWD,N_Story);        end
if Data_Status.RD==1;       [MEDIAN_IM.RD,SIGMA_IM.RD]          = Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'RD',IDAFilename.RD,N_Story);          end
if Data_Status.ED==1;       [MEDIAN_IM.ED,SIGMA_IM.ED]          = Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'ED',IDAFilename.ED,N_Story);          end
if Data_Status.GENS1==1;    [MEDIAN_IM.GENS1,SIGMA_IM.GENS1]    = Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'GENS1',IDAFilename.GENS1,N_Story);       end
if Data_Status.GENS2==1;    [MEDIAN_IM.GENS2,SIGMA_IM.GENS2]    = Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'GENS2',IDAFilename.GENS2,N_Story);       end
if Data_Status.GENS3==1;    [MEDIAN_IM.GENS3,SIGMA_IM.GENS3]    = Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'GENS3',IDAFilename.GENS3,N_Story);       end
if Data_Status.GENF1==1;    [MEDIAN_IM.GENF1,SIGMA_IM.GENF1]    = Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'GENF1',IDAFilename.GENF1,N_Story+1);     end
if Data_Status.GENF2==1;    [MEDIAN_IM.GENF2,SIGMA_IM.GENF2]    = Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'GENF2',IDAFilename.GENF2,N_Story+1);     end
if Data_Status.GENF3==1;    [MEDIAN_IM.GENF3,SIGMA_IM.GENF3]    = Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,'GENF3',IDAFilename.GENF3,N_Story+1);     end

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%-----------------------------------------------------  REPLACEMENT COST DUE TO COLLAPSE  -----------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%

[COLLAPSE_LOSSES_Per_IM,Pr_Collapse_per_IM]=Get_Collapse_Loss_Per_IM(app,IMpoints,MedianCPS,SigmaCPS,Replacement_Cost);

cd (ProjectPath)
save(ProjectName,'COLLAPSE_LOSSES_Per_IM','-append');
cd (MainDirectory)

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%---------------------------------------------  DEMOLITION COST DUE TO RESIDUAL DEFORMATIONS  -------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%

[DEMOLITION_LOSSES_Per_IM,Pr_Demolition_per_IM]=Get_Demolition_Loss_Per_IM_IDA(app,Demolition_Option,IMpoints,MEDIAN_IM,SIGMA_IM,RANGE,MIDPTS,DemolishMedianRDR,DemolishSigmaRDR,DemolishMedianVRD,DemolishSigmaVRD,DemolishCorr,Demolition_Cost,Replacement_Cost,Pr_Collapse_per_IM,TargetIM);

cd (ProjectPath)
save(ProjectName,'DEMOLITION_LOSSES_Per_IM','-append');
pause(1.0);
cd (MainDirectory)

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%---------------------------------------------  REPAIR COST FOR STRUCTURAL/NONSTRUCTURAL COMPONENTS -------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%

app.ProgressText.Value='CALCULATING REPAIR LOSS'; drawnow;

% for i=1:size(C_Data,1)
%     Ci_ID  = C_Data(i,1);
%     Ci_nDS = C_Data(i,4);
%     IDXF=find(Ci_ID==FRAGDATA.C_ID);
%     if FRAGDATA.DS_FragType(IDXF(Ci_nDS,1))==222
%         for DSi=1:Ci_nDS
%             MedianEDP = FRAGDATA.DS_EDPmedian (IDXF(DSi,1));  % scalar
%             SigmaEDP  = FRAGDATA.DS_EDPsigma  (IDXF(DSi,1));  % scalar 
%             MedianP   = FRAGDATA.DS_Pmedian   (IDXF(DSi,1));  % scalar 
%             SigmaP    = FRAGDATA.DS_Psigma    (IDXF(DSi,1));  % scalar 
%             corrBV    = FRAGDATA.DS_Correlation(IDXF(DSi,1)); % scalar
%             MIDPTS.SP   = 0.001:MedianP/50:MedianP*5;           % row vector: range for integeration over P
%             if strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'SDR')==1 || strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'COL ROT')==1 || strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'BEAM ROT')==1 || strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'LINK ROT')==1 || strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'DWD')==1  || strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'RD')==1
%                 MIDPTS.EDP=MIDPTS.SDR;
%             elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'PFA')==1 || strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'PGA')==1
%                 MIDPTS.EDP=MIDPTS.PFA;
%             end
%             CDF_BV = Get_CorrBivariateDemolitionCDF(MIDPTS.EDP,MIDPTS.SP,MedianEDP,SigmaEDP,MedianP,SigmaP,corrBV);
%             evalc(strcat('CDF_BV',num2str(Ci_ID),num2str(DSi),'=CDF_BV'));
%         end
%     end
% end

STORY_REPAIR_COST_SC        = zeros(nIMpoints,N_Story+1);
STORY_REPAIR_COST_NSC_SDR   = zeros(nIMpoints,N_Story+1);
STORY_REPAIR_COST_NSC_ACC   = zeros(nIMpoints,N_Story+1);
STORY_REPAIR_COST           = zeros(nIMpoints,N_Story+1);
SC_REPAIR_COST_PerIM        = zeros(nIMpoints,1); 
NSC_SDR_REPAIR_COST_PerIM   = zeros(nIMpoints,1); 
NSC_ACC_REPAIR_COST_PerIM   = zeros(nIMpoints,1); 
REPAIR_COST_TOTAL_PerIM     = zeros(nIMpoints,1);  

counter=1;
for im=1:nIMpoints  % Loop over IM levels
    if IMpoints(1,im)>= min(TargetIM) && IMpoints(1,im)<= max(TargetIM)
        for n=1:N_Story+1 % Loop over all Stories 
            COMPONENT_REPAIR_COST=0; % code added on 8thMay2019
            
            IDX=find(C_Data(:,2)==n | C_Data(:,2)==0); % Find the locations (i.e., row index) of the structural components that exit in story "n" or at typical story (i.e., story "0"). Save those indeces in vector IDX.
            SC_COMPONENT_REPAIR_COST=0.0;
            NSC_SDR_COMPONENT_REPAIR_COST=0.0;
            NSC_ACC_COMPONENT_REPAIR_COST=0.0;
            
            for Ci=1:length(IDX)    % Loop over the components present at a given storey  
                
                PRNC=0; PEDP=0;
                rowINDEX=IDX(Ci,1);
                Ci_ID     = C_Data(rowINDEX,1);
                Ci_nUnits = C_Data(rowINDEX,3);
                Ci_nDS    = C_Data(rowINDEX,4);
                Ci_level  = C_Data(rowINDEX,5);
               
                IDXC=find(Ci_ID==COMPDATA.C_ID); % Find the location (i.e., row index) of the current Ci in the COMPDATA Matrix
                IDXF=find(Ci_ID==FRAGDATA.C_ID); % Find the location (i.e., row index) of the current Ci in the FRAGDATA Matrix

                %% MULTIVARIATE COMPONENT FRAGILITY
                %(identified by the unique number 333 assigned DS_FragType values)
                if FRAGDATA.DS_FragType(IDXF(Ci_nDS,1))==333
                    % Get the EDP parameters based on the component EDP
                    [MIDPTS, DPEDP]=Get_EDP_FragParam(FRAGDATA,IDXF,RANGE,MEDIAN_IM,SIGMA_IM,MIDPTS,Ci_level,N_Story,n,im);  

                    % Loop over the component damage states
                    for DSi=1:Ci_nDS 
                        if DSi==Ci_nDS
                            evalc(['PDM    = FragFun',num2str(Ci_ID),num2str(DSi),  '(MIDPTS.EDP,Predictor_Data',num2str(Ci_ID),'(n,1),Predictor_Data',num2str(Ci_ID),'(n,2))']);
                            %PDM = 1-(exp(yi)./(1+exp(yi)));         %% SHOULD NOT ADD THIS LINE IN FINAL CODE SINCE THE USER IS SUPPOSED TO ENTER THE CDF FUNCTION DIRECTLY
                        else
                            % Get the Number of the Next Sequential DS (CODE ADDED BY AHMED ELKADY ON 10July206)
                            for xx=DSi+1:Ci_nDS
                                if FRAGDATA.DS_P (IDXF(xx,1))==1
                                    DSiseq=xx;
                                    break;
                                end
                            end
                            evalc(['PDMi   = FragFun',num2str(Ci_ID),num2str(DSi),     '(MIDPTS.EDP,Predictor_Data',num2str(Ci_ID),'(n,1),Predictor_Data',num2str(Ci_ID),'(n,2))']);
                            evalc(['PDMi_1 = FragFun',num2str(Ci_ID),num2str(DSiseq+1),'(MIDPTS.EDP,Predictor_Data',num2str(Ci_ID),'(n,1),Predictor_Data',num2str(Ci_ID),'(n,2))']);
                            %PDMi   = 1-(exp(yi)./(1+exp(yi)));      %% SHOULD NOT ADD THIS LINE IN FINAL CODE SINCE THE USER IS SUPPOSED TO ENTER THE CDF FUNCTION DIRECTLY
                            %PDMi_1 = 1-(exp(yi_1)./(1+exp(yi_1)));  %% SHOULD NOT ADD THIS LINE IN FINAL CODE SINCE THE USER IS SUPPOSED TO ENTER THE CDF FUNCTION DIRECTLY
                            PDM = PDMi-PDMi_1;
                        end
                        PRNC(1,DSi)=PDM*DPEDP'*(1-Pr_Demolition_per_IM(im,1))*(1-Pr_Collapse_per_IM(im,1))* FRAGDATA.DS_P(IDXF(DSi,1)); % Probability of DSi given No Collapse - Vector of size 1xCi_NoDS
                        clear PDM PDMi PDMi_1; % Clear the variable before going to the damage state
                    end
                    RepairCost(:,1)=FRAGDATA.DS_Costmedian(IDXF(1,1):IDXF(Ci_nDS,1)); %$    Vector of size Ci_NoDSx1 
                end

                %% UNIVARIATE COMPONENT FRAGILITY
                if FRAGDATA.DS_FragType(IDXF(Ci_nDS,1))==111
                    % Get the EDP parameters based on the component EDP
                    [MIDPTS, DPEDP]=Get_EDP_FragParam_IM(FRAGDATA,IDXF,RANGE,MEDIAN_IM,SIGMA_IM,MIDPTS,Ci_level,N_Story,n,im);  

                    for DSi=1:Ci_nDS    % Loop over damage states

                        mu    = log(FRAGDATA.DS_EDPmedian(IDXF(DSi,1)));                                    % scalar
                        sigma =     FRAGDATA.DS_EDPsigma (IDXF(DSi,1));  if sigma==0.0; sigma=0.001; end    % scalar 
                        
                        if DSi==Ci_nDS
                            PDM = logncdf(MIDPTS.EDP,mu,sigma); % Probability of Damage at a given EDP
                        else
                            % Get the Number of the Next Sequential DS (CODE ADDED BY AHMED ELKADY ON 10July206)
                            for xx=DSi+1:Ci_nDS
                                if strcmp(FRAGDATA.DS_Hierarchy (IDXF(xx,1)),'Sequential')==1
                                    DSiseq=xx;
                                    break;
                                end
                            end
                            % Calulcate the probability of reaching/exceeding DSi but not exceedding the next SEQUENTIAL DS  ---> P(DSi <= ds <= DSi_seq) = P(ds >= DSi) - P(ds >= DSi_seq)
                            PDM = (logncdf(MIDPTS.EDP,mu,sigma)...
                                  -logncdf(MIDPTS.EDP,log(FRAGDATA.DS_EDPmedian(IDXF(DSiseq,1))),max(0.001,FRAGDATA.DS_EDPsigma(IDXF(DSiseq,1)))));
                        end
                        PRNC(1,DSi) = PDM * DPEDP' * (1-Pr_Demolition_per_IM(im,1)) * (1-Pr_Collapse_per_IM(im,1))* FRAGDATA.DS_P(IDXF(DSi,1)); % Probability of getting DSi given No Demolition and No Collapse - %Vector of size 1xCi_NoDS
                        clear PDM
                    end
                    RepairCost(:,1) = FRAGDATA.DS_Cost(IDXF(1,1):IDXF(Ci_nDS,1)); %$    Vector of size Ci_NoDSx1 
                end

                %% CODE TO CALCULATE THE CONTRIBUTION OF EACH COMPONENT AT EACH IM AND EACH STORY
                DEAGG_DATA(counter,1)=im;            
                DEAGG_DATA(counter,2)=n;
                DEAGG_DATA(counter,3)=Ci_ID;
                DEAGG_DATA(counter,4)=PRNC*RepairCost*Ci_nUnits;
                if  COMPDATA.C_Category2(IDXC)=="Superstructure"
                    DEAGG_DATA(counter,5)=1;              
                elseif COMPDATA.C_Category2(IDXC)~="Superstructure" && COMPDATA.C_EDP(IDXC)=="SDR"
                    DEAGG_DATA(counter,5)=2;            
                elseif COMPDATA.C_Category2(IDXC)~="Superstructure" && COMPDATA.C_EDP(IDXC)=="PFA"
                    DEAGG_DATA(counter,5)=3;            
                end
                counter=counter+1;

                IDXC=find(Ci_ID==COMPDATA.C_ID);
                if  COMPDATA.C_Category2(IDXC)=="Superstructure"
                    SC_COMPONENT_REPAIR_COST=SC_COMPONENT_REPAIR_COST+PRNC*RepairCost*Ci_nUnits;
                elseif COMPDATA.C_Category2(IDXC)~="Superstructure" && COMPDATA.C_EDP(IDXC)=="SDR"
                    NSC_SDR_COMPONENT_REPAIR_COST=NSC_SDR_COMPONENT_REPAIR_COST+PRNC*RepairCost*Ci_nUnits;
                elseif COMPDATA.C_Category2(IDXC)~="Superstructure" && COMPDATA.C_EDP(IDXC)=="PFA"
                    NSC_ACC_COMPONENT_REPAIR_COST=NSC_ACC_COMPONENT_REPAIR_COST+PRNC*RepairCost*Ci_nUnits;            
                end
                COMPONENT_REPAIR_COST(Ci,1)=PRNC*RepairCost*Ci_nUnits;     % Multiplying  1xCi_NoDS by Ci_NoDSx1 by Scaler
                clear PRNC RepairCost RepairTime IDXF PEDP DPEDP IDXC;     % Clear these variables before going to the next SC component
            end

            STORY_REPAIR_COST_SC(im,n)=SC_COMPONENT_REPAIR_COST;
            STORY_REPAIR_COST_NSC_SDR(im,n)=NSC_SDR_COMPONENT_REPAIR_COST;
            STORY_REPAIR_COST_NSC_ACC(im,n)=NSC_ACC_COMPONENT_REPAIR_COST;

            STORY_REPAIR_COST(im,n)=sum(COMPONENT_REPAIR_COST(:,1));       % Sum up all the repair costs at story n
            clear IDX COMPONENT_REPAIR_COST COMPONENT_REPAIR_TIME;         % Clear the variable before going to the next story
    
        end

        SC_REPAIR_COST_PerIM(im,1)=sum(STORY_REPAIR_COST_SC(im,:)); 
        NSC_SDR_REPAIR_COST_PerIM(im,1)=sum(STORY_REPAIR_COST_NSC_SDR(im,:)); 
        NSC_ACC_REPAIR_COST_PerIM(im,1)=sum(STORY_REPAIR_COST_NSC_ACC(im,:)); 
        REPAIR_COST_TOTAL_PerIM(im,1)=sum(STORY_REPAIR_COST(im,:));  
        cd (MainDirectory)

    end
    
    if rem(im,100)==0
        app.ProgressText.Value=['CALCULATING REPAIR LOSS ',num2str(round(im*100/nIMpoints)),'%'];
        app.ProgressBar.Position=[9 5 im/nIMpoints*613 6];
        drawnow
    end
end

% Add vulnearlability curves for individual compnenets
TOTAL_LOSSES_PerIM=COLLAPSE_LOSSES_Per_IM+DEMOLITION_LOSSES_Per_IM+ REPAIR_COST_TOTAL_PerIM;

cd (ProjectPath)
save(ProjectName,'DEAGG_DATA','-append');
pause(0.5);
save(ProjectName,'STORY_REPAIR_COST','STORY_REPAIR_COST_SC','STORY_REPAIR_COST_NSC_SDR','STORY_REPAIR_COST_NSC_ACC','-append');
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

    dMAF = abs(diff(MAF));

    EAL_COLLAPSE        = COLLAPSE_LOSSES_Per_IM'     * dMAF;
    EAL_DEMOLITION      = DEMOLITION_LOSSES_Per_IM'   * dMAF;
    EAL_REPAIR          = REPAIR_COST_TOTAL_PerIM'   * dMAF;
    EAL_REPAIR_SC       = SC_REPAIR_COST_PerIM'      * dMAF;
    EAL_REPAIR_NSC_SDR  = NSC_SDR_REPAIR_COST_PerIM' * dMAF;
    EAL_REPAIR_NSC_ACC  = NSC_ACC_REPAIR_COST_PerIM' * dMAF;

    EAL_TOTAL           = EAL_COLLAPSE + EAL_DEMOLITION + EAL_REPAIR;

    EAL(1,1) = EAL_COLLAPSE;
    EAL(1,2) = EAL_DEMOLITION;
    EAL(1,3) = EAL_REPAIR_SC;
    EAL(1,4) = EAL_REPAIR_NSC_SDR;
    EAL(1,5) = EAL_REPAIR_NSC_ACC;
    EAL(1,6) = EAL_TOTAL;

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

app.ProgressText.Value='SAVING LOSSES DATA';
pause(1);
app.ProgressText.Value='DONE';
app.ProgressText.FontColor='g';
app.VisualizeButton.Enable='on';
app.ReportButton.Enable='on';
app.ProgressBar.Position=[9 5 613 6];
app.ProgressBar.BackgroundColor='g';

LossDataStatus=1;

cd (ProjectPath)
save(ProjectName,'LossDataStatus','-append');
cd (MainDirectory)
end

