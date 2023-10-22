function Plot_EDP_Profile (N_Story,MainDirectory,ExcelFilePath,ExcelFileName,Response_Option,EDP_Type,Units,N_GM,Stripe)

figure('position',[500 300 300 300],'color','white');
set(gca, 'fontname', 'times', 'fontsize',15) 
grid on; box on; hold on
if Response_Option==2 || Response_Option==4
    if strcmp(EDP_Type,'RDR')==1 || strcmp(EDP_Type,'VRD')==1
        scatter([-10 -10],[-10 -10],'o');    
    else
        plot([-10 -10],[-10 -10],'-','color',[0.65 0.65 0.65]);        
    end
    plot([-10 -10],[-10 -10],'-or','linewidth',2);
    plot([-10 -10],[-10 -10],'--b','linewidth',1);
end

if Response_Option==3
    N_GM=1;
end

if strcmp(EDP_Type,'SDR')==1

    % Read the EDP data from Excel
    cd (MainDirectory);                                                                              
    cd (ExcelFilePath);                                                                              
    
    if Response_Option==2
        EDP_Data    = xlsread(ExcelFileName,'SDR','B3:EZ300');
        EDP_Data(N_GM+1:end,:)=[];
        nStory=size(EDP_Data,2);
        for n=1:nStory
            SortedEDPData=sort(EDP_Data(:,n));
            MedianEDP(n,1)=median(SortedEDPData);
            Percentile16EDP(n,1)=SortedEDPData(max(1,round(0.16*N_GM)),1);
            Percentile84EDP(n,1)=SortedEDPData(round(0.84*N_GM),1);
            clear SortedEDPData
        end
    elseif Response_Option==3
        EDP_Data    = xlsread(ExcelFileName,'SDR','B3:EZ4');
        MedianEDP=EDP_Data(1,:);
        SigmaEDP=EDP_Data(2,:);
    elseif Response_Option==4
        EDP_Data    = xlsread(ExcelFileName,['SDR_',num2str(Stripe)],'B3:EZ300');
        EDP_Data(N_GM+1:end,:)=[];
        nStory=size(EDP_Data,2);
        for n=1:nStory
            SortedEDPData=sort(EDP_Data(:,n));
            MedianEDP(n,1)=median(SortedEDPData);
            Percentile16EDP(n,1)=SortedEDPData(max(1,round(0.16*N_GM)),1);
            Percentile84EDP(n,1)=SortedEDPData(round(0.84*N_GM),1);
            clear SortedEDPData
        end
    end
    MaxEDP      = max(max(EDP_Data));
    Elevation   = 1:N_Story;
    
    cd (MainDirectory);  

    % Plot Profile
    if Response_Option==2 || Response_Option==4
        for i=1:N_GM
            plot(EDP_Data(i,:),Elevation,'-','color',[0.65 0.65 0.65]);
        end
        plot(MedianEDP,Elevation,'-or','linewidth',2);
        plot(Percentile16EDP,Elevation,'--ob','linewidth',1);
        plot(Percentile84EDP,Elevation,'--ob','linewidth',1);
        h=legend('Individual GM','Median','16^t^h & 84^t^h Percentile');
    elseif Response_Option==3
        MaxEDP = max(MedianEDP);
        plot(MedianEDP,Elevation,'-or','linewidth',2);
        for i=1:N_Story
            rangex=0:0.001:0.2;
            x=logncdf(rangex,log(MedianEDP(1,i)),SigmaEDP(1,i));
            INDX=min(find(x>=0.98));
            x16=interp1(x(1,1:INDX),rangex(1,1:INDX),0.16);
            x84=interp1(x(1,1:INDX),rangex(1,1:INDX),0.84);
            plot([x16 x84],[Elevation(1,i) Elevation(1,i)],'--ok','linewidth',1,'Markerfacecolor','b');            
            MaxEDP = max(MaxEDP,x84);
        end
        h=legend('Median','16^t^h & 84^t^h percentile');
    end
    xlabel ('SDR\rm [rad]');
    ylabel ('Story');
    set(gca,'Xlim',[0.0 MaxEDP+0.01]);
    set(gca,'Ylim',[1 N_Story]);
    set(gca,'YTick',Elevation)
    set(h,'fontsize',10);

elseif strcmp(EDP_Type,'RDR')==1 
    
    % Read the EDP data from Excel
    cd (MainDirectory);                                                                              
    cd (ExcelFilePath);                                                                              
    
    if Response_Option==2
        EDP_Data    = xlsread(ExcelFileName,'RDR','B3:B300');
        EDP_Data(N_GM+1:end,:)=[];
        nStory=1;
        for n=1:nStory
            SortedEDPData=sort(EDP_Data(:,n));
            MedianEDP(n,1)=median(SortedEDPData);
            Percentile16EDP(n,1)=SortedEDPData(max(1,round(0.16*N_GM)),1);
            Percentile84EDP(n,1)=SortedEDPData(round(0.84*N_GM),1);
            clear SortedEDPData
        end
    elseif Response_Option==3
        EDP_Data    = xlsread(ExcelFileName,'RDR','B3:EZ3');
        MedianEDP=EDP_Data;
        nStory=size(EDP_Data,2);
    elseif Response_Option==4
        EDP_Data    = xlsread(ExcelFileName,['RDR_',num2str(Stripe)],'B3:B300');
        EDP_Data(N_GM+1:end,:)=[];
        nStory=1;
        for n=1:nStory
            SortedEDPData=sort(EDP_Data(:,n));
            MedianEDP(n,1)=median(SortedEDPData);
            Percentile16EDP(n,1)=SortedEDPData(max(1,round(0.16*N_GM)),1);
            Percentile84EDP(n,1)=SortedEDPData(round(0.84*N_GM),1);
            clear SortedEDPData
        end
    end
    MaxEDP      = max(max(EDP_Data)); 
    Elevation   = zeros(N_GM,1);

    cd (MainDirectory);  

    % Plot Profile
    if Response_Option==2 || Response_Option==4
        for i=1:N_GM
            plot(EDP_Data(i,1),0,'ok');
        end
        plot(MedianEDP,Elevation,'ok','Markerfacecolor','r');
        plot(Percentile16EDP,Elevation,'or');
        plot(Percentile84EDP,Elevation,'or');
        plot([MedianEDP MedianEDP],[-0.5 0],'-r');
        plot([Percentile16EDP Percentile16EDP],[-0.5 0],'--r');
        plot([Percentile84EDP Percentile84EDP],[-0.5 0],'--r');
        h=legend('Individual GM','Median','16^t^h & 84^t^h Percentile');
    else
        plot(MedianEDP,Elevation,'-or','linewidth',2);
        h=legend('Median');
    end
    xlabel ('RDR\rm [rad]');
    %ylabel ('Story');
    set(gca,'Xlim',[0.0 MaxEDP+0.01]);
    set(gca,'Ylim',[-0.5 0.5]);
    set(gca,'YTick',[])
    set(h,'fontsize',10); 

elseif strcmp(EDP_Type,'PFA')==1 
    
    % Read the EDP data from Excel
    cd (MainDirectory);                                                                              
    cd (ExcelFilePath);                                                                              
    
    if Response_Option==2
        EDP_Data    = xlsread(ExcelFileName,'PFA','B3:EZ300');
        EDP_Data(N_GM+1:end,:)=[];
        nStory=size(EDP_Data,2);
        for n=1:nStory
            SortedEDPData=sort(EDP_Data(:,n));
            MedianEDP(n,1)=median(SortedEDPData);
            Percentile16EDP(n,1)=SortedEDPData(max(1,round(0.16*N_GM)),1);
            Percentile84EDP(n,1)=SortedEDPData(round(0.84*N_GM),1);
            clear SortedEDPData
        end
    elseif Response_Option==3
        EDP_Data    = xlsread(ExcelFileName,'PFA','B3:EZ4');
        MedianEDP=EDP_Data(1,:);
        SigmaEDP=EDP_Data(2,:);
    elseif Response_Option==4
        EDP_Data    = xlsread(ExcelFileName,['PFA_',num2str(Stripe)],'B3:EZ300');
        EDP_Data(N_GM+1:end,:)=[];
        nStory=size(EDP_Data,2);
        for n=1:nStory
            SortedEDPData=sort(EDP_Data(:,n));
            MedianEDP(n,1)=median(SortedEDPData);
            Percentile16EDP(n,1)=SortedEDPData(max(1,round(0.16*N_GM)),1);
            Percentile84EDP(n,1)=SortedEDPData(round(0.84*N_GM),1);
            clear SortedEDPData
        end
    end
    MaxEDP      = max(max(EDP_Data)); 
    Elevation   = 1:N_Story+1;    
    
    cd (MainDirectory);  

    % Plot Profile
    if Response_Option==2 || Response_Option==4
        for i=1:N_GM
            plot(EDP_Data(i,:),Elevation,'-','color',[0.65 0.65 0.65]);
        end
        plot(MedianEDP,Elevation,'-or','linewidth',2);
        plot(Percentile16EDP,Elevation,'--ob','linewidth',1);
        plot(Percentile84EDP,Elevation,'--ob','linewidth',1);
        h=legend('Individual GM','Median','16^t^h & 84^t^h Percentile');
    else
        MaxEDP = max(MedianEDP);
        plot(MedianEDP,Elevation,'-or','linewidth',2);
        for i=1:N_Story+1
            rangex=0:0.05:10;
            x=logncdf(rangex,log(MedianEDP(1,i)),SigmaEDP(1,i));
            INDX=min(find(x>=0.98));
            x16=interp1(x(1,1:INDX),rangex(1,1:INDX),0.16);
            x84=interp1(x(1,1:INDX),rangex(1,1:INDX),0.84);
            plot([x16 x84],[Elevation(1,i) Elevation(1,i)],'--ok','linewidth',1,'Markerfacecolor','b');            
            MaxEDP = max(MaxEDP,x84);
        end
        h=legend('Median','16^t^h & 84^t^h percentile');
    end
    xlabel ('PFA\rm [g]');
    ylabel ('Floor');
    set(gca,'Xlim',[0.0 MaxEDP+0.5]);
    set(gca,'Ylim',[1 N_Story+1.0]);
    set(gca,'YTick',Elevation)
    set(h,'fontsize',10); 

elseif strcmp(EDP_Type,'VRD')==1 
    
    % Read the EDP data from Excel
    cd (MainDirectory);                                                                              
    cd (ExcelFilePath);                                                                              
    
    if Response_Option==2
        EDP_Data    = xlsread(ExcelFileName,'VRD','B3:EZ300');
        EDP_Data(N_GM+1:end,:)=[];
        nStory=size(EDP_Data,2);
        for n=1:nStory
            SortedEDPData=sort(EDP_Data(:,n));
            MedianEDP(n,1)=median(SortedEDPData);
            Percentile16EDP(n,1)=SortedEDPData(max(1,round(0.16*N_GM)),1);
            Percentile84EDP(n,1)=SortedEDPData(round(0.84*N_GM),1);
            clear SortedEDPData
        end
    elseif Response_Option==3
        EDP_Data    = xlsread(ExcelFileName,'RDR','B3:EZ3');
        MedianEDP=EDP_Data;
        nStory=size(EDP_Data,2);
    elseif Response_Option==4
        EDP_Data    = xlsread(ExcelFileName,['VRD_',num2str(Stripe)],'B3:EZ300');
        EDP_Data(N_GM+1:end,:)=[];
        nStory=size(EDP_Data,2);
        for n=1:nStory
            SortedEDPData=sort(EDP_Data(:,n));
            MedianEDP(n,1)=median(SortedEDPData);
            Percentile16EDP(n,1)=SortedEDPData(max(1,round(0.16*N_GM)),1);
            Percentile84EDP(n,1)=SortedEDPData(round(0.84*N_GM),1);
            clear SortedEDPData
        end
    end
    MaxEDP      = max(max(EDP_Data)); 
    Elevation   = zeros(N_GM,1);
    cd (MainDirectory);  

    % Plot Profile
    if Response_Option==2 || Response_Option==4
        for i=1:N_GM
            plot(EDP_Data(i,1),0,'ok');
        end
        plot(MedianEDP,Elevation,'ok','Markerfacecolor','r');
        plot(Percentile16EDP,Elevation,'or');
        plot(Percentile84EDP,Elevation,'or');
        h=legend('Individual GM','Median','16^t^h & 84^t^h Percentile');
    else
        plot(MedianEDP,Elevation,'-or','linewidth',2);
        h=legend('Median');
    end
    if Units==1
        xlabel ('VRD\rm [mm]');
    else
        xlabel ('VRD\rm [in]');        
    end
    ylabel ('Story');
    set(gca,'Xlim',[0.0 MaxEDP+0.01]);
    set(gca,'Ylim',[-0.5 0.5]);
    set(gca,'YTick',0)
    set(h,'fontsize',10); 
    
elseif strcmp(EDP_Type,'COL ROT')==1

    % Read the EDP data from Excel
    cd (MainDirectory);                                                                              
    cd (ExcelFilePath);                                                                              
    
    if Response_Option==2
        EDP_Data    = xlsread(ExcelFileName,'COL ROT','B3:EZ300');
        EDP_Data(N_GM+1:end,:)=[];
        nStory=size(EDP_Data,2);
        for n=1:nStory
            SortedEDPData=sort(EDP_Data(:,n));
            MedianEDP(n,1)=median(SortedEDPData);
            Percentile16EDP(n,1)=SortedEDPData(max(1,round(0.16*N_GM)),1);
            Percentile84EDP(n,1)=SortedEDPData(round(0.84*N_GM),1);
            clear SortedEDPData
        end
    elseif Response_Option==3
        EDP_Data    = xlsread(ExcelFileName,'COL ROT','B3:EZ4');
        MedianEDP=EDP_Data(1,:);
        SigmaEDP=EDP_Data(2,:);
    elseif Response_Option==4
        EDP_Data    = xlsread(ExcelFileName,['COL ROT_',num2str(Stripe)],'B3:EZ300');
        EDP_Data(N_GM+1:end,:)=[];
        nStory=size(EDP_Data,2);
        for n=1:nStory
            SortedEDPData=sort(EDP_Data(:,n));
            MedianEDP(n,1)=median(SortedEDPData);
            Percentile16EDP(n,1)=SortedEDPData(max(1,round(0.16*N_GM)),1);
            Percentile84EDP(n,1)=SortedEDPData(round(0.84*N_GM),1);
            clear SortedEDPData
        end
    end
    MaxEDP      = max(max(EDP_Data));
    Elevation   = 1:N_Story;
    
    cd (MainDirectory);  

    % Plot Profile
    if Response_Option==2 || Response_Option==4
        plot(MedianEDP,Elevation,'-or','linewidth',2);
        plot(Percentile16EDP,Elevation,'--ob','linewidth',1);
        plot(Percentile84EDP,Elevation,'--ob','linewidth',1);
        h=legend('Individual GM','Median','16^t^h & 84^t^h Percentile');
    else
        MaxEDP = max(MedianEDP);
        plot(MedianEDP,Elevation,'-or','linewidth',2);
        for i=1:N_Story
            rangex=0:0.001:0.2;
            x=logncdf(rangex,log(MedianEDP(1,i)),SigmaEDP(1,i));
            INDX=min(find(x>=0.98));
            x16=interp1(x(1,1:INDX),rangex(1,1:INDX),0.16);
            x84=interp1(x(1,1:INDX),rangex(1,1:INDX),0.84);
            plot([x16 x84],[Elevation(1,i) Elevation(1,i)],'--ok','linewidth',1,'Markerfacecolor','b');            
            MaxEDP = max(MaxEDP,x84);
        end
        h=legend('Median','16^t^h & 84^t^h percentile');
    end
    xlabel ('COL ROT\rm [rad]');
    ylabel ('Story');
    set(gca,'Xlim',[0.0 MaxEDP+0.01]);
    set(gca,'Ylim',[0.5 N_Story+0.5]);
    set(gca,'YTick',Elevation)
    set(h,'fontsize',10); 
    
elseif strcmp(EDP_Type,'BEAM ROT')==1

    % Read the EDP data from Excel
    cd (MainDirectory);                                                                              
    cd (ExcelFilePath);                                                                              
    
    if Response_Option==2
        EDP_Data    = xlsread(ExcelFileName,'BEAM ROT','B3:EZ300');
        EDP_Data(N_GM+1:end,:)=[];
        nStory=size(EDP_Data,2);
        for n=1:nStory
            SortedEDPData=sort(EDP_Data(:,n));
            MedianEDP(n,1)=median(SortedEDPData);
            Percentile16EDP(n,1)=SortedEDPData(max(1,round(0.16*N_GM)),1);
            Percentile84EDP(n,1)=SortedEDPData(round(0.84*N_GM),1);
            clear SortedEDPData
        end
    elseif Response_Option==3
        EDP_Data    = xlsread(ExcelFileName,'BEAM ROT','B3:EZ4');
        MedianEDP=EDP_Data(1,:);
        SigmaEDP=EDP_Data(2,:);
    elseif Response_Option==4
        EDP_Data    = xlsread(ExcelFileName,['BEAM ROT_',num2str(Stripe)],'B3:EZ300');
        EDP_Data(N_GM+1:end,:)=[];
        nStory=size(EDP_Data,2);
        for n=1:nStory
            SortedEDPData=sort(EDP_Data(:,n));
            MedianEDP(n,1)=median(SortedEDPData);
            Percentile16EDP(n,1)=SortedEDPData(max(1,round(0.16*N_GM)),1);
            Percentile84EDP(n,1)=SortedEDPData(round(0.84*N_GM),1);
            clear SortedEDPData
        end
    end
    MaxEDP      = max(max(EDP_Data));
    Elevation   = 2:N_Story+1;
    
    cd (MainDirectory);  

    % Plot Profile
    if Response_Option==2 || Response_Option==4
        plot(MedianEDP,Elevation,'-or','linewidth',2);
        plot(Percentile16EDP,Elevation,'--ob','linewidth',1);
        plot(Percentile84EDP,Elevation,'--ob','linewidth',1);
        h=legend('Individual GM','Median','16^t^h & 84^t^h Percentile');
    else
        MaxEDP = max(MedianEDP);
        plot(MedianEDP,Elevation,'-or','linewidth',2);
        for i=2:N_Story+1
            rangex=0:0.001:0.2;
            x=logncdf(rangex,log(MedianEDP(1,i-1)),SigmaEDP(1,i-1));
            INDX=min(find(x>=0.98));
            x16=interp1(x(1,1:INDX),rangex(1,1:INDX),0.16);
            x84=interp1(x(1,1:INDX),rangex(1,1:INDX),0.84);
            plot([x16 x84],[Elevation(1,i-1) Elevation(1,i-1)],'--ok','linewidth',1,'Markerfacecolor','b');            
            MaxEDP = max(MaxEDP,x84);
        end
        h=legend('Median','16^t^h & 84^t^h percentile');
    end
    xlabel ('BEAM ROT [rad]', 'fontname', 'times', 'fontsize',15);
    ylabel ('Story', 'fontname', 'times', 'fontsize',15);
    set(gca,'Xlim',[0.0 MaxEDP+0.01]);
    set(gca,'Ylim',[0.5 N_Story+1+0.5]);
    set(gca,'YTick',Elevation)
    set(h,'fontsize',10); 
    
elseif strcmp(EDP_Type,'LINK ROT')==1

    % Read the EDP data from Excel
    cd (MainDirectory);                         
    cd (ExcelFilePath);                                                        
    
    if Response_Option==2
        EDP_Data    = xlsread(ExcelFileName,'LINK ROT','B3:EZ300');
        EDP_Data(N_GM+1:end,:)=[];
        nStory=size(EDP_Data,2);
        for n=1:nStory
            SortedEDPData=sort(EDP_Data(:,n));
            MedianEDP(n,1)=median(SortedEDPData);
            Percentile16EDP(n,1)=SortedEDPData(max(1,round(0.16*N_GM)),1);
            Percentile84EDP(n,1)=SortedEDPData(round(0.84*N_GM),1);
            clear SortedEDPData
        end
    elseif Response_Option==3
        EDP_Data    = xlsread(ExcelFileName,'LINK ROT','B3:EZ4');
        MedianEDP=EDP_Data(1,:);
        SigmaEDP=EDP_Data(2,:);
    elseif Response_Option==4
        EDP_Data    = xlsread(ExcelFileName,['LINK ROT_',num2str(Stripe)],'B3:EZ300');
        EDP_Data(N_GM+1:end,:)=[];
        nStory=size(EDP_Data,2);
        for n=1:nStory
            SortedEDPData=sort(EDP_Data(:,n));
            MedianEDP(n,1)=median(SortedEDPData);
            Percentile16EDP(n,1)=SortedEDPData(max(1,round(0.16*N_GM)),1);
            Percentile84EDP(n,1)=SortedEDPData(round(0.84*N_GM),1);
            clear SortedEDPData
        end
    end
    MaxEDP      = max(max(EDP_Data));
    Elevation   = 2:N_Story+1;
    
    cd (MainDirectory);  

    % Plot Profile
    if Response_Option==2 || Response_Option==4
        plot(MedianEDP,Elevation,'-or','linewidth',2);
        plot(Percentile16EDP,Elevation,'--ob','linewidth',1);
        plot(Percentile84EDP,Elevation,'--ob','linewidth',1);
        h=legend('Individual GM','Median','16^t^h & 84^t^h Percentile');
    else
        MaxEDP = max(MedianEDP);
        plot(MedianEDP,Elevation,'-or','linewidth',2);
        for i=2:N_Story+1
            rangex=0:0.001:0.2;
            x=logncdf(rangex,log(MedianEDP(1,i-1)),SigmaEDP(1,i-1));
            INDX=min(find(x>=0.98));
            x16=interp1(x(1,1:INDX),rangex(1,1:INDX),0.16);
            x84=interp1(x(1,1:INDX),rangex(1,1:INDX),0.84);
            plot([x16 x84],[Elevation(1,i-1) Elevation(1,i-1)],'--ok','linewidth',1,'Markerfacecolor','b');            
            MaxEDP = max(MaxEDP,x84);
        end
        h=legend('Median','16^t^h & 84^t^h percentile');
    end
    xlabel ('LINK ROT [rad]');
    ylabel ('Story');
    set(gca,'Xlim',[0.0 MaxEDP+0.01]);
    set(gca,'Ylim',[1 N_Story+1]);
    set(gca,'YTick',Elevation)
    set(h,'fontsize',10); 

elseif strcmp(EDP_Type,'GENS1')==1 || strcmp(EDP_Type,'GENS2')==1 || strcmp(EDP_Type,'GENS3')==1

    % Read the EDP data from Excel
    cd (MainDirectory);                                                                              
    cd (ExcelFilePath);                                                                              
    
    if Response_Option==2
        EDP_Data    = xlsread(ExcelFileName,EDP_Type,'B3:EZ300');
        EDP_Data(N_GM+1:end,:)=[];
        nStory=size(EDP_Data,2);
        for n=1:nStory
            SortedEDPData=sort(EDP_Data(:,n));
            MedianEDP(n,1)=median(SortedEDPData);
            Percentile16EDP(n,1)=SortedEDPData(max(1,round(0.16*N_GM)),1);
            Percentile84EDP(n,1)=SortedEDPData(round(0.84*N_GM),1);
            clear SortedEDPData
        end
    elseif Response_Option==3
        EDP_Data    = xlsread(ExcelFileName,EDP_Type,'B3:EZ4');
        MedianEDP=EDP_Data(1,:);
        SigmaEDP=EDP_Data(2,:);
    elseif Response_Option==4
        EDP_Data    = xlsread(ExcelFileName,[EDP_Type,'_',num2str(Stripe)],'B3:EZ300');
        EDP_Data(N_GM+1:end,:)=[];
        nStory=size(EDP_Data,2);
        for n=1:nStory
            SortedEDPData=sort(EDP_Data(:,n));
            MedianEDP(n,1)=median(SortedEDPData);
            Percentile16EDP(n,1)=SortedEDPData(max(1,round(0.16*N_GM)),1);
            Percentile84EDP(n,1)=SortedEDPData(round(0.84*N_GM),1);
            clear SortedEDPData
        end
    end
    MaxEDP      = max(max(EDP_Data));
    Elevation   = 1:N_Story;
    
    cd (MainDirectory);  

    % Plot Profile
    if Response_Option==2 || Response_Option==4
        for i=1:N_GM
            plot(EDP_Data(i,:),Elevation,'-','color',[0.65 0.65 0.65]);
        end
        plot(MedianEDP,Elevation,'-or','linewidth',2);
        plot(Percentile16EDP,Elevation,'--ob','linewidth',1);
        plot(Percentile84EDP,Elevation,'--ob','linewidth',1);
        h=legend('Individual GM','Median','16^t^h & 84^t^h Percentile');
    else
        MaxEDP = max(MedianEDP);
        plot(MedianEDP,Elevation,'-or','linewidth',2);
        for i=1:N_Story
            rangex=0:max(MedianEDP)/50:max(MedianEDP)*10;
            x=logncdf(rangex,log(MedianEDP(1,i)),SigmaEDP(1,i));
            INDX=min(find(x>=0.98));
            x16=interp1(x(1,1:INDX),rangex(1,1:INDX),0.16);
            x84=interp1(x(1,1:INDX),rangex(1,1:INDX),0.84);
            plot([x16 x84],[Elevation(1,i) Elevation(1,i)],'--ok','linewidth',1,'Markerfacecolor','b');            
            MaxEDP = max(MaxEDP,x84);
        end
        h=legend('Median','16^t^h & 84^t^h percentile');
    end
    xlabel (EDP_Type);
    ylabel ('Story');
    set(gca,'Xlim',[0.0 MaxEDP+0.01]);
    set(gca,'Ylim',[1 N_Story]);
    set(gca,'YTick',Elevation)
    set(h,'fontsize',10);    
    
elseif strcmp(EDP_Type,'GENF1')==1 || strcmp(EDP_Type,'GENF2')==1 || strcmp(EDP_Type,'GENF3')==1

    % Read the EDP data from Excel
    cd (MainDirectory);                                                                              
    cd (ExcelFilePath);                                                                              
    
    if Response_Option==2
        EDP_Data    = xlsread(ExcelFileName,EDP_Type,'B3:EZ300');
        EDP_Data(N_GM+1:end,:)=[];
        nStory=size(EDP_Data,2);
        for n=1:nStory+1
            SortedEDPData=sort(EDP_Data(:,n));
            MedianEDP(n,1)=median(SortedEDPData);
            Percentile16EDP(n,1)=SortedEDPData(max(1,round(0.16*N_GM)),1);
            Percentile84EDP(n,1)=SortedEDPData(round(0.84*N_GM),1);
            clear SortedEDPData
        end
    elseif Response_Option==3
        EDP_Data    = xlsread(ExcelFileName,EDP_Type,'B3:EZ4');
        MedianEDP=EDP_Data(1,:);
        SigmaEDP=EDP_Data(2,:);
    elseif Response_Option==3
        EDP_Data    = xlsread(ExcelFileName,[EDP_Type,'_',num2str(Stripe)],'B3:EZ300');
        EDP_Data(N_GM+1:end,:)=[];
        nStory=size(EDP_Data,2);
        for n=1:nStory+1
            SortedEDPData=sort(EDP_Data(:,n));
            MedianEDP(n,1)=median(SortedEDPData);
            Percentile16EDP(n,1)=SortedEDPData(max(1,round(0.16*N_GM)),1);
            Percentile84EDP(n,1)=SortedEDPData(round(0.84*N_GM),1);
            clear SortedEDPData
        end
    end
    MaxEDP      = max(max(EDP_Data));
    Elevation   = 1:N_Story+1;
    
    cd (MainDirectory);  

    % Plot Profile
    if Response_Option==2 || Response_Option==4
        plot(MedianEDP,Elevation,'-or','linewidth',2);
        plot(Percentile16EDP,Elevation,'--ob','linewidth',1);
        plot(Percentile84EDP,Elevation,'--ob','linewidth',1);
        h=legend('Individual GM','Median','16^t^h & 84^t^h Percentile');
    else
        MaxEDP = max(MedianEDP);
        plot(MedianEDP,Elevation,'-or','linewidth',2);
        for i=1:N_Story+1
            rangex=0:max(MedianEDP)/50:max(MedianEDP)*10;
            x=logncdf(rangex,log(MedianEDP(1,i)),SigmaEDP(1,i));
            INDX=min(find(x>=0.98));
            x16=interp1(x(1,1:INDX),rangex(1,1:INDX),0.16);
            x84=interp1(x(1,1:INDX),rangex(1,1:INDX),0.84);
            plot([x16 x84],[Elevation(1,i) Elevation(1,i)],'--ok','linewidth',1,'Markerfacecolor','b');            
            MaxEDP = max(MaxEDP,x84);
        end
        h=legend('Median','16^t^h & 84^t^h percentile');
    end
    xlabel ('EDP_Type', 'fontname', 'times', 'fontsize',15);
    ylabel ('Story', 'fontname', 'times', 'fontsize',15);
    set(gca,'Xlim',[0.0 MaxEDP+0.01]);
    set(gca,'Ylim',[0.5 N_Story+1+0.5]);
    set(gca,'YTick',Elevation)
    set(h,'fontsize',10); 
    
end
