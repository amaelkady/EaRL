function [ActiveDS] = Get_Active_DS(FRAGDATA,Ci_nDS,IDXF,Ri_EDP)

% This code still does not consider cases of where mutually exclusive DSs
% are nested with Sequential ones

ActiveDS=0;

RndVar_P_DS=randi(100)/100;

%% FEMA P-58-1 Section 7.5.3
if strcmp(FRAGDATA.DS_Hierarchy (IDXF(1,1)),'Simultaneous')==1

    % Fragility lognormal curve population parameters for DSi (note that for the simultanous case, the EDP fragility is the same for all DS)
    mu_EDP     = FRAGDATA.DS_EDPmedian(IDXF(1,1));                                               % scaler value
    sigma_EDP  = FRAGDATA.DS_EDPsigma (IDXF(1,1));   if sigma_EDP ==0.0; sigma_EDP=0.001;  end   % scaler value

    P_DS_EDP   = logncdf(Ri_EDP, log(mu_EDP),    sigma_EDP);      % Probability of DS occurance at the Realization EDP  (scaler value)

    if RndVar_P_DS <= P_DS_EDP         % Check if DS will occur based on EDP fragility (note that for the simultanous case, the EDP fragility is the same for all DS)
        
        while max(ActiveDS)==0
            RndVar_P_DSi=randi(100)/100;    % Given that damage has occurred, a second random number is selected for each possible damage state to determine if one or more of the simultaneous damages states have occurred.
            for DSi=1:Ci_nDS

                if RndVar_P_DSi <= FRAGDATA.DS_P (IDXF(DSi,1)) % second condition to check which DSs will occur
                    ActiveDS=[ActiveDS DSi];                    % one or more of the simultaneous damages states may occurr
                end

            end
        end

        ActiveDS(1)=[]; % remove the initioal DS=0 value

    else
        ActiveDS=0; % No damage
    end


    %% FEMA P-58-1 Section 7.5.1

elseif strcmp(FRAGDATA.DS_Hierarchy (IDXF(1,1)),'Sequential')==1

    % Loop over the component damage states
    for DSi=1:Ci_nDS

        % Fragility lognormal curve population parameters for DSi
        mu_EDP     = FRAGDATA.DS_EDPmedian(IDXF(DSi,1));                                               % scaler value
        sigma_EDP  = FRAGDATA.DS_EDPsigma (IDXF(DSi,1));   if sigma_EDP ==0.0; sigma_EDP=0.001;  end   % scaler value

        % Probability of DSi at the Realization EDP
        P_DSi_EDP (DSi,1)   = logncdf(Ri_EDP, log(mu_EDP),     sigma_EDP);     

    end
        
    % Probability inverse
    P_DSi_EDP_inv = 1 - P_DSi_EDP;
    try 
        ActiveDS = interp1(P_DSi_EDP_inv, 1:Ci_nDS, RndVar_P_DS, 'next');
    catch
        ActiveDS = NaN;
    end
    if isnan(ActiveDS) 
        if RndVar_P_DS <= P_DSi_EDP_inv(1)
            ActiveDS=1;       
        elseif RndVar_P_DS >= P_DSi_EDP_inv(end)
            ActiveDS=Ci_nDS;
        else
            ActiveDS = 1;
        end
    end

    %% FEMA P-58-1 Section 7.5.1

elseif strcmp(FRAGDATA.DS_Hierarchy (IDXF(1,1)),'Mutually Exclusive')==1

    for DSi = 1 : Ci_nDS
         DS_P(DSi,1) = DSi;    
         DS_P(DSi,2) = FRAGDATA.DS_P (IDXF(DSi,1));    
    end

    DS_P = sortrows(DS_P,2); % sort array in ascending order based on DS_P values

    DS_P_Cumm = cumsum(DS_P(:,2));  % get the cummaltive probability

    ActiveDS = interp1(DS_P_Cumm, DS_P(:,1), RndVar_P_DS, 'next');

    if isnan(ActiveDS); ActiveDS=1; end

end