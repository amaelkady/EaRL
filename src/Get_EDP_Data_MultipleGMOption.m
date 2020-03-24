function [EDP_Data,MaxSDR,MaxPFA,MaxVRD]=Get_EDP_Data_MultipleGMOption(NRHADataFilePath,NRHADataExcelFileName,Data_Status,N_GM,nStripe,EDP_Data)

cd (NRHADataFilePath);

% Read EDP data from Excel
for i=1:nStripe
                                     xx = xlsread(NRHADataExcelFileName,'SDR'     ,'B3:EZ300'); evalc(['EDP_Data.SDR.S',num2str(i),'=xx']);
                                     xx = xlsread(NRHADataExcelFileName,'PFA'     ,'B3:EZ300'); evalc(['EDP_Data.PFA.S',num2str(i),'=xx']);
    if Data_Status.RDR==1;           xx = xlsread(NRHADataExcelFileName,'RDR'     ,'B3:B300');  evalc(['EDP_Data.RDR.S',num2str(i),'=xx']);   end
    if Data_Status.VRD==1;           xx = xlsread(NRHADataExcelFileName,'VRD'     ,'B3:B300');  evalc(['EDP_Data.VRD.S',num2str(i),'=xx']);    end
    if Data_Status.LINKROT==1;       xx = xlsread(NRHADataExcelFileName,'LINK ROT','B3:EZ300'); evalc(['EDP_Data.LINKROT.S',num2str(i),'=xx']);end
    if Data_Status.COLROT==1;        xx = xlsread(NRHADataExcelFileName,'COL ROT', 'B3:EZ300'); evalc(['EDP_Data.COLROT.S', num2str(i),'=xx']);end
    if Data_Status.BEAMROT==1;       xx = xlsread(NRHADataExcelFileName,'BEAM ROT','B3:EZ300'); evalc(['EDP_Data.BEAMROT.S',num2str(i),'=xx']);end
    if Data_Status.DWD==1;           xx = xlsread(NRHADataExcelFileName,'DWD',     'B3:EZ300'); evalc(['EDP_Data.DWD.S',  num2str(i),'=xx']);  end
    if Data_Status.RD==1;            xx = xlsread(NRHADataExcelFileName,'RD',      'B3:EZ300'); evalc(['EDP_Data.RD.S',   num2str(i),'=xx']);  end
    if Data_Status.GENS1==1;         xx = xlsread(NRHADataExcelFileName,'GENS1',   'B3:EZ300'); evalc(['EDP_Data.GENS1.S',num2str(i),'=xx']);  end
    if Data_Status.GENS2==1;         xx = xlsread(NRHADataExcelFileName,'GENS2',   'B3:EZ300'); evalc(['EDP_Data.GENS2.S',num2str(i),'=xx']);  end
    if Data_Status.GENS3==1;         xx = xlsread(NRHADataExcelFileName,'GENS3',   'B3:EZ300'); evalc(['EDP_Data.GENS3.S',num2str(i),'=xx']);  end
    if Data_Status.GENF1==1;         xx = xlsread(NRHADataExcelFileName,'GENF1',   'B3:EZ300'); evalc(['EDP_Data.GENF1.S',num2str(i),'=xx']);  end
    if Data_Status.GENF2==1;         xx = xlsread(NRHADataExcelFileName,'GENF2',   'B3:EZ300'); evalc(['EDP_Data.GENF2.S',num2str(i),'=xx']);  end
    if Data_Status.GENF3==1;         xx = xlsread(NRHADataExcelFileName,'GENF3',   'B3:EZ300'); evalc(['EDP_Data.GENF3.S',num2str(i),'=xx']);  end
    if Data_Status.PFV==1;           xx = xlsread(NRHADataExcelFileName,'PFV',     'B3:EZ300'); evalc(['EDP_Data.PFV.S',  num2str(i),'=xx']);  end
    if Data_Status.ED==1;            xx = xlsread(NRHADataExcelFileName,'ED',      'B3:EZ300'); evalc(['EDP_Data.ED.S',   num2str(i),'=xx']);  end
end
                
% Get Median and Std of EDPs
EDP_Data.SDRmedian.S1 =  median(EDP_Data.SDR.S1(1:N_GM,:));
EDP_Data.SDRsigma.S1  = std(log(EDP_Data.SDR.S1(1:N_GM,:)));
MaxSDR=max(max(EDP_Data.SDRmedian.S1));
EDP_Data.SDRcorr=corrcoef (EDP_Data.SDR.S1);

EDP_Data.PFAmedian.S1 = median(EDP_Data.PFA.S1(1:N_GM,:));
EDP_Data.PFAsigma.S1  =std(log(EDP_Data.PFA.S1(1:N_GM,:)));
MaxPFA=max(max(EDP_Data.PFAmedian.S1));
EDP_Data.PFAcorr=corrcoef (EDP_Data.PFA.S1);

if Data_Status.RDR==1
    EDP_Data.RDRmedian.S1 =  median(EDP_Data.RDR.S1(1:N_GM,:));
    EDP_Data.RDRsigma.S1  = std(log(EDP_Data.RDR.S1(1:N_GM,:)));
    EDP_Data.RDRcorr=1;
end

MaxVRD=0;
if Data_Status.VRD==1
    EDP_Data.VRDmedian.S1 =  median(EDP_Data.VRD.S1(1:N_GM,:));
    EDP_Data.VRDsigma.S1  = std(log(EDP_Data.VRD.S1(1:N_GM,:)));
    MaxVRD = max(max(EDP_Data.VRDmedian.S1));
    EDP_Data.VRDcorr=1;
end

if Data_Status.LINKROT==1
    EDP_Data.LINKROTmedian.S1 = [0  median(EDP_Data.LINKROT.S1(1:N_GM,:))];
    EDP_Data.LINKROTsigma.S1  = [0 std(log(EDP_Data.LINKROT.S1(1:N_GM,:)))];
    EDP_Data.LINKROTcorr=corrcoef (EDP_Data.LINKROT.S1);
end

if Data_Status.COLROT==1
    EDP_Data.COLROTmedian.S1 =  median(EDP_Data.COLROT.S1(1:N_GM,:));
    EDP_Data.COLROTsigma.S1  = std(log(EDP_Data.COLROT.S1(1:N_GM,:)));
    EDP_Data.COLROTcorr=corrcoef (EDP_Data.COLROT.S1);
end

if Data_Status.BEAMROT==1
    EDP_Data.BEAMROTmedian.S1 = [0  median(EDP_Data.BEAMROT.S1(1:N_GM,:))];
    EDP_Data.BEAMROTsigma.S1  = [0 std(log(EDP_Data.BEAMROT.S1(1:N_GM,:)))];
    EDP_Data.BEAMROTcorr=corrcoef (EDP_Data.BEAMROT.S1);
end

if Data_Status.DWD==1
    EDP_Data.DWDmedian.S1 =  median(EDP_Data.DWD.S1(1:N_GM,:));
    EDP_Data.DWDsigma.S1  = std(log(EDP_Data.DWD.S1(1:N_GM,:)));
    EDP_Data.DWDcorr=corrcoef (EDP_Data.DWD.S1);
end

if Data_Status.RD==1
    EDP_Data.RDmedian.S1 =  median(EDP_Data.RD.S1(1:N_GM,:));
    EDP_Data.RDsigma.S1  = std(log(EDP_Data.RD.S1(1:N_GM,:)));
    EDP_Data.RDcorr=corrcoef (EDP_Data.RD.S1);
end

if Data_Status.GENS1==1
    EDP_Data.GENS1median.S1 =  median(EDP_Data.GENS1.S1(1:N_GM,:));
    EDP_Data.GENS1sigma.S1  = std(log(EDP_Data.GENS1.S1(1:N_GM,:)));
    EDP_Data.GENS1corr=corrcoef (EDP_Data.GENS1.S1);
end

if Data_Status.GENS2==1
    EDP_Data.GENS2median.S1 =  median(EDP_Data.GENS2.S1(1:N_GM,:));
    EDP_Data.GENS2sigma.S1  = std(log(EDP_Data.GENS2.S1(1:N_GM,:)));
    EDP_Data.GENS2corr=corrcoef (EDP_Data.GENS2.S1);
end

if Data_Status.GENS3==1
    EDP_Data.GENS3median.S1 =  median(EDP_Data.GENS3.S1(1:N_GM,:));
    EDP_Data.GENS3sigma.S1  = std(log(EDP_Data.GENS3.S1(1:N_GM,:)));
    EDP_Data.GENS3corr=corrcoef (EDP_Data.GENS3.S1);
end

if Data_Status.GENF1==1
    EDP_Data.GENF1median.S1 =  median(EDP_Data.GENF1.S1(1:N_GM,:));
    EDP_Data.GENF1sigma.S1  = std(log(EDP_Data.GENF1.S1(1:N_GM,:)));
    EDP_Data.GENF1corr=corrcoef (EDP_Data.GENF1.S1);
end

if Data_Status.GENF2==1
    EDP_Data.GENF2median.S1 =  median(EDP_Data.GENF2.S1(1:N_GM,:));
    EDP_Data.GENF2sigma.S1  = std(log(EDP_Data.GENF2.S1(1:N_GM,:)));
    EDP_Data.GENF2corr=corrcoef (EDP_Data.GENF2.S1);
end

if Data_Status.GENF3==1
    EDP_Data.GENF3median.S1 =  median(EDP_Data.GENF3.S1(1:N_GM,:));
    EDP_Data.GENF3sigma.S1  = std(log(EDP_Data.GENF3.S1(1:N_GM,:)));
    EDP_Data.GENF3corr=corrcoef (EDP_Data.GENF3.S1);
end

if Data_Status.PFV==1
    EDP_Data.PFVmedian.S1 =  median(EDP_Data.PFV.S1(1:N_GM,:));
    EDP_Data.PFVsigma.S1  = std(log(EDP_Data.PFV.S1(1:N_GM,:)));
    MaxPFV=max(max(EDP_Data.PFVmedian.S1));
    EDP_Data.PFVcorr=corrcoef (EDP_Data.PFV.S1);
end

if Data_Status.ED==1
    EDP_Data.EDmedian.S1 =  median(EDP_Data.ED.S1(1:N_GM,:));
    EDP_Data.EDsigma.S1  = std(log(EDP_Data.ED.S1(1:N_GM,:)));
    EDP_Data.ED=corrcoef (EDP_Data.ED.S1);
end

end