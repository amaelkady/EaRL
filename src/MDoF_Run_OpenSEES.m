%##########################################################################################################
%##########################################################################################################
%##########################################################################################################
%#              Auto-Run of an OpenSEES MDoF Stick Model for a Set of Ground Motion Records      
%#                              
%#
%# Written by: Dr. Ahmed Elkady, University of Southampton
%# Date Created: 10 Nov 2019
%# Last Updated: 20 Jan 2020
%# 
%##########################################################################################################
%##########################################################################################################
%##########################################################################################################

function MDoF_Run_OpenSEES (app)
global MainDirectory ProjectName ProjectPath
clc;
cd(ProjectPath);
load(ProjectName,'Option5Data');
cd (MainDirectory);

v2struct(Option5Data); % unpack Option5Data 

%% Clear Screen and Close Variables and Any All Opened Files
clc; fclose('all')

% Calculation of Story Heights
H1=HStory(1);
HT=HStory(2);
H=sum(HStory);

TransformationX=2;
SA_Step=0.2;
SAstepmin=0.05;

RFname='Results';
SA_metric=1;

%% Opens a Text File 'AllGMinfo.txt' and Read All GM Records Data
cd (GMFolderPath);                                 % Go Inside the GroundMotions Folder
fileID1 = fopen('AllGMinfo.txt','r');             % Open the Text File with the GM info to read data
AllData= textscan (fileID1, '%d %s %d %f %f');    % Read the No., Name, No. of Points, dt and PGA of all GMs
fclose (fileID1);                                 % Close the Text File with the GM info
AllGMno     = AllData {1,1};
AllGMname   = AllData {1,2};
AllGMpoints = AllData {1,3};
AllGMdt     = AllData {1,4};
AllGMpga    = AllData {1,5};
cd (MainDirectory);

mkdir(RFname);

%##########################################################################################################
%##########################################################################################################
%##########################################################################################################
%##########################################################################################################
%##########################################################################################################
%##########################################################################################################
%##########################################################################################################
%##########################################################################################################

%% Opens a Text File 'Run.txt' and Write the Analysis Paramters
fileID2=fopen('Run.txt','wt');             
fprintf(fileID2,'%d\n%d\n%s\n%s\n%d\n%d\n%d\n%5.3f\n',1,TransformationX,RFname,GMFolderName, NEigenModes, DampModeI, DampModeJ, zeta);

%% LOOP OVER GMs
for GM_No=1:N_GM                        
	app.text99.Text=['Running GM #',num2str(GM_No),'/',num2str(N_GM)];
	app.text99.FontColor='y';
    app.ProgressBar.Position=[8 4 GM_No/N_GM*220 6];
    app.ProgressBar.BackgroundColor='g';
    drawnow
    	
    %% CLEAR IDA STORAGE VECTORS AND INITIALIZE VARIABLES EACH NEW GM
    clear GM DATA IncrDATA; fclose('all');
	
    Collapse_Flag = 0;
    SAstep = SA_Step;
    DATA.SA_last_NC = 0;
	DATA.SDR_last_NC = 0;
	DATA.PFA_last_NC = 0;
    DATA.IDASlope_last_NC=1;
    DATA.SDRincrmax = 0;
    DATA.PFAincrmax = 0;
    IncrNo = 2;
    SAcurrent = SAstep;                       
    IncrDATA.SA(1) = 0;
    AnalysisCount = 0;
	ALL_ANALYSED_SAs(1) = 0;
	FigI = 0;
    Collapse = 0;
    
    %% GET CURRENT GM DATA AND WRITE IT IN A TEXT FILE 'GMinfo.txt'
    GM.GMname 	  = AllGMname{GM_No};         % Get Current GM Name
    GM.GMpga  	  = AllGMpga (GM_No);         % Get Current GM pga
    GM.GMdt   	  = AllGMdt  (GM_No);         % Get Current GM dt
    GM.GMnpoints  = AllGMpoints  (GM_No);     % Get Current GM number of data points
    GM.GMduration = GM.GMdt*GM.GMnpoints;
    fileID2=fopen('GMinfo.txt','wt');             
    fprintf(fileID2,'%d\n%s\n%d\n%f\n%f',GM_No,GM.GMname,GM.GMnpoints,GM.GMdt,GM.GMpga);  
	
    %% GET IM FOR SCALING
    [GM] = MDoF_Get_IM (GMFolderPath, T1, GM, g, 0.05, SA_metric);
	cd (MainDirectory)

    %% IDA MAIN LOOP
    while SAcurrent < 10.0                           														% Run as long as Collapse is not reached (Arbitrary High Value Since Program Stops at Collapse)
        clc; fclose('all');
		AnalysisCount=AnalysisCount+1;
		[SAprerunstatus,indx]=ismember(SAcurrent,ALL_ANALYSED_SAs);
        if SAprerunstatus==1
			SAcurrent=mean([ALL_ANALYSED_SAs(indx) ALL_ANALYSED_SAs(min(indx+1,AnalysisCount-1))]);
        end
        if Dynamic_TargetSF==1
            SFcurrent=SF;
            SAcurrent=SFcurrent*GM.GMpsaT1; 
        elseif Dynamic_TargetSA==1
            SFcurrent=TargetSA/GM.GMpsaT1;
            SAcurrent=TargetSA; 
        else
            SFcurrent=SAcurrent/GM.GMpsaT1;                                                                 % Calculate Current Scale Factor for Current SA
        end
        fileID3=fopen('CollapseState.txt','wt');     														% Create/Open and Clear contents of CollapseState.txt file each increment
        fileID4=fopen('SF.txt','wt');                														% Create/Open and Clear contents of SF.txt file each increment
        fprintf(fileID4,'%f',SFcurrent);             														% Write value of the Scale Factor of the current GM to SF.txt file 
		
		ALL_ANALYSED_SAs(AnalysisCount)=SAcurrent;
		ALL_ANALYSED_SAs=sort(ALL_ANALYSED_SAs);
				
        % RUN OPENSEES MODEL 
        ! OpenSees.exe Option5.tcl

        % READ OPENSEES OUTPUT FILES
        [DATA] = MDoF_Read_Data (MainDirectory,RFname,GM,GMFolderPath,N_Story,g,SFcurrent,DATA);
		
        % CHECK IF NUMERICAL INSTABILITY
        if DATA.SDRincrmax > 0.2 || DATA.PFAincrmax > 20; NumInstability_Flag = 1; else; NumInstability_Flag = 0; end

        % CHECK IF COLLAPSE OCCURED AND TRACE COLLAPSE POINT IF SO
        Collapse = textread('CollapseState.txt','%d');                              						% Read Value of Collapse Index (reads 1 for collapse)
        if isempty(Collapse); Collapse=0; end
		
        if DATA.SDRincrmax > 0.15                                                                           % In Case of Collapse
            SAcurrent = max(DATA.SA_last_NC+0.01, SAcurrent - 0.5 * SAstep);             					% Roll Back 1/2 Step 
            SAstep    = max(0.02, 0.5 * SAstep);                                    						% Modify Step Size to 1/2 of Previous Step 
            Collapse_Flag = 999;                                                    						% Identifier for Collapse 
        else                                                                        						% In Case of No-Collapse 

			if NumInstability_Flag == 0
                [IncrDATA] = MDoF_Save_Incr_Data (MainDirectory,RFname,GM,N_Story,IncrNo, SAcurrent,DATA,g,SFcurrent,IncrDATA);
                if IncrNo<=2; IDASlope_Ratio=1; IDASlope_0=SAcurrent/DATA.SDRincrmax; else; IDASlope_Ratio=abs((SAcurrent-DATA.SA_last_NC)/(DATA.SDRincrmax-DATA.SDR_last_NC))/IDASlope_0; end % added 08/2019
                DATA.IDASlope_last_NC=abs((SAcurrent-DATA.SA_last_NC)/(DATA.SDRincrmax-DATA.SDR_last_NC));                                                          % added 08/2019
                
                DATA.SA_last_NC  = SAcurrent;
                DATA.SDR_last_NC = DATA.SDRincrmax;
				DATA.PFA_last_NC = DATA.PFAincrmax;
                AdaptiveTimeStep=1;

                if AdaptiveTimeStep==1 && Collapse_Flag ~= 999                                              % added 08/2019 for adaptive time stepping
                    SAstep     = max(min(IDASlope_Ratio*SAstep,SAstep),SAstepmin+0.01);
                    SAcurrent  = SAcurrent + SAstep;                                                        % Move to Next SA level by a Step proportional to slope ratio
                else
                    if DATA.SDR_last_NC<0.05
                    SAcurrent  = SAcurrent + SAstep;                                    					% Move to Next SA level by 1 Step
                    else
                    SAcurrent  = SAcurrent + 0.5* SAstep;                                    				% Move to Next SA level by 0.5 Step				
                    end
                end
                IncrNo     = IncrNo    + 1;                                         						% Increase Counter for IDA Vectors IncrNos 
                if SAstep <= SAstepmin   ; break; end                                                       % Exit Criteria 1: When last No-Collapse Point is Located by Specified Accuracy
                if SAstep <  SAstepmin/10; break; end                                                       % Exit Criteria 2: If the Step Time for Tracing Collapse Point Became Too Small
           else
                if Collapse_Flag == 999
                    SAcurrent = max(DATA.SA_last_NC+0.01, SAcurrent - 0.01);
                else
                    SAcurrent = SAcurrent + 0.01;
                end
            end
        end
		
	    if SAcurrent==DATA.SA_last_NC+0.01; 		    break; end             		% Exit Criteria 4: When tracing algorithm roles back to last NC point
        if Dynamic_TargetSA==1; break; end
        if Dynamic_TargetSF==1; break; end
    end

    if IDA==1; Delete_Flag=1; else Delete_Flag=0; end
	if IDA==1; MDoF_Save_IDA_Data(MainDirectory,RFname,GM,N_Story,IncrNo,IncrDATA,Delete_Flag); end
    if Dynamic_TargetSF==1 || Dynamic_TargetSA==1
        EDP_Data.SDR.S1(GM_No,:)=DATA.SDRincrmaxi;
        EDP_Data.PFA.S1(GM_No,:)=DATA.PFAincrmaxi;
        EDP_Data.RDR.S1(GM_No,:)=DATA.RDRincrmaxi;
    end
	
	
end

if Dynamic_TargetSF==1 || Dynamic_TargetSA==1
    if N_GM>1
        EDP_Data.SDRmedian.S1=median(EDP_Data.SDR.S1); 
        EDP_Data.RDRmedian.S1=max(median(EDP_Data.RDR.S1)); 
        EDP_Data.PFAmedian.S1=median(EDP_Data.PFA.S1); 

        EDP_Data.SDRsigma.S1=std(log(EDP_Data.SDR.S1));
        EDP_Data.RDRsigma.S1=max(std(log(EDP_Data.RDR.S1)));
        EDP_Data.PFAsigma.S1=std(log(EDP_Data.PFA.S1)); 
    else
        EDP_Data.SDRmedian.S1=(EDP_Data.SDR.S1); 
        EDP_Data.RDRmedian.S1=max(EDP_Data.RDR.S1); 
        EDP_Data.PFAmedian.S1=(EDP_Data.PFA.S1); 

        EDP_Data.SDRsigma.S1=0.0;
        EDP_Data.RDRsigma.S1=0.0;
        EDP_Data.PFAsigma.S1=0.0; 
    end
    EDP_Data.SDRcorr=eye(N_Story);
    EDP_Data.RDRcorr=1;
    EDP_Data.PFAcorr=eye(N_Story+1); 
end
   
fclose('all');

cd (ProjectPath);
if Dynamic_TargetSF==1 || Dynamic_TargetSA==1
    save(ProjectName, 'EDP_Data', '-append');
end

cd (MainDirectory);
delete('Temp.tcl')
delete('Option5.tcl')
delete('CollapseState.txt')
delete('GMinfo.txt')
delete('Periods.txt')
delete('Run.txt')
delete('SF.txt')

