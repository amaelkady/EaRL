
function [DEMOLITION_LOSSES_Per_IM,Pr_Demolition_per_IM]=Get_Demolition_Loss_Per_IM(app,Demolition_Option,IMpoints,nStripe,EDP_Data,RANGE,MIDPTS,DemolishMedianRDR,DemolishSigmaRDR,DemolishMedianVRD,DemolishSigmaVRD,DemolishCorr,Demolition_Cost,Replacement_Cost,Pr_Collapse_per_IM,TargetIM)


app.ProgressText.Value='CALCULATING DEMOLITION LOSS DUE TO RESIDUAL DEFORMATIONS';
app.ProgressBar.Position=[9 5 0.5*613 6];
drawnow

nIMpoints=length(IMpoints);

if Demolition_Option==1 
    Pr_Demolition_per_IM=zeros(nIMpoints,1);
else
    % Get the CDF of the Demolition Fragility
    if Demolition_Option==2 % i.e., No Demolition OR RDR-Based Demolition
        CDF_Demolition  = logncdf(MIDPTS.RDR,log(DemolishMedianRDR),DemolishSigmaRDR);
    elseif Demolition_Option==3
        [CDF_Demolition_Capacity, PDF_Demolition_Capacity]  =  Get_CorrBivariateDemolitionCDF(MIDPTS.RDR,MIDPTS.VRD,DemolishMedianRDR,DemolishSigmaRDR,DemolishMedianVRD,DemolishSigmaVRD,DemolishCorr); % New COde
    end

    Pr_Demolition_per_IM=zeros(nIMpoints,1);
    Stripe=0;
    for im=1:nIMpoints
        if ismember(IMpoints(1,im),TargetIM)
            Stripe=Stripe+1;
            if Demolition_Option==1 
                Pr_Demolition_per_IM(im,1) = 0.0;
            elseif Demolition_Option==2 % i.e., No Demolition OR RDR-Based Demolition
                evalc(['MedianRDR=EDP_Data.RDRmedian.S',num2str(Stripe)]);
                evalc(['SigmaRDR=EDP_Data.RDRsigma.S',num2str(Stripe)]);
                CDF_RDR_Demand      = logncdf(RANGE.RDR,log(MedianRDR),SigmaRDR);
                PDF_RDR_Demand      = abs(diff(CDF_RDR_Demand));
                Pr_Demolition_per_IM(im,1) = CDF_Demolition * PDF_RDR_Demand';
            elseif Demolition_Option==3
                evalc(['MedianRDR=EDP_Data.RDRmedian.S',num2str(Stripe)]);
                evalc(['SigmaRDR=EDP_Data.RDRsigma.S',num2str(Stripe)]);
                evalc(['MedianVRD=EDP_Data.VRDmedian.S',num2str(Stripe)]);
                evalc(['SigmaVRD=EDP_Data.VRDsigma.S',num2str(Stripe)]);
                [CDF_Demolition_Demand, PDF_Demolition_Demand]  = Get_CorrBivariateDemolitionCDF(MIDPTSRDR,MIDPTSVRD,MedianRDR,SigmaRDR,MedianVRD,SigmaVRD,Correlation(im,1));

                Pr_Demolition=0;
                for x=1:size(CDF_Demolition_Capacity,1)
                    for y=1:size(CDF_Demolition_Capacity,2)
                        Pr_Demolition = Pr_Demolition+ PDF_Demolition_Demand(x,y) * CDF_Demolition_Capacity(x,y);
                    end
                end
                Pr_Demolition_per_IM(im,1)=Pr_Demolition;
            end
            app.ProgressText.Value=['CALCULATING DEMOLITION LOSS AT STRIPE #',num2str(Stripe)];   app.ProgressBar.Position=[9 5 Stripe/nStripe*613 6];    drawnow;
            app.ProgressBar.Position=[9 5 Stripe/nStripe*613 6]; drawnow;   
        end
    end
end

Pr_Demolition_Net_per_IM  = Pr_Demolition_per_IM.* (1-Pr_Collapse_per_IM);
DEMOLITION_LOSSES_Per_IM   = Pr_Demolition_Net_per_IM * (Demolition_Cost+Replacement_Cost); % Calculate Demolition Cost

