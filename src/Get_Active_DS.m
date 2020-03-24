function [ActiveDS] = Get_Active_DS(FRAGDATA,Ci_nDS,IDXF,Ri_EDP)

ActiveDS=0; 

RndVar_P_DS=randi(100)/100;

% Loop over the component damage states
for DSi=1:Ci_nDS
    % Fragility lognormal curve population parameters for DSi
    mu_EDP     = FRAGDATA.DS_EDPmedian(IDXF(DSi,1));                                               % scaler value
    sigma_EDP  = FRAGDATA.DS_EDPsigma (IDXF(DSi,1));   if sigma_EDP ==0.0; sigma_EDP=0.001;  end   % scaler value 

    % if the damage states are simultaneous, then loop over all of them and sum up the repair cost of
    % each damage state...Note that a random variable is used for each DS to check it would occur or
    % not based on its chance of occurance
    if strcmp(FRAGDATA.DS_Hierarchy (IDXF(DSi,1)),'Simultaneous')==1
        P_DS_EDP   = logncdf(Ri_EDP, log(mu_EDP),    sigma_EDP);      % Probability of DSi   at the Realization EDP  (scaler value)
        RndVar_P_DSi=randi(100)/100;
        if RndVar_P_DS <= P_DS_EDP && RndVar_P_DSi <= FRAGDATA.DS_P (IDXF(DSi,1)) % first condition to check if DS will occur based on EDP fragility while the second condition to check if it occurs based on its chances DS_P
            ActiveDS=DSi; 
        end
        break;
    end

    % Get the Number of the Next Sequential DS
    for xx=DSi+1:Ci_nDS
        if strcmp(FRAGDATA.DS_Hierarchy (IDXF(xx,1)),'Sequential')==1
            DSiseq=xx;
            break;
        end
    end

    if DSi~=Ci_nDS
       mu_EDP_2     = FRAGDATA.DS_EDPmedian(IDXF(DSiseq,1));                                                    % scaler value
       sigma_EDP_2  = FRAGDATA.DS_EDPsigma (IDXF(DSiseq,1));   if sigma_EDP_2 ==0.0; sigma_EDP_2=0.001;  end    % scaler value 
    end

                    P_DS_EDP   = logncdf(Ri_EDP, log(mu_EDP),     sigma_EDP);     % Probability of DSi   at the Realization EDP  (scaler value)
    if DSi~=Ci_nDS; P_DS_EDP_2 = logncdf(Ri_EDP, log(mu_EDP_2),  sigma_EDP_2);    % Probability of DSseq at the Realization EDP  (scaler value)
    else;           P_DS_EDP_2 = 0;
    end

     % Check for being in current DS
    if RndVar_P_DS <= P_DS_EDP && RndVar_P_DS > P_DS_EDP_2
        % If the current DS is part of a mutually exclusive DS scenario, then a unifromly
        % distributed random variable to find which one you will be in
        if strcmp(FRAGDATA.DS_Hierarchy (IDXF(DSi,1)),'Mutually Exclusive')==1 && DSi~=Ci_nDS
            RndVar_P_DSseq=randi(100)/100;
            if RndVar_P_DSseq >= FRAGDATA.DS_P (IDXF(DSi,1))
                DSi=DSi+1;
            end
        end

        ActiveDS=DSi;
        break;
    end           
end