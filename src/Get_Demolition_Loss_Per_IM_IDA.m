
function [DEMOLITION_LOSSES_Per_IM,Pr_Demolition_per_IM]=Get_Demolition_Loss_Per_IM_IDA(app,Demolition_Option,IMpoints,MEDIAN_IM,SIGMA_IM,RANGE,MIDPTS,DemolishMedianRDR,DemolishSigmaRDR,DemolishMedianVRD,DemolishSigmaVRD,DemolishCorr,Demolition_Cost,Replacement_Cost,Pr_Collapse_per_IM,TargetIM)


app.ProgressText.Value='CALCULATING DEMOLITION LOSS DUE TO RESIDUAL DEFORMATIONS'; drawnow;
    
nIMpoints=length(IMpoints);

% Get the CDF of the Demolition Fragility
if Demolition_Option==2 % i.e., No Demolition OR RDR-Based Demolition
    CDF_Demolition  = logncdf(MIDPTS.RDR,log(DemolishMedianRDR),DemolishSigmaRDR);
elseif Demolition_Option==3
    [CDF_Demolition_Capacity, PDF_Demolition_Capacity]  =  Get_CorrBivariateDemolitionCDF(MIDPTS.SDR,MIDPTS.VRD,DemolishMedianRDR,DemolishSigmaRDR,DemolishMedianVRD,DemolishSigmaVRD,DemolishCorr); % New COde
end

app.ProgressBar.Position=[9 5 0.5*613 6];
drawnow

Pr_Demolition_per_IM=zeros(nIMpoints,1);
for im=1:nIMpoints
    if IMpoints(1,im)>= min(TargetIM) && IMpoints(1,im)<= max(TargetIM)
        if Demolition_Option==1 
            Pr_Demolition_per_IM(im,1) = 0.0;
        elseif Demolition_Option==2 % i.e., No Demolition OR RDR-Based Demolition
            CDF_RDR_Demand      = logncdf(RANGE.RDR,log(MEDIAN_IM.RDR(im,1)),SIGMA_IM.RDR(im,1));
            PDF_RDR_Demand      = abs(diff(CDF_RDR_Demand));
            Pr_Demolition_per_IM(im,1) = CDF_Demolition * PDF_RDR_Demand';
        elseif Demolition_Option==3
            [CDF_Demolition_Demand, PDF_Demolition_Demand]  = Get_CorrBivariateDemolitionCDF(MIDPTS.RDR,MIDPTS.VRD,MEDIAN_IM.RDR(im,1),SIGMA_IM.RDR(im,1),MEDIAN_IM.VRD(im,1),SIGMA_IM.VRD(im,1),Correlation(im,1));

            Pr_Demolition=0;
            for x=1:size(CDF_Demolition_Capacity,1)
                for y=1:size(CDF_Demolition_Capacity,2)
                    Pr_Demolition = Pr_Demolition+ PDF_Demolition_Demand(x,y) * CDF_Demolition_Capacity(x,y);
                end
            end
            Pr_Demolition_per_IM(im,1)=Pr_Demolition;
        end
    end
 
end

app.ProgressBar.Position=[9 5 613 6]; drawnow  ; 
    
Pr_Demolition_Net_per_IM  = Pr_Demolition_per_IM.* (1-Pr_Collapse_per_IM);
DEMOLITION_LOSSES_Per_IM   = Pr_Demolition_Net_per_IM * (Demolition_Cost+Replacement_Cost); % Calculate Demolition Cost

