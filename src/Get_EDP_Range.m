function [MaxEDP]=Get_EDP_Range(N_GM,MainDirectory,ResponseDataFolderPath,EDPFilename)
global MainDirectory


dirResult  = dir(ResponseDataFolderPath);
allDirs    = dirResult([dirResult.isdir]);
allSubDirs = allDirs(3:end);

for GM_No=1:N_GM
    % Go in the GM folder and read the results files
    thisDir = allSubDirs(GM_No);
    thisDirName = thisDir.name;
    cd (ResponseDataFolderPath); 
    cd(num2str(thisDirName))

    % Read IDA SDR Data File
    IDA_Data = importdata(EDPFilename);
    cd (MainDirectory);  
    IDA_Data(end,:)=[];
    EDP = IDA_Data(:,2:end);

    EDPmax(GM_No,1)=max(max(EDP));

    fclose all;
    clear EDP SA
end
    
MaxEDP=max(EDPmax);