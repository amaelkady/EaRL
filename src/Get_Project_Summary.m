function [SummaryText]=Get_Project_Summary
global MainDirectory ProjectPath ProjectName

clc
cd (ProjectPath);
load(ProjectName)
cd (MainDirectory);

if Units==2
    massUnit=' kN.sec2/m';
    dispUnit=' m';
    forceUnit=' kN';
    KUnit=' kN/m';
else
    massUnit=' kip.sec2/ft';    
    dispUnit=' ft';
    forceUnit=' kip';
    KUnit=' kip/ft';
end

i=1;
SummaryText{i}='******************************************************';i=i+1;
SummaryText{i}='******************************************************';i=i+1;
SummaryText{i}='                    PROJECT SUMMARY                   ';i=i+1;
SummaryText{i}='******************************************************';i=i+1;
SummaryText{i}='******************************************************';i=i+1;
SummaryText{i}='';i=i+1;

if BuildingDataStatus~=1
    SummaryText{i}='NO PROJECT DATA ARE DEFINED YET';i=i+1;    
end

if Units==1
    SummaryText{i}='Units: Imperial';i=i+1;
else
    SummaryText{i}='Units: SI';i=i+1;
end
SummaryText{i}='';i=i+1;

if BuildingDataStatus==1
    SummaryText{i}='BUILDING DESCRIPTION';i=i+1;
    SummaryText{i}='------------------------------------------------------';i=i+1;
    SummaryText{i}=char(BuildingDescription);i=i+1;
    SummaryText{i}='';i=i+1;
    SummaryText{i}='BUILDING DATA';i=i+1;
    SummaryText{i}='------------------------------------------------------';i=i+1;
    SummaryText{i}=['Occupancy: ', OccupancyName];i=i+1;
    SummaryText{i}=['Construction Material: ', Material{1,1}, Material{1,2}, Material{1,3}, Material{1,4}];i=i+1;
    SummaryText{i}=['System Type: ', System_Type{1,1}];i=i+1;
    SummaryText{i}=['No. of Stories: ', num2str(N_Story)];i=i+1;
    SummaryText{i}=['Foot Print Area: ', num2str(Area_FootPrint), dispUnit,'2'];i=i+1;
    SummaryText{i}=['Total Foot Print Area: ', num2str(Area_Total), dispUnit,'2'];i=i+1;
    SummaryText{i}=['Demolition  Cost: ', num2str(Demolition_Cost/1000000), 'M$'];i=i+1;
    SummaryText{i}=['Replacement Cost: ', num2str(Replacement_Cost/1000000), 'M$'];i=i+1;
    SummaryText{i}='------------------------------------------------------';i=i+1;
end

SummaryText{i}='';i=i+1;

if ComponentDataStatus==1
    SummaryText{i}='COMPONENT DEFINITION';i=i+1;
    SummaryText{i}='------------------------------------------------------';i=i+1;
    if Component_Option==1
        SummaryText{i}=['Defined Components:'];i=i+1;
        Unique_Component_Names = unique(Component_Data(:,2));
        for j=1:size(Unique_Component_Names,1)
            SummaryText{i}=['  -', Unique_Component_Names{j,1}];i=i+1;
        end
    elseif Component_Option==2
        SummaryText{i}=['Loss-EDP Functions by Papadopoulos et al (2018)'];i=i+1;
        SummaryText{i}=['Structural System: ', StructuralSystemName];i=i+1;
        SummaryText{i}=['Luxury Level: ', Luxury_Level_Name];i=i+1;
    elseif Component_Option==3
        SummaryText{i}=['Loss-EDP Functions by Ramirez & Miranda (2009)'];i=i+1;
        if FrameType==1; SummaryText{i}=['Frame Type: Perimeter Frame'];i=i+1; end
        if FrameType==2; SummaryText{i}=['Frame Type: Space Frame'];i=i+1; end
        if DuctilityType==1; SummaryText{i}=['Ductility: Ductile'];i=i+1; end
        if DuctilityType==2; SummaryText{i}=['Ductility: Non-Ductile'];i=i+1; end
    end
    SummaryText{i}='------------------------------------------------------';i=i+1;
end

SummaryText{i}='';i=i+1;

if ResponseDataStatus==1
    SummaryText{i}=['RESPONSE DATA'];i=i+1;
    SummaryText{i}='------------------------------------------------------';i=i+1;
    if Response_Option==1
        SummaryText{i}='Response Data - IDA Data';i=i+1;
        SummaryText{i}=['Response Data Folder Directory: '];i=i+1;
        SummaryText{i}=[ResponseDataFolderPath];i=i+1;
    elseif Response_Option==2
        SummaryText{i}='Response Data - Single Intensity for Multiple GMs';i=i+1;
        SummaryText{i}=['Response Data Excel Filename: ',NRHADataExcelFileName];i=i+1;
        SummaryText{i}=['IM level: ',num2str(TargetIM(1,1)), 'g'];i=i+1;
        SummaryText{i}=['Number of GMs: ', num2str(N_GM)];i=i+1;
    elseif Response_Option==3
        SummaryText{i}='Response Data - Single Intensity (Distribution Parameters)';i=i+1;
        SummaryText{i}=['IM level: ', num2str(TargetIM(1,1)), 'g'];i=i+1;
    elseif Response_Option==4
        SummaryText{i}='Response Data - Multiple Stripes';i=i+1;     
        SummaryText{i}=['Response Data Excel Filename: '];i=i+1;
        SummaryText{i}=[NRHADataExcelFileName];i=i+1;
        SummaryText{i}=['Number of GMs: ',num2str(N_GM)];i=i+1;
        SummaryText{i}=['Number of Stripes: ',num2str(nStripe)];i=i+1;
    elseif Response_Option==5
        v2struct(Option5Data)
        SummaryText{i}='MDoF Shear Model';i=i+1;
        if ModelType==1; SummaryText{i}=['System Behavior: Elastic'];i=i+1; end
        if ModelType==2; SummaryText{i}=['System Behavior: Bi-Linear'];i=i+1; end
        if ModelType==3; SummaryText{i}=['System Behavior: IMK Bilinear'];i=i+1; end
        if ModelType==4; SummaryText{i}=['System Behavior: IMK PeakOriented'];i=i+1; end
        SummaryText{i}=['System Response Excel Filename: ', char(ExcelFileName)];i=i+1;
        SummaryText{i}=['GM Folder Name: ',GMFolderName];i=i+1;
        SummaryText{i}=['Number of GMs: ', num2str(N_GM)];i=i+1;
        if Option5_Type==1
            SummaryText{i}=['Analysis Type: IDA'];i=i+1;
            SummaryText{i}=['Scale Period: ', num2str(T1),'sec'];i=i+1; 
            SummaryText{i}=['Damping: ', num2str(zeta*100),'%'];i=i+1; 
        end
        if Option5_Type==2
            SummaryText{i}=['Analysis Type: Target GM Scale Factor'];i=i+1; 
            SummaryText{i}=['Target Scale Factor: ', num2str(SF)];i=i+1; 
            SummaryText{i}=['Damping: ', num2str(zeta*100),'%'];i=i+1; 
        end
        if Option5_Type==3
            SummaryText{i}=['Analysis Type: Target IM Level'];i=i+1; 
            SummaryText{i}=['Target IM: ', num2str(TargetIM(1,1)),'g'];i=i+1; 
            SummaryText{i}=['Scale Period: ', num2str(T1),'sec'];i=i+1; 
            SummaryText{i}=['Damping: ', num2str(zeta*100),'%'];i=i+1; 
        end
    elseif Response_Option==6
        v2struct(Option6Data)
        SummaryText{i}='FEMA P-58 Simplified Analysis Method';i=i+1;
        SummaryText{i}=['System Response Excel Filename: ',char(ExcelFileName)];i=i+1;
        SummaryText{i}=['T1: ',num2str(T1),'sec'];i=i+1;
        SummaryText{i}=['PGA: ',num2str(PGA),'g'];i=i+1;
        SummaryText{i}=['Sa(T1): ',num2str(SaT1),'g'];i=i+1;
        SummaryText{i}=['Vy: ',num2str(Vy1),forceUnit];i=i+1;
        SummaryText{i}=['SDRy: ',num2str(SDRy*100),'% rad'];i=i+1;
    end
    SummaryText{i}='------------------------------------------------------';i=i+1;
end

SummaryText{i}='';i=i+1;

if HazardDataStatus==1
    SummaryText{i}=['SEISMIC HAZARD'];i=i+1;
    SummaryText{i}='------------------------------------------------------';i=i+1;
    if HazardOption==1
        SummaryText{i}='USGS Hazard Maps';i=i+1;
        SummaryText{i}=['Longitude: ',num2str(Longitude), ' degrees'];i=i+1;
        SummaryText{i}=['Latitude: ',num2str(Latitude), ' degrees'];i=i+1;
        SummaryText{i}=['Period: ',num2str(T1),' sec'];i=i+1;
        SummaryText{i}=['Soil Shear Wave Velocity: ',num2str(Vs30),' m/sec'];i=i+1;
        SummaryText{i}='------------------------------------------------------';i=i+1;
    else
        SummaryText{i}='Seismic hazard curve imported by the user';i=i+1;        
    end
end

SummaryText{i}='';i=i+1;

SummaryText{i}=['IM BINS'];i=i+1;
SummaryText{i}='------------------------------------------------------';i=i+1;
SummaryText{i}=['Initial Intensity: ', num2str(IMstart), 'g'];i=i+1;    
SummaryText{i}=['Incr.   Intensity: ', num2str(IMincr), 'g'];i=i+1;    
SummaryText{i}=['Last    Intensity: ', num2str(IMend), 'g'];i=i+1;    
if TargetIM_Option==1
    SummaryText{i}=['Target  Intensity: All Intensity Range'];i=i+1;    
elseif TargetIM_Option==2
    SummaryText{i}=['Target  Intensity: ', num2str(TargetIMstart), 'g to ',num2str(TargetIMend),'g'];i=i+1;    
elseif TargetIM_Option==3
    SummaryText{i}=['Target  Intensity: ', num2str(TargetIMstart), 'g'];i=i+1;    
end

SummaryText{i}='';i=i+1;

SummaryText{i}=['DEMOLITION PARAMETERS'];i=i+1;
SummaryText{i}='------------------------------------------------------';i=i+1;
if Demolition_Option==1
    SummaryText{i}=['Demolition Event is Not Considered'];i=i+1;
end
if Demolition_Option==2
    SummaryText{i}=['Univariate Demolition Fragility'];i=i+1;
    SummaryText{i}=['Median RDR: ', num2str(DemolishMedianRDR), ' rad'];i=i+1;    
    SummaryText{i}=['Sigma ln(RDR): ', num2str(DemolishSigmaRDR)];i=i+1;    
end
if Demolition_Option==3
    SummaryText{i}=['Bivariate Demolition Fragility'];i=i+1;
    SummaryText{i}=['Median RDR: ', num2str(DemolishMedianRDR), ' rad'];i=i+1;    
    SummaryText{i}=['Sigma ln(RDR): ', num2str(DemolishSigmaRDR)];i=i+1;   
    SummaryText{i}=['Median VRD: ', num2str(DemolishMedianVRD), ' mm'];i=i+1;    
    SummaryText{i}=['Sigma ln(VRD): ', num2str(DemolishSigmaVRD)];i=i+1;   
    SummaryText{i}=['Correlation: ', num2str(DemolishCorr)];i=i+1;   
end

SummaryText{i}='';i=i+1;

SummaryText{i}=['COLLAPSE PARAMETERS'];i=i+1;
SummaryText{i}='------------------------------------------------------';i=i+1;
if CPS_Option==0
    SummaryText{i}=['Collapse Event is Not Considered'];i=i+1;
end
if CPS_Option==1 || CPS_Option==2 || CPS_Option==3
    SummaryText{i}=['Univariate Collapse Fragility'];i=i+1;
    if CPS_Option==1; SummaryText{i}=['Fragility parameters deduced from IDA data'];i=i+1; end
    if CPS_Option==2; SummaryText{i}=['Fragility parameters specified directly'];i=i+1; end
    if CPS_Option==3; SummaryText{i}=['Fragility parameters specified indirectly using a point on the curve'];i=i+1; end
    SummaryText{i}=['Median IM: ', num2str(MedianCPS), ' g'];i=i+1;    
    SummaryText{i}=['Sigma    : ', num2str(SigmaCPS)];i=i+1;    
end

SummaryText{i}='';i=i+1;

SummaryText{i}='******************************************************';i=i+1;
SummaryText{i}='******************************************************';i=i+1;
