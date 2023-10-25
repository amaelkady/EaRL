function [MedianEDP,SigmaEDP]=Get_EDP_Fargiltiy_Paramters_at_IM(app,IMpoints,N_GM,ResponseDataFolderPath,EDP_Type,EDPFilename,N_Story)
global MainDirectory

app.ProgressText.Value=['DEDUCING ', EDP_Type, ' values at IMs'];

dirResult  = dir(ResponseDataFolderPath);
allDirs    = dirResult([dirResult.isdir]);
allSubDirs = allDirs(3:end);

IMpoints=IMpoints';
nIMpoints=size(IMpoints,1);

MedianEDP = zeros(nIMpoints,N_Story);
SigmaEDP  = zeros(nIMpoints,N_Story);

%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------%

for GM_No=1:N_GM
    % Go in the GM folder and read the results files
    thisDir = allSubDirs(GM_No);
    thisDirName = thisDir.name;
    cd (ResponseDataFolderPath); 
    cd(num2str(thisDirName))

    % Read IDA Data File
    IDA_Data = importdata(EDPFilename);
    cd (MainDirectory);  
    SA  = IDA_Data(:,1);
    EDP = IDA_Data(:,2:end);

    if strcmp(EDP_Type,'SDR')==1 || strcmp(EDP_Type,'RDR')==1 || strcmp(EDP_Type,'COL ROT')==1  || strcmp(EDP_Type,'BEAM ROT')==1 || strcmp(EDP_Type,'DWD')==1 || strcmp(EDP_Type,'RD')==1
        SA(end,1)=SA(end,1)+0.001; SA(end+1,1)=SA(end,1)+0.001;     EDP(end+1,:)=0.2;
    elseif strcmp(EDP_Type,'PFA')==1
        SA(end,1)=SA(end,1)+0.001; SA(end+1,1)=SA(end,1)+0.001;     EDP(end+1,:)=max(max(EDP(:,2:end),[] ,2));
    elseif strcmp(EDP_Type,'VRD')==1
        SA(end,1)=SA(end,1)+0.001; 
    end
    
    % Remove rows with NaN values
    for i=1:size(SA,1)
       if isnan(SA(i,1)) || isnan(EDP(i,1))
           SA(i,:)=[];
           EDP(i,:)=[];
       end
    end
    
    % Get the IDA curve for each GM with refined and consistent IM points
    SA_Refined=IMpoints;
    for Storyi=1:N_Story
        EDP_Refined=zeros(size(IMpoints,1),1);
        for i=1:size(IMpoints,1)
            if IMpoints(i)<max(SA)
                EDP_Refined(i,1)=interp1(SA,EDP(:,Storyi),IMpoints(i));
            else
                EDP_Refined(i,1)=max(EDP(:,Storyi))+0.00001;
            end
        end
        evalc(['EDP_Refined', num2str(Storyi),'(:,GM_No)=EDP_Refined']);
    end

    SA_CPS(GM_No)=SA(end);

    app.ProgressBar.Position=[9 5 0.25*613 6];
    drawnow
    
    fclose all;
    clear EDP SA EDP_Refined
    

end

SA_CPS_MAX=max(SA_CPS);

% Deduce the Median EDP value and associated sigma(ln_EDP) value at each IM based on the surviving GM records
for Storyi=1:N_Story
    evalc(['EDP_Refined=EDP_Refined', num2str(Storyi)]);
    INDX_LAST_SA_ALL_SURVIVE=size(IMpoints,1);
    INDX_FIRST_SA_NO_SURVIVE=size(IMpoints,1);

    for i=1:nIMpoints
        IMi=IMpoints(i,1);
        [countSurvive,EDP_survive,INDX_LAST_SA_ALL_SURVIVE,INDX_FIRST_SA_NO_SURVIVE]= Count_Surviving_GMs(N_GM,SA_Refined,EDP_Refined,IMi,i,INDX_LAST_SA_ALL_SURVIVE,INDX_FIRST_SA_NO_SURVIVE);

        % Save the median and sigma EDP values of the surviving records
        % If a SA value is reached at which no records survive, set sigma EDP as 0.01 and median EDP as the maximum value recored so far
        if countSurvive==0
            MedianEDP(i,Storyi)=999;
            SigmaEDP (i,Storyi)=0.01;        
        else
            MedianEDP(i,Storyi)=median(EDP_survive);
            SigmaEDP (i,Storyi)=std(log(EDP_survive));
        end
    end

    MedianEDP(MedianEDP(:,Storyi)==999)=max(MedianEDP(:,Storyi));
    SigmaEDP(isnan(SigmaEDP))=0.01;

    allindx_LAST_SA_ALL_SURVIVE(Storyi)=INDX_LAST_SA_ALL_SURVIVE; 
    allindx_FIRST_SA_NO_SURVIVE(Storyi)=INDX_FIRST_SA_NO_SURVIVE; 

    app.ProgressBar.Position=[9 5 0.50*613 6];
    drawnow
    
    clear EDP_survive
end

for Storyi=1:N_Story
    MedianEDP(allindx_FIRST_SA_NO_SURVIVE(Storyi):end,Storyi)=max(MedianEDP(1:allindx_FIRST_SA_NO_SURVIVE(Storyi)-1,Storyi));
end

% Modify Median IDA curve so that EDP values are always increasing with higher IM amplitudes
for i=2:size(MedianEDP,1)
    for Storyi=1:N_Story
        if MedianEDP(i,Storyi)<MedianEDP(i-1,Storyi)
             MedianEDP(i,Storyi)= MedianEDP(i-1,Storyi);
        end
    end
end

for i=size(MedianEDP,1):-1:2
    for Storyi=1:N_Story
        flag=0;
        if MedianEDP(i,Storyi)==MedianEDP(i-1,Storyi) && flag==0
             allindx_last_peak(Storyi)= min(nIMpoints-1,i);
        else
            flag=1;
             break;
        end
    end
    if flag==1
        break;
    end
end

for Storyi=1:N_Story
    indx_LAST_SA_ALL_SURVIVE=allindx_LAST_SA_ALL_SURVIVE(Storyi);
    indx_FIRST_SA_NO_SURVIVE=allindx_FIRST_SA_NO_SURVIVE(Storyi);
    indx_last_peak=allindx_last_peak(Storyi);

    MedianEDP(MedianEDP<=0)=0.00001;

    AveragingIncr=floor(indx_last_peak/20);
    for i=1:nIMpoints
        if IMpoints(i,1)<SA_CPS_MAX
            MedianEDP(i,Storyi)=mean(MedianEDP(i:min(i+AveragingIncr,nIMpoints),Storyi));
        else
            MedianEDP(i,Storyi)=max(MedianEDP(:,Storyi));
            SigmaEDP (i,Storyi)=0.00001;
        end

    end
    MedianEDP(:,Storyi)=MedianEDP(:,Storyi)-MedianEDP(1,Storyi);
    MedianEDP(MedianEDP<=0)=0.00001;

    if N_GM<5
        SigmaEDP=zeros(size(IMpoints,1),N_Story)+0.01;
    else
        g = fittype('a*x^3+b*x^2+c*x');
        f=fit(IMpoints(1:indx_FIRST_SA_NO_SURVIVE-1,1),SigmaEDP(1:indx_FIRST_SA_NO_SURVIVE-1,Storyi),g);
        SigmaEDP(1:indx_FIRST_SA_NO_SURVIVE-1,Storyi)=feval(f,IMpoints(1:indx_FIRST_SA_NO_SURVIVE-1,1));
        SigmaEDP(SigmaEDP<=0)=0.01;
    end
    
    app.ProgressBar.Position=[9 5 1*613 6];
    drawnow
    
    clear EDP_Refined  SA_Refined MedianEDP1
end
