function [EmpDist, MedianCPS, SigmaCPS]=Get_Collapse_Fragility_IDA (CollapseSDR)
global MainDirectory ProjectName ProjectPath
clc;
cd (ProjectPath)
load(ProjectName,'N_GM','ResponseDataFolderPath','IDAFilename','CollapseSDR','IMend')
cd (MainDirectory)

dirResult = dir(ResponseDataFolderPath);
allDirs = dirResult([dirResult.isdir]);
allSubDirs = allDirs(3:end);

% Loop for GMs to Read Thier Collapse SA Values
for GM_No=1:N_GM
        thisDir = allSubDirs(GM_No);
        thisDirName = thisDir.name;
        cd (ResponseDataFolderPath); 
        cd(num2str(thisDirName))
    
    
    % Read IDA Max Data File
    IDA_SDR = importdata(IDAFilename.SDR);
    
    Sa = IDA_SDR (:,1);
    for i=1:size(IDA_SDR,1)
        IDA_SDR_Max (i,1)=  max(IDA_SDR (i,2:end)); % get the maximum SDR in the building at each SA intensity
    end
    
    % Loop over the maximum SDR values and if it exceeds the pre-defined
    % CollaspeSDR, interpolate to find the collapse SA
    for i=2:size(IDA_SDR_Max,1)
       if  IDA_SDR_Max (i,1) > CollapseSDR
           MaxSa(GM_No,1)=interp1(IDA_SDR_Max (i-1:i,1),Sa (i-1:i,1),CollapseSDR); 
           break
       else
           MaxSa(GM_No,1)=Sa(end,1);
       end
    end
    cd (MainDirectory); 
    
    clear IDA_SDR IDA_SDR_Max Sa
end

MaxSa=sort (MaxSa,1);    % Sort the Collapse SA Vector in Asscending Order

for i=1:size(MaxSa,1)
    EmpDist(i,1)=MaxSa(i,1);
    EmpDist(i,2)=i/N_GM;
end

Parameters=lognfit(MaxSa);
MedianCPS=Parameters(1);
SigmaCPS=Parameters(2);
if max(MaxSa)==min(MaxSa)
    MedianCPS=IMend;
    SigmaCPS=0.001;
end

end