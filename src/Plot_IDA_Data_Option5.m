function Plot_IDA_Data_Option5 (N_GM,MainDirectory,ResponseDataFolderPath,SDRFilename,PFAFilename,RDRFilename)

dirResult = dir(ResponseDataFolderPath);
allDirs = dirResult([dirResult.isdir]);
allSubDirs = allDirs(3:end);

figure('position',[500 300 900 250],'color','white');
    
%%
subplot(1,3,1)
hold on; grid on; box on;

        MaxEDP=0;
        MaxSA=0;
    for GM_No=1:N_GM
        thisDir = allSubDirs(GM_No);
        thisDirName = thisDir.name;
        cd (ResponseDataFolderPath); 
        cd(num2str(thisDirName))
        Data= importdata(SDRFilename);
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

ylabel ('IM [g]', 'fontname', 'Times', 'fontsize',15);
xlabel ('SDR_{max} [rad]', 'fontname', 'Times', 'fontsize',15);
set(gca,'fontname', 'Times', 'fontsize',15) 


%*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%
clear Median50_Interp_EDP Median16_Interp_EDP Median84_Interp_EDP MaxEDP_Vector

subplot(1,3,2)
hold on; grid on; box on;

        MaxEDP=0;
        MaxSA=0;
    for GM_No=1:N_GM
        thisDir = allSubDirs(GM_No);
        thisDirName = thisDir.name;
        cd (ResponseDataFolderPath); 
        cd(num2str(thisDirName))
        Data= importdata(RDRFilename);
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
ylabel ('IM [g]', 'fontname', 'Times', 'fontsize',15);
xlabel ('RDR_{max} [rad]', 'fontname', 'Times', 'fontsize',15);
set(gca,'fontname', 'Times', 'fontsize',15) 

    %*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%
clear Median50_Interp_EDP Median16_Interp_EDP Median84_Interp_EDP MaxEDP_Vector

subplot(1,3,3)
hold on; grid on; box on;

    MaxEDP=0;
    MaxSA=0;
for GM_No=1:N_GM

    thisDir = allSubDirs(GM_No);
    thisDirName = thisDir.name;
    cd (ResponseDataFolderPath); 
    cd(num2str(thisDirName))

    Data= importdata(PFAFilename);
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
Median50_Interp_EDP(:,end)=[];
Median16_Interp_EDP(:,end)=[];
Median84_Interp_EDP(:,end)=[];
MaxEDP_Vector(:,end)=[];

plot(Median50_Interp_EDP,MaxEDP_Vector, '-r' , 'linewidth',2.6);
plot(Median16_Interp_EDP,MaxEDP_Vector, '-.r', 'linewidth',2.6);
plot(Median84_Interp_EDP,MaxEDP_Vector, '-.r', 'linewidth',2.6);    

set(gca,'YLim',[0 ceil(MaxSA)]);
set(gca,'XLim',[0 min(5,ceil(MaxEDP))]) 
ylabel ('IM [g]', 'fontname', 'Times', 'fontsize',15);
xlabel ('PFA_{max} [g]', 'fontname', 'Times', 'fontsize',15);
set(gca,'fontname', 'Times', 'fontsize',15) 


%*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%
%*******************************************************************************************************************%
