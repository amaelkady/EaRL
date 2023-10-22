function [errorFlag]=Check_Frag_Data (app,COMPDATA,FRAGDATA,C_Data)

app.ProgressText.Value='PERFORMING PRE-COMPUTATIONS CHECKS'; app.ProgressBar.BackgroundColor='g'; app.ProgressBar.Position=[9 5 613 6]; drawnow;

errorFlag=0;

% Checking Component Fragiltiy Data are Defined
CIDs = unique(C_Data(:,1));
for Ci=1:size(CIDs,1)  % Loop over components
    Ci_ID     = CIDs(Ci,1);
    Ci_nDS    = COMPDATA.C_nDS(Ci_ID,1);
    IDXF=find(Ci_ID==FRAGDATA.C_ID); % Find the location (i.e., row index) of the current Ci in the FRAGDATA Matrix
    for DSi=1:Ci_nDS % Loop over the component damage states
        % Fragility lognormal curve population parameters for DSi
        mu_EDP      = 	  FRAGDATA.DS_EDPmedian (IDXF(DSi,1));  % scalar
        sigma_EDP   =     FRAGDATA.DS_EDPsigma  (IDXF(DSi,1));  % scalar 
        mu_Cost     =     FRAGDATA.DS_CostP50   (IDXF(DSi,1));  % scalar 
        sigma_Cost  =     FRAGDATA.DS_Costsigma (IDXF(DSi,1));  % scalar 
        if isnan(mu_EDP) || isnan(sigma_EDP)
            errorFlag=1;
            errordlg(['The damage fragility parameters for component #',num2str(Ci_ID),' need to be defined by user! Specify these parameters in the Damage Fragility Module']);
            app.ProgressText.Value='SPECIFY MISSING FRAGILITY PARAMETERS FIRST';
            app.ProgressText.FontColor='r';
            app.ProgressBar.BackgroundColor='r';
            return;
        end
        if isnan(mu_Cost) || isnan(sigma_Cost)
            errorFlag=1;
            errordlg(['The cost fragility parameters for component #',num2str(Ci_ID),' need to be defined by user! Specify these parameters in the Damage Fragility Module']);
            app.ProgressText.Value='SPECIFY MISSING FRAGILITY PARAMETERS FIRST';
            app.ProgressText.FontColor='r';
            app.ProgressBar.BackgroundColor='r';
            return;
        end
    end
end