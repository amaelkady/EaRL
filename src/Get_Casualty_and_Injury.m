function [DEAGG_DATA]=Get_Casualty_and_Injury (app, DEAGG_DATA,EvalTimeOption,Occupancy,FRAGDATA,PopModel,Units)

app.ProgressText.Value='ESTIMATING CASUALTIES & INJURIES'; drawnow

if Units==1; feet2meter=1.0;     end
if Units==2; feet2meter=1/3.28084; end

if EvalTimeOption==1
    Day=randi(7);           %value from 1 to 7
    if Day==6 || Day==7; PopModel.weekendflag=1; else; PopModel.weekendflag=0; end % 6 & 7->weekend 1 to 5-->working day
    PopModel.PopHour=randi(24);      %value from 1 to 24
    PopModel.PopMonth=randi(12);     %value from 1 to 12
else
    if PopModel.PopDay==2; PopModel.weekendflag=1; else; PopModel.weekendflag=0; end
end

PeakPop               = PopModel.PeakPop;
PeakPopArea           = PopModel.PeakPopArea;
PercentPopPerTime     = PopModel.PopVarPerHourDay(PopModel.PopHour,PopModel.weekendflag+1) * PopModel.PopVarPerMonth(PopModel.PopMonth,PopModel.weekendflag+1);
PopPerUnitAreaPerTime = PercentPopPerTime * PeakPop/PeakPopArea;


for i=1: size(DEAGG_DATA,1)
    Ci_ID    = DEAGG_DATA(i,3);
    ActiveDS = DEAGG_DATA(i,8); if ActiveDS==0; ActiveDS=1; end
    nUnits   = DEAGG_DATA(i,10);
    IDXC     = find(Ci_ID==FRAGDATA.C_ID);
    IDXDS    = IDXC(ActiveDS);
    
    nOccupantsPerAffectedArea = PopPerUnitAreaPerTime * FRAGDATA.DS_AffectArea(IDXDS,1) * feet2meter^2 * nUnits;
    if  strcmp(FRAGDATA.DS_Casualty{IDXDS,1},'YES')==1
        mu_Casualty     = FRAGDATA.DS_CasualtyRatemedian(IDXDS,1);
        sigma_Casualty  = FRAGDATA.DS_CasualtyRatesigma(IDXDS,1); if sigma_Casualty==0.0; sigma_Casualty=0.001; end
        CasualtyRate    = abs(normrnd(mu_Casualty, sigma_Casualty*mu_Casualty,1,1));
        nCasualty       = round(CasualtyRate * nOccupantsPerAffectedArea);
    else
        nCasualty=0.0;
    end
    
    mu_Injury       = FRAGDATA.DS_InjuryRatemedian(IDXDS,1);
    sigma_Injury    = FRAGDATA.DS_InjuryRatesigma(IDXDS,1); if sigma_Injury==0.0; sigma_Injury=0.001; end
    InjuryRate      = abs(normrnd(mu_Injury, sigma_Injury*mu_Injury,1,1));
    nInjury         = round(InjuryRate * nOccupantsPerAffectedArea);
    
    if isnan(nInjury); nInjury=0; end
    DEAGG_DATA(i,13)=nInjury;
    DEAGG_DATA(i,14)=nCasualty;
    
end