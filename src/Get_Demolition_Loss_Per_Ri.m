function [DEMOLITION_LOSSES_Per_Ri] = Get_Demolition_Loss_Per_Ri(app,Demolition_Option,nRealization,nStripe,RANGE,DemolishMedianRDR,DemolishSigmaRDR,DemolishMedianVRD,DemolishSigmaVRD,DemolishCorr,REALIZATIONS,Demolition_Cost,Replacement_Cost,COLLAPSE_LOSSES_Per_Ri)

app.ProgressText.Value='CALCULATING DEMOLITION LOSS DUE TO RESIDUAL DEFORMATIONS'; drawnow

                          MIDPTS.RDR=RANGE.RDR(1:end-1)+diff(RANGE.RDR)/2;
if Demolition_Option==3;  MIDPTS.VRD=RANGE.VRD(1:end-1)+diff(RANGE.VRD)/2;   else; MIDPTS.VRD=0; end

% Get the CDF of the Demolition Fragility
if Demolition_Option==2 
    CDF_Demolition  = logncdf(MIDPTS.RDR,log(DemolishMedianRDR),DemolishSigmaRDR);
    CDF_Demolition  = CDF_Demolition';
elseif Demolition_Option==3
    [CDF_Demolition, PDF_Demolition]  =  Get_CorrBivariateDemolitionCDF(MIDPTS.RDR,MIDPTS.VRD,DemolishMedianRDR,DemolishSigmaRDR,DemolishMedianVRD,DemolishSigmaVRD,DemolishCorr);
end

DEMOLITION_LOSSES_Per_Ri = zeros(nRealization,nStripe);

if Demolition_Option~=1 
    for im=1:nStripe            % Loop over IM levels
        for Ri=1:nRealization   % Loop over realizations
            
            if Demolition_Option==1
                Pr_Demolition_per_Ri(Ri,im)=0.0;
            elseif Demolition_Option==2
                indxRDR=length(MIDPTS.RDR);
                for k=1:length(MIDPTS.RDR)
                    if nStripe==1; rdrRi=REALIZATIONS.RDR(Ri,1); else; evalc(['rdrRi=REALIZATIONS.RDR_S',num2str(im),'(Ri,1)']); end
                    if rdrRi<=MIDPTS.RDR(k)
                        indxRDR=k;
                        break
                    end
                end
                evalc(['Pr_Demolition_per_Ri(Ri,im)=CDF_Demolition(indxRDR,1)']);
            elseif Demolition_Option==3
                indxRDR=length(MIDPTS.RDR);
                indxVRD=length(MIDPTS.VRD);

                for k=1:length(MIDPTS.RDR)
                    if nStripe==1; rdrRi=REALIZATIONS.RDR(Ri,1); else; evalc(['rdrRi=REALIZATIONS.RDR_S',num2str(im),'(Ri,1)']); end
                    if rdrRi<=MIDPTS.RDR(k)
                        indxRDR=k;
                    break
                    end
                end
                for k=1:length(MIDPTS.VRD)
                    if nStripe==1; vrdRi=REALIZATIONS.VRD(Ri,1); else; evalc(['vrdRi=REALIZATIONS.VRD_S',num2str(im),'(Ri,1)']); end
                    if vrdRi<=MIDPTS.VRD(k)
                        indxVRD=k;
                    break
                    end
                end
                evalc(['Pr_Demolition_per_Ri(Ri,im)=CDF_Demolition(indxRDR,indxVRD)']);
            end

            RndVar_P_Demolition=randi(100)/100;
            if RndVar_P_Demolition<=Pr_Demolition_per_Ri(Ri,im)
                DEMOLITION_LOSSES_Per_Ri(Ri,im)=1 * (Demolition_Cost+Replacement_Cost)* (1-COLLAPSE_LOSSES_Per_Ri(Ri,im)/(Demolition_Cost+Replacement_Cost));
            else
                DEMOLITION_LOSSES_Per_Ri(Ri,im)=0;
            end
        end
        
        app.ProgressText.Value=['CALCULATING DEMOLITION LOSS AT STRIPE #',num2str(im)];   app.ProgressBar.Position=[9 5 im/nStripe*613 6];    drawnow;
        
    end
end