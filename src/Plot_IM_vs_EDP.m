function Plot_IM_vs_EDP (N_GM,MainDirectory,ResponseDataFolderPath,EDPFilename,EDP_Type,Units)

dirResult = dir(ResponseDataFolderPath);
allDirs = dirResult([dirResult.isdir]);
allSubDirs = allDirs(3:end);

figure('position',[500 300 350 250],'color','white');
hold on; grid on; box on;
    
%%
if strcmp(EDP_Type,'SDR')==1 || strcmp(EDP_Type,'RDR')==1 || strcmp(EDP_Type,'COL ROT')==1  || strcmp(EDP_Type,'BEAM ROT')==1 || strcmp(EDP_Type,'DWD')==1 || strcmp(EDP_Type,'RD')==1 || strcmp(EDP_Type,'ED')==1 || strcmp(EDP_Type,'GENS1')==1 || strcmp(EDP_Type,'GENS2')==1 || strcmp(EDP_Type,'GENS3')==1

        MaxEDP=0;
        MaxSA=0;
    for GM_No=1:N_GM
        thisDir = allSubDirs(GM_No);
        thisDirName = thisDir.name;
        cd (ResponseDataFolderPath); 
        cd(num2str(thisDirName))
        Data= importdata(EDPFilename);
        evalc(sprintf(['IDA_EDP',num2str(GM_No) ,'= Data']));
        cd (MainDirectory);

        SA = Data (:,1);            EDP = max(Data(:,2:end),[] ,2);
        SA(end+1,1)=SA(end,1);      EDP(end+1,1)=0.2;
        
        MaxEDP = max(MaxEDP,EDP(end-1,1));
        MaxSA  = max(MaxSA,  SA(end-1,1));

        plot (EDP , SA , '-', 'Color',[0.6 0.6 0.6],'linewidth',1);      
        
        clear SA EDP
    end

    counter=1;
    % Calculate and Plot Median IDA Curves
    for DR = 0.0 : 0.001 : 0.2
        
        SA_Interp_EDP=zeros(N_GM,1);

        for GM_No=1:N_GM
            
            evalc(sprintf(['Data=IDA_EDP',num2str(GM_No) ]));

            SA = Data (:,1);            EDP = max(Data(:,2:end),[] ,2);
            SA(end+1,1)=SA(end,1);      EDP(end+1,1)=0.2;

            for i=1:size(SA,1)-1
                if DR>EDP(i,1) && DR<=EDP(i+1,1)
                    SA_Interp_EDP (GM_No)=SA(i,1)+(DR-EDP(i,1))*(SA(i+1,1)-SA(i,1))/(EDP(i+1,1)-EDP(i,1));
                    break;
                end
            end
            
            clear SA EDP
        end

        % Sort SA values at Drift values and then Calculate the 16th, 84th and Median
        SA_Interp_EDP=sort(SA_Interp_EDP); 
        Median50_Interp_EDP (counter) =  median(SA_Interp_EDP);
        Median16_Interp_EDP (counter) = (SA_Interp_EDP(ceil(0.16*GM_No))+SA_Interp_EDP(floor(0.16*GM_No)))/2;  
        Median84_Interp_EDP (counter) = (SA_Interp_EDP(ceil(0.84*GM_No))+SA_Interp_EDP(floor(0.84*GM_No)))/2;  
        MaxEDP_Vector       (counter) = DR;

        counter = counter + 1;
        
        clear SA_Interp_EDP
        
    end

    plot(MaxEDP_Vector,Median50_Interp_EDP, '-r' , 'linewidth',2.6);
    plot(MaxEDP_Vector,Median16_Interp_EDP, '-.r', 'linewidth',2.6);
    plot(MaxEDP_Vector,Median84_Interp_EDP, '-.r', 'linewidth',2.6);
    
    set(gca,'YLim',[0 ceil(MaxSA)]);
    set(gca,'XLim',[0 0.2]);

end

%*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%

if strcmp(EDP_Type,'PFA')==1 

        MaxEDP=0;
        MaxSA=0;
    for GM_No=1:N_GM

        thisDir = allSubDirs(GM_No);
        thisDirName = thisDir.name;
        cd (ResponseDataFolderPath); 
        cd(num2str(thisDirName))
        
        Data= importdata(EDPFilename);
        evalc(sprintf(['IDA_EDP',num2str(GM_No) ,'= Data']));
        cd (MainDirectory);

        SA = Data (:,1);            EDP = max(Data(:,3:end),[] ,2);
        SA(end+1,1)=5;              EDP(end+1,1)=max(max(Data(:,3:end),[] ,2));

        MaxEDP = max(MaxEDP,EDP(end-1,1));
        MaxSA  = max(MaxSA,  SA(end-1,1));
        
        plot (EDP , SA , '-', 'Color',[0.6 0.6 0.6],'linewidth',1);      

        clear EDP SA X
    end

    % Calculate and Plot Median IDA Curves 
        counter = 1;
    for SAval = 0.0:0.1:5

        SA_Interp_EDP=zeros(N_GM,1);

        for GM_No=1:N_GM
            
            evalc(sprintf(['Data=IDA_EDP',num2str(GM_No) ]));
            
            SA = Data (:,1);            EDP = max(Data(:,3:end),[] ,2);
            SA(end+1,1)=5;              EDP(end+1,1)=max(max(Data(:,3:end),[] ,2));

            for i=1:size(SA,1)-1
                if SAval>=SA(i,1) && SAval<SA(i+1,1)
                    SA_Interp_EDP (GM_No)=EDP(i,1)+(SAval-SA(i,1))*(EDP(i+1,1)-EDP(i,1))/(SA(i+1,1)-SA(i,1));
                    break;
                end
            end

            clear SA EDP

        end

        % Sort SA values at Drift values and then Calculate the 16th, 84th and Median
        SA_Interp_EDP=sort(SA_Interp_EDP); 
        Median50_Interp_EDP (counter) =  median(SA_Interp_EDP);
        Median16_Interp_EDP (counter) = (SA_Interp_EDP(ceil(0.16*N_GM))+SA_Interp_EDP(floor(0.16*N_GM)))/2;  
        Median84_Interp_EDP (counter) = (SA_Interp_EDP(ceil(0.84*N_GM))+SA_Interp_EDP(floor(0.84*N_GM)))/2;  
        MaxEDP_Vector       (counter) =  SAval;

        counter = counter + 1;
        
        clear SA_Interp_EDP
    end

    plot(Median50_Interp_EDP,MaxEDP_Vector, '-r' , 'linewidth',2.6);
    plot(Median16_Interp_EDP,MaxEDP_Vector, '-.r', 'linewidth',2.6);
    plot(Median84_Interp_EDP,MaxEDP_Vector, '-.r', 'linewidth',2.6);    
        
    set(gca,'YLim',[0 ceil(MaxSA)]);
    set(gca,'XLim',[0 min(5,ceil(MaxEDP))]) 
    
end

%*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%

if strcmp(EDP_Type,'VRD')==1

        MaxSA=0;
        MaxEDP=0;
    for GM_No=1:N_GM     % Loop for GMs IDAs to be Plotted
        thisDir = allSubDirs(GM_No);
        thisDirName = thisDir.name;
        cd (ResponseDataFolderPath); 
        cd(num2str(thisDirName))
        Data= importdata(EDPFilename);
        evalc(sprintf(['IDA_EDP',num2str(GM_No) ,'= Data']));
        cd (MainDirectory);

        SA = Data (:,1);            EDP = max(Data(:,2:end),[] ,2);
        SA(end+1,1)=SA(end,1);      EDP(end+1,1)=1000;
        
        MaxEDP = max(MaxEDP,EDP(end-1,1));
        MaxSA  = max(MaxSA,  SA(end-1,1));
        
        plot (EDP , SA , '-', 'Color',[0.6 0.6 0.6],'linewidth',1);      

        clear EDP SA
    end

    % Calculate and Plot Median IDA Curves 
        counter = 1;
    for VRD = 0.0:1:1000

        SA_Interp_EDP=zeros(N_GM,1);

        for GM_No=1:N_GM                % Loop for GMs 
            
            evalc(sprintf(['Data=IDA_EDP',num2str(GM_No)]));
            
            SA = Data (:,1);            EDP = max(Data(:,2:end),[] ,2);
            SA(end+1,1)=SA(end,1);      EDP(end+1,1)=1000;

            for i=1:size(SA,1)-1
                if VRD>=EDP(i,1) && VRD<EDP(i+1,1)
                    SA_Interp_EDP (GM_No)=SA(i,1)+(VRD-EDP(i,1))*(SA(i+1,1)-SA(i,1))/(EDP(i+1,1)-EDP(i,1));
                    break;
                end
            end

            clear EDP SA
        end

        % Sort SA values at Drift values and then Calculate the 16th, 84th and Median
        SA_Interp_EDP=sort(SA_Interp_EDP); 
        Median50_Interp_VRD(counter)=median(SA_Interp_EDP);
        Median16_Interp_VRD(counter)=(SA_Interp_EDP(ceil(0.16*N_GM))+SA_Interp_EDP(floor(0.16*N_GM)))/2;  
        Median84_Interp_VRD(counter)=(SA_Interp_EDP(ceil(0.84*N_GM))+SA_Interp_EDP(floor(0.84*N_GM)))/2;  
        MaxEDP_Vector (counter)=VRD;

        counter = counter + 1;

        clear SA_Interp_EDP

    end

    plot(MaxEDP_Vector, Median50_Interp_VRD, '-r', 'linewidth',2.6);
    plot(MaxEDP_Vector, Median16_Interp_VRD, '-.r', 'linewidth',2.6);
    plot(MaxEDP_Vector, Median84_Interp_VRD, '-.r', 'linewidth',2.6);

    set(gca,'YLim',[0 MaxSA*1.3]);
    set(gca,'XLim',[0 MaxEDP*1.1]);

end

ylabel ('IM [g]', 'fontname', 'Times', 'fontsize',15);
xlabel ([EDP_Type, ' [rad]'], 'fontname', 'Times', 'fontsize',15);
if strcmp(EDP_Type,'PFA')==1 || strcmp(EDP_Type,'PGA')==1; xlabel ('PFA [g]', 'fontname', 'Times', 'fontsize',15); end
if strcmp(EDP_Type,'VRD')==1 && Units==1; xlabel ('VRD [mm]', 'fontname', 'Times', 'fontsize',15); end
if strcmp(EDP_Type,'VRD')==1 && Units==2; xlabel ('VRD [in]', 'fontname', 'Times', 'fontsize',15); end
if strcmp(EDP_Type,'PFV')==1 && Units==1; xlabel ('PFV [m/sec]', 'fontname', 'Times', 'fontsize',15); end
if strcmp(EDP_Type,'PFV')==1 && Units==2; xlabel ('PFV [in/sec]', 'fontname', 'Times', 'fontsize',15); end
set(gca,'fontname', 'Times', 'fontsize',15) 
