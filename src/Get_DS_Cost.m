function [DS_Cost]=Get_DS_Cost(FRAGDATA,IDXF,DSi)
    % Get DS Cost
    sigma_COST =     FRAGDATA.DS_Costsigma  (IDXF(DSi,1));  if sigma_COST==0.0; sigma_COST=0.001; end    % scaler value 
    fitfun_COST =    FRAGDATA.DS_CostFitFun (IDXF(DSi,1));                                               % string 
    if strcmp(fitfun_COST,'Normal')
        mu_COST    = 	 FRAGDATA.DS_Costmean(IDXF(DSi,1));         % scaler value
        DS_Cost    = abs(normrnd(mu_COST, sigma_COST*mu_COST,1,1)); % Random DSi cost  (scaler value)
    else
        mu_COST    = 	 FRAGDATA.DS_CostP50(IDXF(DSi,1));          % scaler value
        DS_Cost    = lognrnd(log(mu_COST), sigma_COST,1,1);         % Random DSi cost  (scaler value)                                
    end
end