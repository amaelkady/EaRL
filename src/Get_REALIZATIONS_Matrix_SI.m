function [REALIZATIONS] = Get_REALIZATIONS_Matrix_SI(EDP_Data,EDP_Type,REALIZATIONS,nRealizationx,RndVarVector,n,stdAdd,Response_Option)

    evalc(['MedianEDP=EDP_Data.',EDP_Type,'median.S',num2str(n)]);
    evalc(['SigmaEDP=EDP_Data.',EDP_Type,'sigma.S',num2str(n)]);
    evalc(['CorrEDP=EDP_Data.',EDP_Type,'corr']);

    if Response_Option==5 && size(EDP_Data.SDR.S1,1)==1
        Response_Option=10;
    end
        
    if Response_Option==2 || Response_Option==5 
        evalc(['X=EDP_Data.',EDP_Type,'.S',num2str(n)]);
        size2=size(X,2);
        Y=log(X);
        My=mean(Y)';
        Dy=diag(sqrt(std(Y).^2+stdAdd^2));
        Ryy=corrcoef(Y);
    else
        size2=size(MedianEDP,2);
        My=log(MedianEDP)';
        Dy=diag(sqrt(SigmaEDP.^2+stdAdd^2));
        Ryy=CorrEDP;
    end
    

    
    try
        Ly = chol(Ryy)';
    catch ME
        % Fix for highly correlated input data
        %Ryy=round(Ryy*1000)/1000;
        %Imat=eye(size(Ryy, 1));       
        %Xmat=zeros(size(Ryy, 1))+0.99;
        %Ryy=Imat+Xmat;
        %Ryy(Ryy>1)=1;
        %errordlg(['The response data for ',EDP_Type,' will not yield a positive definitie correlation matrix. Consider revising the data or using the "Parameter" option instead to define the EDP data and the correlation matrix directly.'],'Problem Ahead!')
        [~,Ly] = lu(Ryy);
        Ly=Ly';
    end    

    
    counter=1;
    for i=1:nRealizationx
        RndVarVectorX=RndVarVector(i:i+size2-1,1);
        Z=Dy*Ly*RndVarVectorX+My;
        W(counter,:)=exp(Z)';
        counter=counter+1;
    end
    
    if strcmp(EDP_Type,'SDR')==1
        REALIZATIONS.SDR=W;
        if Response_Option==2; REALIZATIONS.SDR=[REALIZATIONS.SDR; X]; end
    elseif strcmp(EDP_Type,'PFA')==1
        REALIZATIONS.PFA=W;
        if Response_Option==2; REALIZATIONS.PFA=[REALIZATIONS.PFA; X]; end
    elseif strcmp(EDP_Type,'PGA')==1
        REALIZATIONS.PGA=W;
        if Response_Option==2; REALIZATIONS.PGA=[REALIZATIONS.PGA; X]; end
    elseif strcmp(EDP_Type,'RDR')==1
        REALIZATIONS.RDR=W;
        if Response_Option==2; REALIZATIONS.RDR=[REALIZATIONS.RDR; X]; end
    elseif strcmp(EDP_Type,'VRD')==1
        REALIZATIONS.VRD=W;
        if Response_Option==2; REALIZATIONS.VRD=[REALIZATIONS.VRD; X]; end
    elseif strcmp(EDP_Type,'LINK ROT')==1
        REALIZATIONS.LINKROT=W;
        if Response_Option==2; REALIZATIONS.LINKROT=[REALIZATIONS.LINKROT; X]; end
    elseif strcmp(EDP_Type,'BEAM ROT')==1
        REALIZATIONS.BEAMROT=W;
        if Response_Option==2; REALIZATIONS.BEAMROT=[REALIZATIONS.BEAMROT; X]; end
    elseif strcmp(EDP_Type,'COL ROT')==1
        REALIZATIONS.COLROT=W;
        if Response_Option==2; REALIZATIONS.COLROT=[REALIZATIONS.COLROT; X]; end
    elseif strcmp(EDP_Type,'DWD')==1
        REALIZATIONS.DWD=W;
        if Response_Option==2; REALIZATIONS.DWD=[REALIZATIONS.DWD; X]; end
    elseif strcmp(EDP_Type,'RD')==1
        REALIZATIONS.RD=W;
        if Response_Option==2; REALIZATIONS.RD=[REALIZATIONS.RD; X]; end
    elseif strcmp(EDP_Type,'GENS1')==1
        REALIZATIONS.GENS1=W;
        if Response_Option==2; REALIZATIONS.GENS1=[REALIZATIONS.GENS1; X]; end
    elseif strcmp(EDP_Type,'GENS2')==1
        REALIZATIONS.GENS2=W;
        if Response_Option==2; REALIZATIONS.GENS2=[REALIZATIONS.GENS2; X]; end
    elseif strcmp(EDP_Type,'GENS3')==1
        REALIZATIONS.GENS3=W;
        if Response_Option==2; REALIZATIONS.GENS3=[REALIZATIONS.GENS3; X]; end
    elseif strcmp(EDP_Type,'GENF1')==1
        REALIZATIONS.GENF1=W;
        if Response_Option==2; REALIZATIONS.GENF1=[REALIZATIONS.GENF1; X]; end
    elseif strcmp(EDP_Type,'GENF2')==1
        REALIZATIONS.GENF2=W;
        if Response_Option==2; REALIZATIONS.GENF2=[REALIZATIONS.GENF2; X]; end
    elseif strcmp(EDP_Type,'GENF3')==1
        REALIZATIONS.GENF3=W;
        if Response_Option==2; REALIZATIONS.GENF3=[REALIZATIONS.GENF3; X]; end
    elseif strcmp(EDP_Type,'PFV')==1
        REALIZATIONS.PFV=W;
        if Response_Option==2; REALIZATIONS.PFV=[REALIZATIONS.PFV; X]; end
    elseif strcmp(EDP_Type,'GENF3')==1
        REALIZATIONS.ED=W;
        if Response_Option==2; REALIZATIONS.ED=[REALIZATIONS.ED; X]; end
    end
end