function [MIDPTS, DPEDP]=Get_EDP_FragParam_IM(FRAGDATA,IDXF,Range,Median_IM,Sigma_IM,MIDPTS,Ci_level,N_Story,n,im)
    if strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'SDR')==1
        EDP_Range=Range.SDR;
        PEDP=zeros(1,length(EDP_Range));
        MedianEDP_IM=Median_IM.SDR;
        SigmaEDP_IM=Sigma_IM.SDR;
        MIDPTS.EDP=MIDPTS.SDR;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n)),SigmaEDP_IM(im,n)); end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n-1)),SigmaEDP_IM(im,n-1)); end
        DPEDP=abs(diff(PEDP));
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'PFA')==1
        EDP_Range=Range.PFA;
        PEDP=zeros(1,length(EDP_Range));
        MedianEDP_IM=Median_IM.PFA;
        SigmaEDP_IM=Sigma_IM.PFA;
        MIDPTS.EDP=MIDPTS.PFA;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n)),SigmaEDP_IM(im,n)); end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n)),SigmaEDP_IM(im,n)); end
        DPEDP=abs(diff(PEDP));
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'PGA')==1
        EDP_Range=Range.PFA;
        MedianEDP_IM=Median_IM.PFA(:,1);
        SigmaEDP_IM=Sigma_IM.PFA(:,1);
        MIDPTS.EDP=MIDPTS.PFA;  
        PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,1)),SigmaEDP_IM(im,1));
        DPEDP=abs(diff(PEDP));% Probability of occurance of a given EDP (for a specific im value)
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'PFV')==1
        EDP_Range=Range.PFV;
        PEDP=zeros(1,length(EDP_Range));
        MedianEDP_IM=Median_IM.PFV;
        SigmaEDP_IM=Sigma_IM.PFV;
        MIDPTS.EDP=MIDPTS.PFV;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n)),SigmaEDP_IM(im,n)); end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n)),SigmaEDP_IM(im,n)); end
        DPEDP=abs(diff(PEDP));
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'LINK ROT')==1
        EDP_Range=Range.SDR;
        MedianEDP_IM=Median_IM.LINKROT;
        SigmaEDP_IM=Sigma_IM.LINKROT;
        MIDPTS.EDP=MIDPTS.SDR;
        PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n)),SigmaEDP_IM(im,n));
        DPEDP=abs(diff(PEDP));
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'BEAM ROT')==1
        EDP_Range=Range.SDR;
        MedianEDP_IM=Median_IM.BEAMROT;
        SigmaEDP_IM=Sigma_IM.BEAMROT;
        MIDPTS.EDP=MIDPTS.SDR;
        PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n)),SigmaEDP_IM(im,n));
        DPEDP=abs(diff(PEDP));
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'COL ROT')==1
        EDP_Range    = Range.SDR;
        PEDP=zeros(1,length(EDP_Range));
        MedianEDP_IM = Median_IM.COLROT;
        SigmaEDP_IM   = Sigma_IM.COLROT;
        MIDPTS.EDP    = MIDPTS.SDR;
        PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n)),SigmaEDP_IM(im,n));
        DPEDP=abs(diff(PEDP));
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'DWD')==1
        EDP_Range    = Range.SDR;
        PEDP=zeros(1,length(EDP_Range));
        MedianEDP_IM = Median_IM.DWD;
        SigmaEDP_IM   = Sigma_IM.DWD;
        MIDPTS.EDP    = MIDPTS.SDR;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n)),SigmaEDP_IM(im,n));       end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n-1)),SigmaEDP_IM(im,n-1));   end
        DPEDP=abs(diff(PEDP));
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'RD')==1
        EDP_Range    = Range.SDR;
        PEDP=zeros(1,length(EDP_Range));
        MedianEDP_IM = Median_IM.RD;
        SigmaEDP_IM   = Sigma_IM.RD;
        MIDPTS.EDP    = MIDPTS.SDR;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n)),SigmaEDP_IM(im,n));       end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n-1)),SigmaEDP_IM(im,n-1));   end
        DPEDP=abs(diff(PEDP));
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'GENS1')==1
        EDP_Range    = Range.GENS1;
        PEDP=zeros(1,length(EDP_Range));
        MedianEDP_IM = Median_IM.GENS1;
        SigmaEDP_IM   = Sigma_IM.GENS1;
        MIDPTS.EDP    = MIDPTS.GENS1;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n)),SigmaEDP_IM(im,n)); end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n-1)),SigmaEDP_IM(im,n-1)); end
        DPEDP=abs(diff(PEDP));
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'GENS2')==1
        EDP_Range    = Range.GENS2;
        PEDP=zeros(1,length(EDP_Range));
        MedianEDP_IM = Median_IM.GENS2;
        SigmaEDP_IM   = Sigma_IM.GENS2;
        MIDPTS.EDP    = MIDPTS.GENS2;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n)),SigmaEDP_IM(im,n)); end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n-1)),SigmaEDP_IM(im,n-1)); end
        DPEDP=abs(diff(PEDP));
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'GENS3')==1
        EDP_Range    = Range.GENS3;
        PEDP=zeros(1,length(EDP_Range));
        MedianEDP_IM = Median_IM.GENS3;
        SigmaEDP_IM   = Sigma_IM.GENS3;
        MIDPTS.EDP    = MIDPTS.GENS3;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n)),SigmaEDP_IM(im,n)); end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n-1)),SigmaEDP_IM(im,n-1)); end
        DPEDP=abs(diff(PEDP));
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'GENF1')==1
        EDP_Range=Range.GENF1;
        PEDP=zeros(1,length(EDP_Range));
        MedianEDP_IM=Median_IM.GENF1;
        SigmaEDP_IM=Sigma_IM.GENF1;
        MIDPTS.EDP=MIDPTS.GENF1;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n)),SigmaEDP_IM(im,n)); end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n)),SigmaEDP_IM(im,n)); end
        DPEDP=abs(diff(PEDP));
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'GENF2')==1
        EDP_Range=Range.GENF2;
        PEDP=zeros(1,length(EDP_Range));
        MedianEDP_IM=Median_IM.GENF2;
        SigmaEDP_IM=Sigma_IM.GENF2;
        MIDPTS.EDP=MIDPTS.GENF2;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n)),SigmaEDP_IM(im,n)); end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n)),SigmaEDP_IM(im,n)); end
        DPEDP=abs(diff(PEDP));
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'GENF3')==1
        EDP_Range=Range.GENF3;
        PEDP=zeros(1,length(EDP_Range));
        MedianEDP_IM=Median_IM.GENF3;
        SigmaEDP_IM=Sigma_IM.GENF3;
        MIDPTS.EDP=MIDPTS.GENF3;
        if Ci_level==1 && n<N_Story+1; PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n)),SigmaEDP_IM(im,n)); end
        if Ci_level==2 && n>1;         PEDP=logncdf(EDP_Range,log(MedianEDP_IM(im,n)),SigmaEDP_IM(im,n)); end
        DPEDP=abs(diff(PEDP));
    end
end