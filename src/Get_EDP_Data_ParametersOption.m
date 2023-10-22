function [EDP_Data,MaxSDR,MaxPFA,MaxVRD]=Get_EDP_Data_ParametersOption(N_Story,NRHADataFilePath,NRHADataExcelFileName,Data_Status,EDP_Data)

cd (NRHADataFilePath);

% Read EDP data from Excel
EDP_Data.SDR.S1 = xlsread(NRHADataExcelFileName,'SDR','B3:EZ4');
EDP_Data.SDRmedian.S1 (1,:) = EDP_Data.SDR.S1(1,:);
EDP_Data.SDRsigma.S1  (1,:) = EDP_Data.SDR.S1(2,:);
Corr = xlsread(NRHADataExcelFileName,'SDR','C9:EZ58');
Corr(isnan(Corr))=0.0;
Corr2 = rot90(fliplr(Corr),1);
Corr =Corr+Corr2;
Corr(Corr==2)=1;
try chol(Corr);
catch ME
    errordlg('Correlation matrix for SDR is not symmetric positive definite! Revise the values in the EXCEL file');
    return
end
EDP_Data.SDRcorr=Corr;
MaxSDR=max(EDP_Data.SDRmedian.S1);

EDP_Data.PFA.S1 = xlsread(NRHADataExcelFileName,'PFA','B3:EZ4');
EDP_Data.PFAmedian.S1 (1,:) = EDP_Data.PFA.S1(1,:);
EDP_Data.PFAsigma.S1  (1,:) = EDP_Data.PFA.S1(2,:);
Corr = xlsread(NRHADataExcelFileName,'PFA','C9:EZ58');
Corr(isnan(Corr))=0.0;
Corr2 = rot90(fliplr(Corr),1);
Corr =Corr+Corr2;
Corr(Corr==2)=1;
try chol(Corr);
catch ME
    errordlg('Correlation matrix for PFA is not symmetric positive definite! Revise the values in the EXCEL file');
    return
end
EDP_Data.PFAcorr=Corr;
MaxPFA=max(EDP_Data.PFAmedian.S1);

% Data Checks
if N_Story ~= size(EDP_Data.SDR.S1,2) || N_Story ~= size(EDP_Data.PFA.S1,2)-1
    errordlg('Excel sheet data size does not agree with number of stories/floors');
    return
end

if Data_Status.RDR==1
    EDP_Data.RDR.S1 = xlsread(NRHADataExcelFileName,'RDR','B3:EZ4');
    EDP_Data.RDRmedian.S1 (1,:) = EDP_Data.RDR.S1(1,:);
    EDP_Data.RDRsigma.S1  (1,:) = EDP_Data.RDR.S1(2,:);
    EDP_Data.RDRcorr=1.0;
end

MaxVRD=0;
if Data_Status.VRD==1
    EDP_Data.VRD.S1 = xlsread(NRHADataExcelFileName,'VRD','B3:C4');
    EDP_Data.VRDmedian.S1 (1,:) = EDP_Data.VRD.S1(1,:);
    EDP_Data.VRDsigma.S1  (1,:) = EDP_Data.VRD.S1(2,:);
    MaxVRD=max(EDP_Data.VRDmedian.S1);
    EDP_Data.VRDcorr=1.0;
end

if Data_Status.LINKROT==1
    EDP_Data.LINKROT.S1= xlsread(NRHADataExcelFileName,'LINK ROT','B3:EZ4');
    EDP_Data.LINKROTmedian.S1(1,2:N_Story+1)=EDP_Data.LINKROT.S1(1,:);
    EDP_Data.LINKROTsigma.S1  (1,2:N_Story+1)=EDP_Data.LINKROT.S1(2,:);
    Corr = xlsread(NRHADataExcelFileName,'LINK ROT','C9:EZ58');
    Corr(isnan(Corr))=0.0;
    Corr2 = rot90(fliplr(Corr),1);
    Corr =Corr+Corr2;
    Corr(Corr==2)=1;
    try chol(Corr);
    catch ME
        errordlg('Correlation matrix for LINK ROT is not symmetric positive definite! Revise the values in the EXCEL file');
        return
    end
    EDP_Data.LINKROTcorr=Corr;
end

if Data_Status.COLROT==1
    EDP_Data.COLROT_S1 = xlsread(NRHADataExcelFileName,'COL ROT','B3:EZ4');
    EDP_Data.COLROTmedian.S1 (1,:)=EDP_Data.COLROT.S1(1,:);
    EDP_Data.COLROTsigma.S1  (1,:)=EDP_Data.COLROT.S1(2,:);
    Corr = xlsread(NRHADataExcelFileName,'COL ROT','C9:EZ58');
    Corr(isnan(Corr))=0.0;
    Corr2 = rot90(fliplr(Corr),1);
    Corr =Corr+Corr2;
    Corr(Corr==2)=1;
    try chol(Corr);
    catch ME
        errordlg('Correlation matrix for COL ROT is not symmetric positive definite! Revise the values in the EXCEL file');
        return
    end
    EDP_Data.COLROTcorr=Corr;
end

if Data_Status.BEAMROT==1
    EDP_Data.BEAMROT.S1 = xlsread(NRHADataExcelFileName,'BEAM ROT','B3:EZ4');
    EDP_Data.BEAMROTmedian.S1 (1,2:N_Story+1)=EDP_Data.BEAMROT.S1(1,:);
    EDP_Data.BEAMROTsigma.S1  (1,2:N_Story+1)=EDP_Data.BEAMROT.S1(2,:);
    Corr = xlsread(NRHADataExcelFileName,'BEAM ROT','C9:EZ58');
    Corr(isnan(Corr))=0.0;
    Corr2 = rot90(fliplr(Corr),1);
    Corr =Corr+Corr2;
    Corr(Corr==2)=1;
    try chol(Corr);
    catch ME
        errordlg('Correlation matrix for BEAM ROT is not symmetric positive definite! Revise the values in the EXCEL file');
        return
    end
    EDP_Data.BEAMROTcorr=Corr;
end

if Data_Status.DWD==1
    EDP_Data.DWD.S1 = xlsread(NRHADataExcelFileName,'DWD','B3:EZ4');
    EDP_Data.DWDmedian.S1 (1,:)=EDP_Data.DWD.S1(1,:);
    EDP_Data.DWDsigma.S1  (1,:)=EDP_Data.DWD.S1(2,:);
    Corr = xlsread(NRHADataExcelFileName,'DWD','C9:EZ58');
    Corr(isnan(Corr))=0.0;
    Corr2 = rot90(fliplr(Corr),1);
    Corr =Corr+Corr2;
    Corr(Corr==2)=1;
    try chol(Corr);
    catch ME
        errordlg('Correlation matrix for DWD is not symmetric positive definite! Revise the values in the EXCEL file');
        return
    end
    EDP_Data.DWDcorr=Corr;
end

if Data_Status.RD==1
    EDP_Data.RD.S1 = xlsread(NRHADataExcelFileName,'RD','B3:EZ4');
    EDP_Data.RDmedian.S1 (1,:)=EDP_Data.RD.S1(1,:);
    EDP_Data.RDsigma.S1  (1,:)=EDP_Data.RD.S1(2,:);
    Corr = xlsread(NRHADataExcelFileName,'RD','C9:EZ58');
    Corr(isnan(Corr))=0.0;
    Corr2 = rot90(fliplr(Corr),1);
    Corr =Corr+Corr2;
    Corr(Corr==2)=1;
    try chol(Corr);
    catch ME
        errordlg('Correlation matrix for RD is not symmetric positive definite! Revise the values in the EXCEL file');
        return
    end
    EDP_Data.RDcorr=Corr;
end

if Data_Status.ED==1
    EDP_Data.ED.S1 = xlsread(NRHADataExcelFileName,'ED','B3:EZ4');
    EDP_Data.EDmedian.S1 (1,:)=EDP_Data.ED.S1(1,:);
    EDP_Data.EDsigma.S1  (1,:)=EDP_Data.ED.S1(2,:);
    Corr = xlsread(NRHADataExcelFileName,'ED','C9:EZ58');
    Corr(isnan(Corr))=0.0;
    Corr2 = rot90(fliplr(Corr),1);
    Corr =Corr+Corr2;
    Corr(Corr==2)=1;
    try chol(Corr);
    catch ME
        errordlg('Correlation matrix for ED is not symmetric positive definite! Revise the values in the EXCEL file');
        return
    end
    EDP_Data.EDcorr=Corr;
end

if Data_Status.PFV==1
    EDP_Data.PFV.S1 = xlsread(NRHADataExcelFileName,'PFV','B3:EZ4');
    EDP_Data.PFVmedian.S1 (1,:) = EDP_Data.PFV.S1(1,:);
    EDP_Data.PFVsigma.S1  (1,:) = EDP_Data.PFV.S1(2,:);
    Corr = xlsread(NRHADataExcelFileName,'PFV','C9:EZ58');
    Corr(isnan(Corr))=0.0;
    Corr2 = rot90(fliplr(Corr),1);
    Corr =Corr+Corr2;
    Corr(Corr==2)=1;
    try chol(Corr);
    catch ME
        errordlg('Correlation matrix for PFV is not symmetric positive definite! Revise the values in the EXCEL file');
        return
    end
    EDP_Data.PFVcorr=Corr;
end

if Data_Status.GENS1==1
    EDP_Data.GENS1.S1 = xlsread(NRHADataExcelFileName,'GENS1','B3:EZ4');
    EDP_Data.GENS1median.S1 (1,:)=EDP_Data.GENS1.S1(1,:);
    EDP_Data.GENS1sigma.S1  (1,:)=EDP_Data.GENS1.S1(2,:);
    Corr = xlsread(NRHADataExcelFileName,'GENS1','C9:EZ58');
    Corr(isnan(Corr))=0.0;
    Corr2 = rot90(fliplr(Corr),1);
    Corr =Corr+Corr2;
    Corr(Corr==2)=1;
    try chol(Corr);
    catch ME
        errordlg('Correlation matrix for GENS1 is not symmetric positive definite! Revise the values in the EXCEL file');
        return
    end
    EDP_Data.GENS1corr=Corr;
end

if Data_Status.GENS2==1
    EDP_Data.GENS2.S1 = xlsread(NRHADataExcelFileName,'GENS2','B3:EZ4');
    EDP_Data.GENS2median.S1 (1,:)=EDP_Data.GENS2.S1(1,:);
    EDP_Data.GENS2sigma.S1  (1,:)=EDP_Data.GENS2.S1(2,:);
    Corr = xlsread(NRHADataExcelFileName,'GENS2','C9:EZ58');
    Corr(isnan(Corr))=0.0;
    Corr2 = rot90(fliplr(Corr),1);
    Corr =Corr+Corr2;
    Corr(Corr==2)=1;
    try chol(Corr);
    catch ME
        errordlg('Correlation matrix for GENS2 is not symmetric positive definite! Revise the values in the EXCEL file');
        return
    end
    EDP_Data.GENS2corr=Corr;
end

if Data_Status.GENS3==1
    EDP_Data.GENS3.S1 = xlsread(NRHADataExcelFileName,'GENS3','B3:EZ4');
    EDP_Data.GENS3median.S1 (1,:)=EDP_Data.GENS3.S1(1,:);
    EDP_Data.GENS3sigma.S1  (1,:)=EDP_Data.GENS3.S1(2,:);
    Corr = xlsread(NRHADataExcelFileName,'GENS3','C9:EZ58');
    Corr(isnan(Corr))=0.0;
    Corr2 = rot90(fliplr(Corr),1);
    Corr =Corr+Corr2;
    Corr(Corr==2)=1;
    try chol(Corr);
    catch ME
        errordlg('Correlation matrix for GENS3 is not symmetric positive definite! Revise the values in the EXCEL file');
        return
    end
    EDP_Data.GENS3corr=Corr;
end

if Data_Status.GENF1==1
    EDP_Data.GENF1.S1 = xlsread(NRHADataExcelFileName,'GENF1','B3:EZ4');
    EDP_Data.GENF1median.S1 (1,2:N_Story+1)=EDP_Data.GENF1.S1(1,:);
    EDP_Data.GENF1sigma.S1  (1,2:N_Story+1)=EDP_Data.GENF1.S1(2,:);
    Corr = xlsread(NRHADataExcelFileName,'GENF1','C9:EZ58');
    Corr(isnan(Corr))=0.0;
    Corr2 = rot90(fliplr(Corr),1);
    Corr =Corr+Corr2;
    Corr(Corr==2)=1;
    try chol(Corr);
    catch ME
        errordlg('Correlation matrix for GENF1 is not symmetric positive definite! Revise the values in the EXCEL file');
        return
    end
    EDP_Data.GENF1corr=Corr;
end

if Data_Status.GENF2==1
    EDP_Data.GENF2.S1 = xlsread(NRHADataExcelFileName,'GENF2','B3:EZ4');
    EDP_Data.GENF2median.S1 (1,2:N_Story+1)=EDP_Data.GENF2.S1(1,:);
    EDP_Data.GENF2sigma.S1  (1,2:N_Story+1)=EDP_Data.GENF2.S1(2,:);
    Corr = xlsread(NRHADataExcelFileName,'GENF2','C9:EZ58');
    Corr(isnan(Corr))=0.0;
    Corr2 = rot90(fliplr(Corr),1);
    Corr =Corr+Corr2;
    Corr(Corr==2)=1;
    try chol(Corr);
    catch ME
        errordlg('Correlation matrix for GENF2 is not symmetric positive definite! Revise the values in the EXCEL file');
        return
    end
    EDP_Data.GENF2corr=Corr;
end

if Data_Status.GENF3==1
    EDP_Data.GENF3.S1 = xlsread(NRHADataExcelFileName,'GENF3','B3:EZ4');
    EDP_Data.GENF3median.S1 (1,2:N_Story+1)=EDP_Data.GENF3.S1(1,:);
    EDP_Data.GENF3sigma.S1  (1,2:N_Story+1)=EDP_Data.GENF3.S1(2,:);
    Corr = xlsread(NRHADataExcelFileName,'GENF3','C9:EZ58');
    Corr(isnan(Corr))=0.0;
    Corr2 = rot90(fliplr(Corr),1);
    Corr =Corr+Corr2;
    Corr(Corr==2)=1;
    try chol(Corr);
    catch ME
        errordlg('Correlation matrix for GENF3 is not symmetric positive definite! Revise the values in the EXCEL file');
        return
    end
    EDP_Data.GENF3corr=Corr;
end


end