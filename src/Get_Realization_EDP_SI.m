function [Ri_EDP] = Get_Realization_EDP_SI(FRAGDATA,IDXF,N_Story,Ci_level,REALIZATIONS,n,Ri,im)
    if strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'SDR')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; Ri_EDP=REALIZATIONS.SDR(Ri, n); end
        if Ci_level==2 && n>1;         Ri_EDP=REALIZATIONS.SDR(Ri, n-1); end
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'PFA')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; Ri_EDP=REALIZATIONS.PFA(Ri, n); end
        if Ci_level==2 && n>1;         Ri_EDP=REALIZATIONS.PFA(Ri, n); end
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'PGA')==1
        Ri_EDP=REALIZATIONS.PFA(Ri, 1);
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'LINK ROT')==1
        Ri_EDP=REALIZATIONS.LINKROT(Ri, n);
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'BEAM ROT')==1
        Ri_EDP=REALIZATIONS.BEAMROT(Ri, n);
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'COL ROT')==1
        Ri_EDP=REALIZATIONS.COLROT(Ri, n);
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'DWD')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; Ri_EDP=REALIZATIONS.DWD(Ri, n);   end
        if Ci_level==2 && n>1;         Ri_EDP=REALIZATIONS.DWD(Ri, n-1); end
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'RD')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; Ri_EDP=REALIZATIONS.RD(Ri, n);   end
        if Ci_level==2 && n>1;         Ri_EDP=REALIZATIONS.RD(Ri, n-1); end
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'GENS1')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; Ri_EDP=REALIZATIONS.GENS1(Ri, n);   end
        if Ci_level==2 && n>1;         Ri_EDP=REALIZATIONS.GENS1(Ri, n-1); end
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'GENS2')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; Ri_EDP=REALIZATIONS.GENS2(Ri, n);   end
        if Ci_level==2 && n>1;         Ri_EDP=REALIZATIONS.GENS2(Ri, n-1); end
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'GENS3')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; Ri_EDP=REALIZATIONS.GENS3(Ri, n);   end
        if Ci_level==2 && n>1;         Ri_EDP=REALIZATIONS.GENS3(Ri, n-1); end
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'GENF1')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; Ri_EDP=REALIZATIONS.GENF1(Ri, n); end
        if Ci_level==2 && n>1;         Ri_EDP=REALIZATIONS.GENF1(Ri, n); end
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'GENF2')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; Ri_EDP=REALIZATIONS.GENF2(Ri, n); end
        if Ci_level==2 && n>1;         Ri_EDP=REALIZATIONS.GENF2(Ri, n); end
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'GENF3')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; Ri_EDP=REALIZATIONS.GENF3(Ri, n); end
        if Ci_level==2 && n>1;         Ri_EDP=REALIZATIONS.GENF3(Ri, n); end
    end
end
