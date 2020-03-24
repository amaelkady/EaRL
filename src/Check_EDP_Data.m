function [errorflag]=Check_EDP_Data (N_Story,N_GM,MainDirectory,ResponseDataFolderPath,EDPFilename,EDP_Type)
    
errorflag=0;

dirResult = dir(ResponseDataFolderPath);
allDirs = dirResult([dirResult.isdir]);
allSubDirs = allDirs(3:end);
%%
if strcmp(EDP_Type,'SDR')==1 || strcmp(EDP_Type,'COL ROT')==1 

    for GM_No=1:N_GM
        thisDir = allSubDirs(GM_No);
        thisDirName = thisDir.name;
        cd (ResponseDataFolderPath); 
        cd(num2str(thisDirName))
    
        X= importdata(EDPFilename);
        if isstruct(X)==1
            X= X.data;            
        end
        cd (MainDirectory);
        SA  = X (:,1);
        EDP = X (:,2:end);
        
        % Checks
        if issorted(SA,'ascend')==0
            errordlg(['The IM data in ',EDPFilename, ' are not in an ascending order for ground-motion record number ',num2str(GM_No),'(',thisDirName,')','!']);
            errorflag=1; return;
        end
        
        if length(SA) ~= length(unique(SA))
            errordlg(['Some of the IM values in ',EDPFilename, ' are repeated for ground-motion record number ',num2str(GM_No),'(',thisDirName,')','!']);
            errorflag=1; return;
        end
        
        if size(EDP,2)~=N_Story
            errordlg(['The EDP data in ',EDPFilename, ' are not provided at each story for ground-motion record number ',num2str(GM_No),'(',thisDirName,')','!']);
            errorflag=1; return;
        end
        
        clear EDP SA X
    end

   
elseif strcmp(EDP_Type,'RDR')==1

    for GM_No=1:N_GM

        thisDir = allSubDirs(GM_No);
        thisDirName = thisDir.name;
        cd (ResponseDataFolderPath); 
        cd(num2str(thisDirName))
    
        X= importdata(EDPFilename);
        if isstruct(X)==1
            X= X.data;            
        end
        cd (MainDirectory);
        SA  = X (:,1);
        EDP = X (:,2:end);

        % Checks
        if issorted(SA,'ascend')==0
            errordlg(['The IM data in ',EDPFilename, ' are not in an ascending order for ground-motion record number ',num2str(GM_No),'(',thisDirName,')','!']);
            errorflag=1; return;
        end
        
        if size(EDP,2)~=1
            errordlg(['The RDR data in ',EDPFilename, ' are not provided for ground-motion record number ',num2str(GM_No),'(',thisDirName,')','!']);
            errorflag=1; return;
        end
        
        clear EDP SA X
    end
    
elseif strcmp(EDP_Type,'BEAM ROT')==1 
    
    for GM_No=1:N_GM
        thisDir = allSubDirs(GM_No);
        thisDirName = thisDir.name;
        cd (ResponseDataFolderPath); 
        cd(num2str(thisDirName))
        
        X= importdata(EDPFilename);
        if isstruct(X)==1
            X= X.data;            
        end
        cd (MainDirectory);
        SA  = X (:,1);
        EDP = X (:,2:end);

        % Checks
        if issorted(SA,'ascend')==0
            errordlg(['The IM data in ',EDPFilename, ' are not in an ascending order for ground-motion record number ',num2str(GM_No),'(',thisDirName,')','!']);
            errorflag=1; return;
        end
        
        if size(EDP,2)~=N_Story
            errordlg(['The EDP data in ',EDPFilename, ' are not provided at each floor for ground-motion record number ',num2str(GM_No),'(',thisDirName,')','!']);
            errorflag=1; return;
        end

        clear EDP SA X
    end
    
elseif strcmp(EDP_Type,'PFA')==1
    
    for GM_No=1:N_GM
        thisDir = allSubDirs(GM_No);
        thisDirName = thisDir.name;
        cd (ResponseDataFolderPath); 
        cd(num2str(thisDirName))
        
        X= importdata(EDPFilename);
        if isstruct(X)==1
            X= X.data;            
        end
        cd (MainDirectory);
        SA  = X (:,1);
        EDP = X (:,2:end);

        % Checks
        if issorted(SA,'ascend')==0
            errordlg(['The IM data in ',EDPFilename, ' are not in an ascending order for ground-motion record number ',num2str(GM_No),'(',thisDirName,')','!']);
            errorflag=1; return;
        end
        
        if size(EDP,2)~=N_Story+1
            errordlg(['The EDP data in ',EDPFilename, ' are not provided at each floor for ground-motion record number ',num2str(GM_No),'(',thisDirName,')','!']);
            errorflag=1; return;
        end

        clear EDP SA X
    end
    
elseif strcmp(EDP_Type,'VRD')==1 
    
    for GM_No=1:N_GM
        thisDir = allSubDirs(GM_No);
        thisDirName = thisDir.name;
        cd (ResponseDataFolderPath); 
        cd(num2str(thisDirName))
        
        X= importdata(EDPFilename);
        if isstruct(X)==1
            X= X.data;            
        end
        cd (MainDirectory);
        SA  = X (:,1);
        EDP = X (:,2:end);

        % Checks
        if issorted(SA,'ascend')==0
            errordlg(['The IM data in ',EDPFilename, ' are not in an ascending order for ground-motion record number ',num2str(GM_No),'(',thisDirName,')','!']);
            errorflag=1; return;
        end
        
%         if issorted(EDP,'ascend')==0
%             errordlg(['The VRD data in ',EDPFilename, ' are not in an ascending order for ground-motion record number ',num2str(GM_No),'(',thisDirName,')','!']);
%             errorflag=1; return;
%         end
        
        if size(EDP,2)~=1
            errordlg(['The VRD data in ',EDPFilename, ' are not provided for ground-motion record number ',num2str(GM_No),'(',thisDirName,')','!']);
            errorflag=1; return;
        end
        
        clear EDP SA X
    end

end