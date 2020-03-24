function [REALIZATIONS] = Get_REALIZATIONS_Matrix_MS(EDP_Data,EDP_Type,REALIZATIONS,nRealizationx,RndVarVector,n,N_Story,stdAdd)

    evalc(['X=EDP_Data.',EDP_Type,'.S',num2str(n)]);
    size2=size(X,2);
    
    % Based on Yang et al (2009)
    Y=log(X);
    My=mean(Y)';
    Dy=diag(sqrt(std(Y).^2+stdAdd^2));
    Ryy=corrcoef(Y);
    Ly=chol(Ryy)';

    counter=1;
    for i=1:nRealizationx
        RndVarVectorX=RndVarVector(i:i+size2-1,1);
        Z=Dy*Ly*RndVarVectorX+My;
        W(counter,:)=exp(Z)';
        counter=counter+1;
    end

    if strcmp(EDP_Type,'SDR')==1
        evalc(['REALIZATIONS.SDR_S',num2str(n),'=W']);
        evalc(['REALIZATIONS.SDR_S',num2str(n),'=[REALIZATIONS.SDR_S',num2str(n),'; X]']);
    elseif strcmp(EDP_Type,'PFA')==1
        evalc(['REALIZATIONS.PFA_S',num2str(n),'=W']);
        evalc(['REALIZATIONS.PFA_S',num2str(n),'=[REALIZATIONS.PFA_S',num2str(n),'; X]']);
    elseif strcmp(EDP_Type,'RDR')==1
        evalc(['REALIZATIONS.RDR_S',num2str(n),'=W']);
        evalc(['REALIZATIONS.RDR_S',num2str(n),'=[REALIZATIONS.RDR_S',num2str(n),'; X]']);
    elseif strcmp(EDP_Type,'VRD')==1
        evalc(['REALIZATIONS.VRD_S',num2str(n),'=W']);
        evalc(['REALIZATIONS.VRD_S',num2str(n),'=[REALIZATIONS.VRD_S',num2str(n),'; X]']);
    elseif strcmp(EDP_Type,'PGA')==1
        evalc(['REALIZATIONS.PGA_S',num2str(n),'=W']);
        evalc(['REALIZATIONS.PGA_S',num2str(n),'=[REALIZATIONS.PGA_S',num2str(n),'; X]']);
    elseif strcmp(EDP_Type,'LINK ROT')==1
        evalc(['REALIZATIONS.LINKROT_S',num2str(n),'=W']);
        evalc(['REALIZATIONS.LINKROT_S',num2str(n),'=[REALIZATIONS.LINKROT_S',num2str(n),'; X]']);
    elseif strcmp(EDP_Type,'BEAM ROT')==1
        evalc(['REALIZATIONS.BEAMROT_S',num2str(n),'=W']);
        evalc(['REALIZATIONS.BEAMROT_S',num2str(n),'=[REALIZATIONS.BEAMROT_S',num2str(n),'; X]']);
    elseif strcmp(EDP_Type,'COL ROT')==1
        evalc(['REALIZATIONS.COLROT_S',num2str(n),'=W']);
        evalc(['REALIZATIONS.COLROT_S',num2str(n),'=[REALIZATIONS.COLROT_S',num2str(n),'; X]']);
    elseif strcmp(EDP_Type,'DWD')==1
        evalc(['REALIZATIONS.DWD_S',num2str(n),'=W']);
        evalc(['REALIZATIONS.DWD_S',num2str(n),'=[REALIZATIONS.DWD_S',num2str(n),'; X]']);
    elseif strcmp(EDP_Type,'RD')==1
        evalc(['REALIZATIONS.RD_S',num2str(n),'=W']);
        evalc(['REALIZATIONS.RD_S',num2str(n),'=[REALIZATIONS.RD_S',num2str(n),'; X]']);
    elseif strcmp(EDP_Type,'GENS1')==1
        evalc(['REALIZATIONS.GENS1_S',num2str(n),'=W']);
        evalc(['REALIZATIONS.GENS1_S',num2str(n),'=[REALIZATIONS.GENS1_S',num2str(n),'; X]']);
    elseif strcmp(EDP_Type,'GENS2')==1
        evalc(['REALIZATIONS.GENS2_S',num2str(n),'=W']);
        evalc(['REALIZATIONS.GENS2_S',num2str(n),'=[REALIZATIONS.GENS2_S',num2str(n),'; X]']);
    elseif strcmp(EDP_Type,'GENS3')==1
        evalc(['REALIZATIONS.GENS3_S',num2str(n),'=W']);
        evalc(['REALIZATIONS.GENS3_S',num2str(n),'=[REALIZATIONS.GENS3_S',num2str(n),'; X]']);
    elseif strcmp(EDP_Type,'GENF1')==1
        evalc(['REALIZATIONS.GENF1_S',num2str(n),'=W']);
        evalc(['REALIZATIONS.GENF1_S',num2str(n),'=[REALIZATIONS.GENF1_S',num2str(n),'; X]']);
    elseif strcmp(EDP_Type,'GENF2')==1
        evalc(['REALIZATIONS.GENF2_S',num2str(n),'=W']);
        evalc(['REALIZATIONS.GENF2_S',num2str(n),'=[REALIZATIONS.GENF2_S',num2str(n),'; X]']);
    elseif strcmp(EDP_Type,'GENF3')==1
        evalc(['REALIZATIONS.GENF3_S',num2str(n),'=W']);
        evalc(['REALIZATIONS.GENF3_S',num2str(n),'=[REALIZATIONS.GENF3_S',num2str(n),'; X]']);
    end
end