function [REALIZATIONS]=Get_REALIZATIONS(app)

app.ProgressText.Value='GENERATING EDP REALIZATIONS';        app.ProgressBar.BackgroundColor='g'; app.ProgressBar.Position=[9 5 613 6]; drawnow;

global MainDirectory ProjectPath ProjectName
cd (ProjectPath)
load (ProjectName)
cd (MainDirectory)


if Response_Option==4
    
    nRealizationx=nRealization-size(EDP_Data.SDR.S1,1);
    RndVarVector=0;
    for i=1:nRealizationx
        RndVarVector1=normrnd(0,1,N_Story+1,1);
        RndVarVector=[RndVarVector; RndVarVector1];
    end
    RndVarVector(1,:)=[];

    REALIZATIONS.SDR_S1=0;
    for n=1:nStripe
                                     [REALIZATIONS]=Get_REALIZATIONS_Matrix_MS(EDP_Data,     'SDR',REALIZATIONS,nRealizationx,RndVarVector,n,N_Story,stdAdd);
                                     [REALIZATIONS]=Get_REALIZATIONS_Matrix_MS(EDP_Data,     'PFA',REALIZATIONS,nRealizationx,RndVarVector,n,N_Story,stdAdd);
        if Data_Status.RDR==1;       [REALIZATIONS]=Get_REALIZATIONS_Matrix_MS(EDP_Data,     'RDR',REALIZATIONS,nRealizationx,RndVarVector,n,N_Story,stdAdd); end
        if Data_Status.VRD==1;       [REALIZATIONS]=Get_REALIZATIONS_Matrix_MS(EDP_Data,     'VRD',REALIZATIONS,nRealizationx,RndVarVector,n,N_Story,stdAdd); end
        if Data_Status.LINKROT==1;   [REALIZATIONS]=Get_REALIZATIONS_Matrix_MS(EDP_Data,'LINK ROT',REALIZATIONS,nRealizationx,RndVarVector,n,N_Story,stdAdd); end
        if Data_Status.COLROT==1;    [REALIZATIONS]=Get_REALIZATIONS_Matrix_MS(EDP_Data, 'COL ROT',REALIZATIONS,nRealizationx,RndVarVector,n,N_Story,stdAdd); end
        if Data_Status.BEAMROT==1;   [REALIZATIONS]=Get_REALIZATIONS_Matrix_MS(EDP_Data,'BEAM ROT',REALIZATIONS,nRealizationx,RndVarVector,n,N_Story,stdAdd); end
        if Data_Status.DWD==1;       [REALIZATIONS]=Get_REALIZATIONS_Matrix_MS(EDP_Data,     'DWD',REALIZATIONS,nRealizationx,RndVarVector,n,N_Story,stdAdd); end
        if Data_Status.RD==1;        [REALIZATIONS]=Get_REALIZATIONS_Matrix_MS(EDP_Data,      'RD',REALIZATIONS,nRealizationx,RndVarVector,n,N_Story,stdAdd); end
        if Data_Status.GENS1==1;     [REALIZATIONS]=Get_REALIZATIONS_Matrix_MS(EDP_Data,   'GENS1',REALIZATIONS,nRealizationx,RndVarVector,n,N_Story,stdAdd); end
        if Data_Status.GENS2==1;     [REALIZATIONS]=Get_REALIZATIONS_Matrix_MS(EDP_Data,   'GENS2',REALIZATIONS,nRealizationx,RndVarVector,n,N_Story,stdAdd); end
        if Data_Status.GENS3==1;     [REALIZATIONS]=Get_REALIZATIONS_Matrix_MS(EDP_Data,   'GENS3',REALIZATIONS,nRealizationx,RndVarVector,n,N_Story,stdAdd); end
        if Data_Status.GENF1==1;     [REALIZATIONS]=Get_REALIZATIONS_Matrix_MS(EDP_Data,   'GENF1',REALIZATIONS,nRealizationx,RndVarVector,n,N_Story,stdAdd); end
        if Data_Status.GENF2==1;     [REALIZATIONS]=Get_REALIZATIONS_Matrix_MS(EDP_Data,   'GENF2',REALIZATIONS,nRealizationx,RndVarVector,n,N_Story,stdAdd); end
        if Data_Status.GENF3==1;     [REALIZATIONS]=Get_REALIZATIONS_Matrix_MS(EDP_Data,   'GENF3',REALIZATIONS,nRealizationx,RndVarVector,n,N_Story,stdAdd); end
        if Data_Status.PFV==1;       [REALIZATIONS]=Get_REALIZATIONS_Matrix_MS(EDP_Data,     'PFV',REALIZATIONS,nRealizationx,RndVarVector,n,N_Story,stdAdd); end
        if Data_Status.ED==1;        [REALIZATIONS]=Get_REALIZATIONS_Matrix_MS(EDP_Data,      'ED',REALIZATIONS,nRealizationx,RndVarVector,n,N_Story,stdAdd); end
    end

else
    
 
    if Response_Option==2; nRealizationx = nRealization-size(EDP_Data.SDR.S1,1);
    else;                  nRealizationx = nRealization;
    end

    RndVarVector=0;
    for kk=1:nRealizationx
        RndVarVector1=normrnd(0,1,N_Story+1,1);
        RndVarVector=[RndVarVector; RndVarVector1];
    end
    RndVarVector(1,:)=[];

    REALIZATIONS.X=0;
    for n=1:nStripe
                                     [REALIZATIONS]=Get_REALIZATIONS_Matrix_SI(EDP_Data,     'SDR',REALIZATIONS,nRealizationx,RndVarVector,n,stdAdd,Response_Option);
                                     [REALIZATIONS]=Get_REALIZATIONS_Matrix_SI(EDP_Data,     'PFA',REALIZATIONS,nRealizationx,RndVarVector,n,stdAdd,Response_Option);
        if Data_Status.RDR==1;       [REALIZATIONS]=Get_REALIZATIONS_Matrix_SI(EDP_Data,     'RDR',REALIZATIONS,nRealizationx,RndVarVector,n,stdAdd,Response_Option);    end
        if Data_Status.VRD==1;       [REALIZATIONS]=Get_REALIZATIONS_Matrix_SI(EDP_Data,     'VRD',REALIZATIONS,nRealizationx,RndVarVector,n,stdAdd,Response_Option);    end
        if Data_Status.LINKROT==1;   [REALIZATIONS]=Get_REALIZATIONS_Matrix_SI(EDP_Data,'LINK ROT',REALIZATIONS,nRealizationx,RndVarVector,n,stdAdd,Response_Option);    end
        if Data_Status.COLROT==1;    [REALIZATIONS]=Get_REALIZATIONS_Matrix_SI(EDP_Data, 'COL ROT',REALIZATIONS,nRealizationx,RndVarVector,n,stdAdd,Response_Option);    end
        if Data_Status.BEAMROT==1;   [REALIZATIONS]=Get_REALIZATIONS_Matrix_SI(EDP_Data,'BEAM ROT',REALIZATIONS,nRealizationx,RndVarVector,n,stdAdd,Response_Option);    end
        if Data_Status.DWD==1;       [REALIZATIONS]=Get_REALIZATIONS_Matrix_SI(EDP_Data,     'DWD',REALIZATIONS,nRealizationx,RndVarVector,n,stdAdd,Response_Option);    end
        if Data_Status.RD==1;        [REALIZATIONS]=Get_REALIZATIONS_Matrix_SI(EDP_Data,      'RD',REALIZATIONS,nRealizationx,RndVarVector,n,stdAdd,Response_Option);    end
        if Data_Status.GENS1==1;     [REALIZATIONS]=Get_REALIZATIONS_Matrix_SI(EDP_Data,   'GENS1',REALIZATIONS,nRealizationx,RndVarVector,n,stdAdd,Response_Option);    end
        if Data_Status.GENS2==1;     [REALIZATIONS]=Get_REALIZATIONS_Matrix_SI(EDP_Data,   'GENS2',REALIZATIONS,nRealizationx,RndVarVector,n,stdAdd,Response_Option);    end
        if Data_Status.GENS3==1;     [REALIZATIONS]=Get_REALIZATIONS_Matrix_SI(EDP_Data,   'GENS3',REALIZATIONS,nRealizationx,RndVarVector,n,stdAdd,Response_Option);    end
        if Data_Status.GENF1==1;     [REALIZATIONS]=Get_REALIZATIONS_Matrix_SI(EDP_Data,   'GENF1',REALIZATIONS,nRealizationx,RndVarVector,n,stdAdd,Response_Option);    end
        if Data_Status.GENF2==1;     [REALIZATIONS]=Get_REALIZATIONS_Matrix_SI(EDP_Data,   'GENF2',REALIZATIONS,nRealizationx,RndVarVector,n,stdAdd,Response_Option);    end
        if Data_Status.GENF3==1;     [REALIZATIONS]=Get_REALIZATIONS_Matrix_SI(EDP_Data,   'GENF3',REALIZATIONS,nRealizationx,RndVarVector,n,stdAdd,Response_Option);    end
        if Data_Status.PFV==1;       [REALIZATIONS]=Get_REALIZATIONS_Matrix_SI(EDP_Data,     'PFV',REALIZATIONS,nRealizationx,RndVarVector,n,stdAdd,Response_Option);    end
        if Data_Status.ED==1;        [REALIZATIONS]=Get_REALIZATIONS_Matrix_SI(EDP_Data,      'ED',REALIZATIONS,nRealizationx,RndVarVector,n,stdAdd,Response_Option);    end
    end

end