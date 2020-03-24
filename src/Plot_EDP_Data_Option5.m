function Plot_EDP_Data_Option5(ProjectPath, ProjectName, MainDirectory)

cd(ProjectPath)
load (ProjectName,'Option5_Type','N_GM','N_Story');
cd(MainDirectory)

if Option5_Type==2 || Option5_Type==3
    cd(ProjectPath)
    load (ProjectName,'EDP_Data');
    cd(MainDirectory)
    
    figure('position',[500 300 900 300],'color','white');
    subplot(1,3,1)
    set(gca, 'fontname', 'times', 'fontsize',15)
    grid on; box on; hold on
    plot([-10 -10],[-10 -10],'-','color',[0.65 0.65 0.65]);
    plot([-10 -10],[-10 -10],'-or','linewidth',2);
    plot([-10 -10],[-10 -10],'--b','linewidth',1);
    Elevation   = 1:N_Story;
    MaxEDP=max(max(EDP_Data.SDR.S1));
    for i=1:N_GM
        plot(EDP_Data.SDR.S1(i,:),Elevation,'-','color',[0.65 0.65 0.65]);
    end
    plot(EDP_Data.SDRmedian.S1,Elevation,'-or','linewidth',2);
    h=legend('Individual GM','Median');
    xlabel ('SDR [rad]');
    ylabel ('Story');
    set(gca,'Xlim',[0.0 MaxEDP+0.01]);
    set(gca,'Ylim',[1 N_Story]);
    set(gca,'YTick',Elevation)
    set(h,'fontsize',10);
    
    subplot(1,3,2)
    set(gca, 'fontname', 'times', 'fontsize',15)
    grid on; box on; hold on
    plot([-10 -10],[-10 -10],'-','color',[0.65 0.65 0.65]);
    plot([-10 -10],[-10 -10],'-or','linewidth',2);
    plot([-10 -10],[-10 -10],'--b','linewidth',1);
    Elevation   = 1:N_Story;
    MaxEDP=max(max(EDP_Data.RDR.S1));
    for i=1:N_GM
        plot(EDP_Data.RDR.S1(i,:),Elevation,'-','color',[0.65 0.65 0.65]);
    end
    plot(median(EDP_Data.RDR.S1),Elevation,'-or','linewidth',2);
    h=legend('Individual GM','Median');
    xlabel ('RDR [rad]');
    ylabel ('Story');
    set(gca,'Xlim',[0.0 MaxEDP+0.005]);
    set(gca,'Ylim',[1 N_Story]);
    set(gca,'YTick',Elevation)
    set(h,'fontsize',10);
    
    subplot(1,3,3)
    set(gca, 'fontname', 'times', 'fontsize',15)
    grid on; box on; hold on
    plot([-10 -10],[-10 -10],'-','color',[0.65 0.65 0.65]);
    plot([-10 -10],[-10 -10],'-or','linewidth',2);
    plot([-10 -10],[-10 -10],'--b','linewidth',1);
    Elevation   = 1:N_Story+1;
    MaxEDP=max(max(EDP_Data.PFA.S1));
    for i=1:N_GM
        plot(EDP_Data.PFA.S1(i,:),Elevation,'-','color',[0.65 0.65 0.65]);
    end
    plot(EDP_Data.PFAmedian.S1,Elevation,'-or','linewidth',2);
    h=legend('Individual GM','Median');
    xlabel ('PFA [g]');
    ylabel ('Floor');
    set(gca,'Xlim',[0.0 MaxEDP+0.5]);
    set(gca,'Ylim',[1 N_Story+1]);
    set(gca,'YTick',Elevation)
    set(h,'fontsize',10);
else
    cd(ProjectPath)
    load (ProjectName,'ResponseDataFolderPath','IDAFilename');
    cd(MainDirectory)
    Plot_IDA_Data_Option5 (N_GM,MainDirectory,ResponseDataFolderPath,IDAFilename.SDR,IDAFilename.PFA,IDAFilename.RDR);
end

end