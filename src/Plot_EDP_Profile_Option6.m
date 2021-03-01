function Plot_EDP_Profile_Option6 (N_Story,EDP_Data,Option6Data,Units)
clc
figure('position',[500 300 900 300],'color','white');

%% Plot SDR
subplot(1,4,1)
set(gca, 'fontname', 'times', 'fontsize',15) 
grid on; box on; hold on

MedianEDP=EDP_Data.SDRmedian.S1;
SigmaEDP=EDP_Data.SDRsigma.S1;

MaxEDP      = max(max(MedianEDP));
Elevation   = 1:N_Story;

% Plot Profile
MaxEDP = max(MedianEDP);
plot(MedianEDP,Elevation,'-or','linewidth',2);
for i=1:N_Story
    rangex=0:0.001:2.0;
    y=logncdf(rangex,log(MedianEDP(1,i)),SigmaEDP(1,i));
    INDX=min(find(y>=0.98));
    x16=interp1(y(1,1:INDX),rangex(1,1:INDX),0.16);
    x84=interp1(y(1,1:INDX),rangex(1,1:INDX),0.84);
    plot([x16 x84],[Elevation(1,i) Elevation(1,i)],'--ok','linewidth',1,'Markerfacecolor','b');            
    MaxEDP = max(MaxEDP,x84);
end
h=legend('Median','16^t^h & 84^t^h percentile');

xlabel ('SDR [rad]');
ylabel ('Story');
set(gca,'Xlim',[0.0 MaxEDP+0.01]);
set(gca,'Ylim',[1 N_Story]);
set(gca,'YTick',Elevation)
set(h,'fontsize',10);



%% Plot RDR
% v2struct(Option6Data)
% for i=1:N_Story
%     if EDP_Data.SDRmedian.S1(1,i)<=SDRy; EDP_Data.RDRmedian.S1(1,i)=0; end
%     if EDP_Data.SDRmedian.S1(1,i)>SDRy && EDP_Data.SDRmedian.S1(1,i)<=4*SDRy; EDP_Data.RDRmedian.S1(1,i)=0.3*(EDP_Data.SDRmedian.S1(1,i)-SDRy); end
%     if EDP_Data.SDRmedian.S1(1,i)>4*SDRy; EDP_Data.RDRmedian.S1(1,i)=EDP_Data.SDRmedian.S1(1,i)-3*SDRy; end
% end
            
subplot(1,4,2)
set(gca, 'fontname', 'times', 'fontsize',15) 
grid on; box on; hold on                                                                           

MedianEDP=EDP_Data.RDRmedian.S1;
SigmaEDP=EDP_Data.RDRsigma.S1;

MaxEDP      = max(max(MedianEDP)); 
Elevation   = 1:N_Story;

% Plot Profile
MaxEDP = max(MedianEDP);
plot(MedianEDP,Elevation,'-or','linewidth',2);
for i=1:N_Story
    rangex=0:0.001:2.0;
    if MedianEDP(1,1)~=0
    y=logncdf(rangex,log(MedianEDP(1,i)),SigmaEDP(1,i));
    INDX=min(find(y>=0.98));
    x16=interp1(y(1,1:INDX),rangex(1,1:INDX),0.16);
    x84=interp1(y(1,1:INDX),rangex(1,1:INDX),0.84);
    plot([x16 x84],[Elevation(1,i) Elevation(1,i)],'--ok','linewidth',1,'Markerfacecolor','b');            
    MaxEDP = max(MaxEDP,x84);
    else
    plot([0 0],[Elevation(1,i) Elevation(1,i)],'--ok','linewidth',1,'Markerfacecolor','b');                    
    end
end
h=legend('Median','16^t^h & 84^t^h percentile');

xlabel ('RDR [rad]');
ylabel ('Story');
set(gca,'Xlim',[0.0 MaxEDP+0.01]);
set(gca,'Ylim',[1 N_Story]);
set(gca,'YTick',Elevation)
set(h,'fontsize',10);


%% Plot PFA
subplot(1,4,3)
set(gca, 'fontname', 'times', 'fontsize',15) 
grid on; box on; hold on                                                                           

MedianEDP=EDP_Data.PFAmedian.S1;
SigmaEDP=EDP_Data.PFAsigma.S1;

MaxEDP      = max(max(MedianEDP)); 
Elevation   = 1:N_Story+1;    

% Plot Profile
MaxEDP = max(MedianEDP);
plot(MedianEDP,Elevation,'-or','linewidth',2);
for i=1:N_Story+1
    rangex=0:0.05:30;
    y=logncdf(rangex,log(MedianEDP(1,i)),SigmaEDP(1,i));
    INDX=min(find(y>=0.98));
    x16=interp1(y(1,1:INDX),rangex(1,1:INDX),0.16);
    x84=interp1(y(1,1:INDX),rangex(1,1:INDX),0.84);
    plot([x16 x84],[Elevation(1,i) Elevation(1,i)],'--ok','linewidth',1,'Markerfacecolor','b');            
    MaxEDP = max(MaxEDP,x84);
end
h=legend('Median','16^t^h & 84^t^h percentile');

xlabel ('PFA [g]');
ylabel ('Floor');
set(gca,'Xlim',[0.0 MaxEDP+0.5]);
set(gca,'Ylim',[1 N_Story+1.0]);
set(gca,'YTick',Elevation)
set(h,'fontsize',10); 


%% Plot PFV
subplot(1,4,4)
set(gca, 'fontname', 'times', 'fontsize',15) 
grid on; box on; hold on                                                                           

MedianEDP=EDP_Data.PFVmedian.S1;
SigmaEDP=EDP_Data.PFVsigma.S1;

MaxEDP      = max(max(MedianEDP)); 
Elevation   = 1:N_Story+1;    

% Plot Profile
MaxEDP = max(MedianEDP);
plot(MedianEDP,Elevation,'-or','linewidth',2);
for i=1:N_Story+1
    rangex=0:0.05:500;
    y=logncdf(rangex,log(MedianEDP(1,i)),SigmaEDP(1,i));
    INDX=min(find(y>=0.98));
    x16=interp1(y(1,1:INDX),rangex(1,1:INDX),0.16);
    x84=interp1(y(1,1:INDX),rangex(1,1:INDX),0.84);
    plot([x16 x84],[Elevation(1,i) Elevation(1,i)],'--ok','linewidth',1,'Markerfacecolor','b');            
    MaxEDP = max(MaxEDP,x84);
end
h=legend('Median','16^t^h & 84^t^h percentile');

if Units==1; xlabel ('PFV [in/sec^2]'); else; xlabel ('PFV [m/sec^2]'); end
ylabel ('Floor');
set(gca,'Xlim',[0.0 MaxEDP*1.05]);
set(gca,'Ylim',[1 N_Story+1.0]);
set(gca,'YTick',Elevation)
set(h,'fontsize',10); 
