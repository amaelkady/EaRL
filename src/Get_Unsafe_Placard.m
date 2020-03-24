function [DEAGG_DATA]=Get_Unsafe_Placard (app, DEAGG_DATA,FRAGDATA,REALIZATIONS)

app.ProgressText.Value='ESTIMATING UNSAFE PLACARD PROBABILITY'; drawnow

nStripe=DEAGG_DATA(end,1);
nRealizations=max(DEAGG_DATA(end,6));
N_Story=max(DEAGG_DATA(:,2))-1;

for i=1: size(DEAGG_DATA,1)
    
    Ci_ID    = DEAGG_DATA(i,3);
    nUnits   = DEAGG_DATA(i,10);
    IDXF     = find(Ci_ID==FRAGDATA.C_ID);
    EDP_Type = FRAGDATA.DS_EDPmedian(IDXF(1,1));
    Ci_nDS   = length (IDXF);
    
    if strcmp(EDP_Type,'SDR') || strcmp(EDP_Type,'DWD') || strcmp(EDP_Type,'COLROT') || strcmp(EDP_Type,'RD') || strcmp(EDP_Type,'ED') || strcmp(EDP_Type,'RDR') || strcmp(EDP_Type,'GENS1') || strcmp(EDP_Type,'GENS2') || strcmp(EDP_Type,'GENS2') || strcmp(EDP_Type,'ED')
        Ci_level=1;
    else
        Ci_level=2;
    end
    
    CountPlacardFlag=0; 
    
    for Uniti=1:nUnits
        
        ActiveDS=0;
        RndVar_P_DS=randi(100)/100;
        
        Stripe  = DEAGG_DATA(i,1);
        Ri      = DEAGG_DATA(i,6);
        n       = DEAGG_DATA(i,2);

        %% UNIVARIATE COMPONENT FRAGILITY
        if FRAGDATA.DS_FragType(IDXF(1,1))==111

            if nStripe==1; [Ri_EDP]=Get_Realization_EDP_SI(FRAGDATA,IDXF,N_Story,Ci_level,REALIZATIONS,n,Ri,Stripe); end
            if nStripe~=1; [Ri_EDP]=Get_Realization_EDP_MS(FRAGDATA,IDXF,N_Story,Ci_level,REALIZATIONS,n,Ri,Stripe); end

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
                    for DSi=1:Ci_nDS
                        RndVar_P_DSi=randi(100)/100;
                        if RndVar_P_DS <= P_DS_EDP && RndVar_P_DSi <= FRAGDATA.DS_P (IDXF(DSi,1)) % first condition to check if DS will occur based on EDP fragility while the second condition to check if it occurs based on its chances DS_P
                           ActiveDS=DSi;
                        end
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

                                P_DS_EDP   = logncdf(Ri_EDP, log(mu_EDP),    sigma_EDP);      % Probability of DSi   at the Realization EDP  (scaler value)
                if DSi~=Ci_nDS; P_DS_EDP_2 = logncdf(Ri_EDP, log(mu_EDP_2),  sigma_EDP_2);    % Probability of DSseq at the Realization EDP  (scaler value)
                else;           P_DS_EDP_2 = 0;
                end

                % Check for being in current DS and compute repair cost if so
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
        end

        if ActiveDS~=0
            if strcmp(FRAGDATA.DS_UnsafePlacardFlag(IDXF(ActiveDS,1)),'YES')==1; CountPlacardFlag=CountPlacardFlag+1;   end
        end
    end
    DEAGG_DATA(i,15)=CountPlacardFlag;
    if CountPlacardFlag/nUnits>=FRAGDATA.DS_UnsafePlacardmedian(IDXF(1,1)) 
        DEAGG_DATA(i,16)=1;
    else
        DEAGG_DATA(i,16)=0;
    end
    
    if rem(i,size(DEAGG_DATA,1)/10)==0
        app.ProgressText.Value=['ESTIMATING UNSAFE PLACARD PROBABILITY ',num2str(round(i*100/size(DEAGG_DATA,1))),'%'];
        app.ProgressBar.Position=[9 5 i/size(DEAGG_DATA,1)*613 6];
        drawnow
    end
end