function [MIDPTS, DPEDP]=Get_EDP_FragParam(EDP_Type,RANGE,EDP_Data,MIDPTS,Ci_level,N_Story,n,Stripe)

    evalc(['MedianEDP=EDP_Data.',char(EDP_Type),'median.S',num2str(Stripe)]);
    evalc([' SigmaEDP=EDP_Data.',char(EDP_Type),'sigma.S',num2str(Stripe)]);
    evalc(['EDP_Range=RANGE.',char(EDP_Type)]);
    PEDP=zeros(1,length(EDP_Range));

    if strcmp(EDP_Type,'SDR')==1
        MIDPTS.EDP=MIDPTS.SDR;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP(1,n)),  SigmaEDP(1,n));   end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP(1,n-1)),SigmaEDP(1,n-1)); end
    elseif strcmp(EDP_Type,'PFA')==1
        MIDPTS.EDP=MIDPTS.PFA;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP(1,n)),SigmaEDP(1,n)); end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP(1,n)),SigmaEDP(1,n)); end
    elseif strcmp(EDP_Type,'PFV')==1
        MIDPTS.EDP=MIDPTS.PFV;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP(1,n)),SigmaEDP(1,n)); end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP(1,n)),SigmaEDP(1,n)); end
    elseif strcmp(EDP_Type,'PFA')==1 && n==1
        MIDPTS.EDP=MIDPTS.PFA;  
        PEDP=logncdf(EDP_Range,log(MedianEDP(1,1)),SigmaEDP(1,1));
    elseif strcmp(EDP_Type,'LINK ROT')==1
        MIDPTS.EDP=MIDPTS.SDR;
        PEDP=logncdf(EDP_Range,log(MedianEDP(1,n)),SigmaEDP(1,n));
    elseif strcmp(EDP_Type,'BEAM ROT')==1
        MIDPTS.EDP=MIDPTS.SDR;
        PEDP=logncdf(EDP_Range,log(MedianEDP(1,n)),SigmaEDP(1,n));
    elseif strcmp(EDP_Type,'COL ROT')==1
        MIDPTS.EDP    = MIDPTS.SDR;
        PEDP=logncdf(EDP_Range,log(MedianEDP(1,n)),SigmaEDP(1,n));
    elseif strcmp(EDP_Type,'DWD')==1
        MIDPTS.EDP    = MIDPTS.SDR;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP(1,n)),  SigmaEDP(1,n));     end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP(1,n-1)),SigmaEDP(1,n-1));   end
    elseif strcmp(EDP_Type,'RD')==1
        MIDPTS.EDP    = MIDPTS.SDR;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP(1,n)),  SigmaEDP(1,n));     end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP(1,n-1)),SigmaEDP(1,n-1));   end
    elseif strcmp(EDP_Type,'GENS1')==1
        MIDPTS.EDP    = MIDPTS.GENS1;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP(1,n)),  SigmaEDP(1,n));   end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP(1,n-1)),SigmaEDP(1,n-1)); end
    elseif strcmp(EDP_Type,'GENS2')==1
        MIDPTS.EDP    = MIDPTS.GENS2;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP(1,n)),  SigmaEDP(1,n));   end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP(1,n-1)),SigmaEDP(1,n-1)); end
    elseif strcmp(EDP_Type,'GENS3')==1
        MIDPTS.EDP    = MIDPTS.GENS3;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP(1,n)),  SigmaEDP(1,n));   end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP(1,n-1)),SigmaEDP(1,n-1)); end
    elseif strcmp(EDP_Type,'GENF1')==1
        MIDPTS.EDP=MIDPTS.GENF1;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP(1,n)),SigmaEDP(1,n)); end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP(1,n)),SigmaEDP(1,n)); end
    elseif strcmp(EDP_Type,'GENF2')==1
        MIDPTS.EDP=MIDPTS.GENF2;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP(1,n)),SigmaEDP(1,n)); end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP(1,n)),SigmaEDP(1,n)); end
    elseif strcmp(EDP_Type,'GENF3')==1
        MIDPTS.EDP=MIDPTS.GENF3;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP(1,n)),SigmaEDP(1,n)); end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP(1,n)),SigmaEDP(1,n)); end
    end
    
    DPEDP=abs(diff(PEDP));% Probability of occurance of a given EDP (for a specific 1 value)

end