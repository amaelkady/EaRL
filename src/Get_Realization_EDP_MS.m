
function [Ri_EDP] = Get_Realization_EDP_MS(FRAGDATA,IDXF,N_Story,Ci_level,REALIZATIONS,n,Ri,im)
    if strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'SDR')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; evalc(['Ri_EDP=REALIZATIONS.SDR_S',num2str(im),'(Ri, n)']); end
        if Ci_level==2 && n>1;         evalc(['Ri_EDP=REALIZATIONS.SDR_S',num2str(im),'(Ri, n-1)']); end
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'PFA')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; evalc(['Ri_EDP=REALIZATIONS.PFA_S',num2str(im),'(Ri, n)']); end
        if Ci_level==2 && n>1;         evalc(['Ri_EDP=REALIZATIONS.PFA_S',num2str(im),'(Ri, n)']); end
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'PGA')==1
        evalc(['Ri_EDP=REALIZATIONS.PFA_S',num2str(im),'(Ri, 1)']);
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'LINK ROT')==1
        evalc(['Ri_EDP=REALIZATIONS.LINKROT_S',num2str(im),'(Ri, n)']);
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'BEAM ROT')==1
        evalc(['Ri_EDP=REALIZATIONS.BEAMROT_S',num2str(im),'(Ri, n)']);
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'COL ROT')==1
        evalc(['Ri_EDP=REALIZATIONS.COLROT_S',num2str(im),'(Ri, n)']);
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'DWD')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; evalc(['Ri_EDP=REALIZATIONS.DWD_S',num2str(im),'(Ri, n)']);   end
        if Ci_level==2 && n>1;         evalc(['Ri_EDP=REALIZATIONS.DWD_S',num2str(im),'(Ri, n-1)']); end
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'RD')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; evalc(['Ri_EDP=REALIZATIONS.RD_S',num2str(im),'(Ri, n)']);   end
        if Ci_level==2 && n>1;         evalc(['Ri_EDP=REALIZATIONS.RD_S',num2str(im),'(Ri, n-1)']); end
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'GENS1')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; evalc(['Ri_EDP=REALIZATIONS.GENS1_S',num2str(im),'(Ri, n)']);   end
        if Ci_level==2 && n>1;         evalc(['Ri_EDP=REALIZATIONS.GENS1_S',num2str(im),'(Ri, n-1)']); end
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'GENS2')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; evalc(['Ri_EDP=REALIZATIONS.GENS2_S',num2str(im),'(Ri, n)']);   end
        if Ci_level==2 && n>1;         evalc(['Ri_EDP=REALIZATIONS.GENS2_S',num2str(im),'(Ri, n-1)']); end
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'GENS3')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; evalc(['Ri_EDP=REALIZATIONS.GENS3_S',num2str(im),'(Ri, n)']);   end
        if Ci_level==2 && n>1;         evalc(['Ri_EDP=REALIZATIONS.GENS3_S',num2str(im),'(Ri, n-1)']); end
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'GENF1')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; evalc(['Ri_EDP=REALIZATIONS.GENF1_S',num2str(im),'(Ri, n)']); end
        if Ci_level==2 && n>1;         evalc(['Ri_EDP=REALIZATIONS.GENF1_S',num2str(im),'(Ri, n)']); end
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'GENF2')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; evalc(['Ri_EDP=REALIZATIONS.GENF2_S',num2str(im),'(Ri, n)']); end
        if Ci_level==2 && n>1;         evalc(['Ri_EDP=REALIZATIONS.GENF2_S',num2str(im),'(Ri, n)']); end
    elseif strcmp(FRAGDATA.DS_EDP(IDXF(1,1)),'GENF3')==1
        Ri_EDP=0;
        if Ci_level==1 && n<N_Story+1; evalc(['Ri_EDP=REALIZATIONS.GENF3_S',num2str(im),'(Ri, n)']); end
        if Ci_level==2 && n>1;         evalc(['Ri_EDP=REALIZATIONS.GENF3_S',num2str(im),'(Ri, n)']); end
    end
end