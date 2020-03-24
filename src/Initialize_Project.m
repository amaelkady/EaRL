function Initialize_Project(MainDirectory, ProjectPath, ProjectName, Units)

% Load Original Component and Fragility Library
load('COMPDATAORIGINAL.mat')
load('FRAGDATAORIGINAL.mat')

% modify DS cost units from feet to meters
if Units==2
    for i=1:size(FRAGDATA.C_name,1)
        if strcmp(FRAGDATA.DS_UnitType(i,1),'SF')==1
            FRAGDATA.DS_UnitVal(i,1)=round(FRAGDATA.DS_UnitVal(i,1)*0.3048^2*100)/100; % transform sq. foot to sq. meter
        end
        if strcmp(FRAGDATA.DS_UnitType(i,1),'LF')==1
            FRAGDATA.DS_UnitVal(i,1)=round(FRAGDATA.DS_UnitVal(i,1)*0.3048^1*100)/100; % transform foot to meter
        end
    end
end
if Units==1
    for i=1:size(FRAGDATA.C_name,1)
        if strcmp(FRAGDATA.DS_EDP(i,1),'PFV')==1
            FRAGDATA.DS_EDPmedian(i,1)=FRAGDATA.DS_EDPmedian(i,1)*39.3701; % transform m/sec to in/sec
        end
    end
end

cd (ProjectPath)
save(ProjectName, 'COMPDATA', 'FRAGDATA','Units')
cd (MainDirectory)

% Create porject directory and save inside it the intialized project data using
% ProjectData.mat file
BuildingDataStatus  = 0;
ComponentDataStatus = 0;
HazardDataStatus    = 0;
ResponseDataStatus  = 0;
LossDataStatus      = 0;
ResultsStatus       = 0;
Timestatus          = 0;
Placardstatus       = 0;
Casualtystatus      = 1;
PopModelstatus      = 0;
DemolitionStatus    = 0;
CollapseStatus      = 0;

Component_Data{1,1}='-';

IMstatus        = 0;
IMstart         = 0.001;
IMincr          = 0.005;
IMend           = 5.0;
IMpoints        = IMstart:IMincr:IMend;
nIMpoints       = size(IMpoints,2);
TargetIMstart   = IMstart;
TargetIMend     = IMend;
TargetIM        = IMpoints;
ResponseSA      = 1;
TargetIM_Option = 1;

nStripe         = 1;
N_GM            = 1;

Option5_Type = 0;
Option5Data.Option5_Type = 0;
Option5Data.N_GM = 1;
Option6Data.PGA  = 1;

TimeModel.Scheme         = 1;
TimeModel.SchemeSameComp = 1;
TimeModel.SchemeFloor    = 1;
EvalTimeOption           = 1;

Demolition_Option = 1;
DemolishMedianRDR = 10.0;
DemolishSigmaRDR  = 0.001;
DemolishMedianVRD = 1000.0;
DemolishSigmaVRD  = 0.001;
DemolishCorr      = 0.0;

CollapseSDR    = 0.2;
CPS_Option     = 0;
MedianCPS      = 10;
SigmaCPS       = 0.001;

RANGE.SDR     = [0:0.0001:0.05 0.0501:0.001:0.2 0.201:0.005:0.3];
RANGE.PFA     = [0.0:0.01:6.0];
RANGE.RDR     = RANGE.SDR;
RANGE.DWD     = RANGE.SDR;
RANGE.RD      = RANGE.SDR;
RANGE.ED      = RANGE.SDR;
RANGE.COLROT  = RANGE.SDR;
RANGE.BEAMROT = RANGE.SDR;
RANGE.LINKROT = RANGE.SDR;
RANGE.GENS1   = RANGE.SDR;
RANGE.GENS2   = RANGE.SDR;
RANGE.GENS3   = RANGE.SDR;
RANGE.GENF1   = RANGE.PFA;
RANGE.GENF2   = RANGE.PFA;
RANGE.GENF3   = RANGE.PFA;
if Units==1
    RANGE.VRD = [0:2:1000 1001:10:2000 2010:300:10000 10100:700:40000];
    RANGE.PFV = [0.0:0.1:180.0];
else
    RANGE.VRD = [0:0.1:50 51:0.5:100 105:1:200];
    RANGE.PFV = [0.0:0.01:6.0];
end

cd (ProjectPath)
save(ProjectName, 'BuildingDataStatus', 'ComponentDataStatus','HazardDataStatus','ResponseDataStatus','LossDataStatus', 'DemolitionStatus','CollapseStatus','Placardstatus','Casualtystatus','PopModelstatus','Component_Data','IMstatus','IMstart','IMincr','IMend','IMpoints','nIMpoints','TargetIMstart','TargetIMend','TargetIM','TargetIM_Option','ResultsStatus','nStripe','N_GM','Option5_Type','Option5Data','Option6Data','Timestatus','EvalTimeOption','TimeModel','-append')
save(ProjectName, 'Demolition_Option', 'DemolishMedianRDR','DemolishSigmaRDR','DemolishMedianVRD','DemolishSigmaVRD','DemolishCorr','CollapseSDR','CPS_Option','MedianCPS','SigmaCPS','ResponseSA','RANGE','-append')
cd (MainDirectory)

end