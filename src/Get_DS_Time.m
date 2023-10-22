function [DS_Time]=Get_DS_Time(FRAGDATA,IDXF,DSi)
    sigma =     FRAGDATA.DS_Timesigma  (IDXF(DSi,1));  if sigma==0.0; sigma=0.001; end    % scaler value 
    fitfun =    FRAGDATA.DS_TimeFitFun (IDXF(DSi,1));                                     % string 
    if strcmp(fitfun,'Normal')
        mu      = FRAGDATA.DS_Timemean(IDXF(DSi,1));    % scaler value
        DS_Time = abs(normrnd(mu, sigma*mu,1,1));       % Random DSi cost  (scaler value)
    else
        mu      = FRAGDATA.DS_TimeP50(IDXF(DSi,1));     % scaler value
        DS_Time = lognrnd(log(mu), sigma,1,1);          % Random DSi cost  (scaler value)                                
    end
end