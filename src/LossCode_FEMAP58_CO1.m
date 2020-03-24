function LossCode_FEMAP58_CO1(app)
global MainDirectory ProjectPath ProjectName
cd (ProjectPath)
load (ProjectName)
cd (MainDirectory)

clear COLLAPSE_LOSSES_Per_IM DEMOLITION_LOSSES_Per_IM DEAGG_COMPONENT_REPAIR_COST

app.ProgressText.Value='INITIALIZING CODE';
app.ProgressText.FontColor='y';
app.ProgressBar.Position=[9 5 613 6];
app.ProgressBar.BackgroundColor='w';
pause(0.5);

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------  PRE-CALCULATIONS -----------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%

[errorFlag]=Check_Frag_Data (app,COMPDATA,FRAGDATA,C_Data); if errorFlag==1;  return; end

[REALIZATIONS]=Get_REALIZATIONS(app);

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------  LOSS DUE TO COLLAPSE  ------------------------------------------------------------%
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

DEAGG_DATA=0;

counter=1;

for im=1:nStripe                    % Loop over IM levels
    for Ri=1:nRealization           % Loop over realizations
        for n=1:N_Story+1           % Loop over stories/floors
            IDX=find(C_Data(:,2)==n | C_Data(:,2)==0); % Find the locations (i.e., row index) of the structural components that exit in story "n" or at typical story (i.e., story "0"). Save those indeces in vector IDX.
            for Ci=1:length(IDX)    % Loop over components
                
                rowINDEX=IDX(Ci,1);
                Ci_ID     = C_Data(rowINDEX,1);
                Ci_nUnits = C_Data(rowINDEX,3);
                Ci_nDS    = C_Data(rowINDEX,4);
                Ci_level  = C_Data(rowINDEX,5);
                
                IDXF=find(Ci_ID==FRAGDATA.C_ID); % Find the location (i.e., row index) of the current Ci in the FRAGDATA Matrix

                ActiveDScost=0; ActiveCnUnits=0; RepairCost=0; RepairTime=0;

                %% UNIVARIATE COMPONENT FRAGILITY
                if FRAGDATA.DS_FragType(IDXF(Ci_nDS,1))==111

                    if nStripe==1; [Ri_EDP]=Get_Realization_EDP_SI(FRAGDATA,IDXF,N_Story,Ci_level,REALIZATIONS,n,Ri,im); end
                    if nStripe~=1; [Ri_EDP]=Get_Realization_EDP_MS(FRAGDATA,IDXF,N_Story,Ci_level,REALIZATIONS,n,Ri,im); end
                    
                    % if the damage states are simultaneous, then loop over all of them and sum up the repair cost of each damage state...Note that a random variable is used for each DS to check it would occur or not based on its chance of occurance
                    if strcmp(FRAGDATA.DS_Hierarchy (IDXF(1,1)),'Simultaneous')==1
                        for DSi=1:Ci_nDS
                            [ActiveDS] = Get_Active_DS(FRAGDATA,Ci_nDS,IDXF,Ri_EDP);
                            if ActiveDS~=0
                                [DS_Cost]=Get_DS_Cost(FRAGDATA,IDXF,ActiveDS);
                                [DS_Time]=Get_DS_Time(FRAGDATA,IDXF,ActiveDS);
                                RepairCost = RepairCost + DS_Cost*Ci_nUnits * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)); %$   (scaler value)
                                RepairTime = RepairTime + DS_Time*Ci_nUnits * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)); %$   (scaler value)
                                ActiveDScost=DS_Cost; ActiveCnUnits=Ci_nUnits;
                            end
                        end
                    else
                        [ActiveDS] = Get_Active_DS(FRAGDATA,Ci_nDS,IDXF,Ri_EDP);
                        if ActiveDS~=0
                            % Get DS Cost and Time
                            [DS_Cost]=Get_DS_Cost(FRAGDATA,IDXF,ActiveDS);
                            [DS_Time]=Get_DS_Time(FRAGDATA,IDXF,ActiveDS);
                            RepairCost = DS_Cost*Ci_nUnits * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)); %$   (scaler value)                            
                            RepairTime = DS_Time*Ci_nUnits * (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)) * (1-DEMOLITION_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost)); %$   (scaler value)
                            ActiveDScost=DS_Cost; ActiveCnUnits=Ci_nUnits;
                        end
                    end
                             
                end

                [DEAGG_DATA]=Assemble_Deaggregated_Data(DEAGG_DATA,COMPDATA,counter,im,Ri,n,Ci_ID,Ri_EDP,ActiveDS,ActiveDScost,ActiveCnUnits,RepairCost,RepairTime,COLLAPSE_LOSSES_Per_Ri,DEMOLITION_LOSSES_Per_Ri);

                counter=counter+1;
            end
        end
    end
    app.ProgressText.Value=['CALCULATING REPAIR LOSS FOR ',num2str(nRealization), ' REALIZATIONS AT STRIPE #',num2str(im)];    app.ProgressBar.Position=[9 5 im/nStripe*613 6];  drawnow            
end

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%

[DEAGG_DATA]=Get_Casualty_and_Injury (app, DEAGG_DATA,EvalTimeOption,Occupancy,FRAGDATA,PopModel,Units);

if Placardstatus==1
    [DEAGG_DATA]=Get_Unsafe_Placard (app, DEAGG_DATA,FRAGDATA,REALIZATIONS);
end

cd (ProjectPath)
pause(0.5);
save(ProjectName,'DEAGG_DATA','REALIZATIONS','-append');
pause(0.5);
cd (MainDirectory)


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