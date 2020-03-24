function Plot_Correlated_Bivariate_LognCDF (RangeX1, RangeX2, MedianX1, sigmalnX1, MedianX2, sigmalnX2, Corr,Units, Module)
% Plot_Correlated_Bivariate_LognCDF 
%
%   This function plots the bivariate PDF and CDF of two correlated and
%   and lognormally distributed variables X1 and X2
%
%   Reference: Sheng Yue (2002). "The bivariate lognormal distribution for 
%              describing joint statistical properties of a multivariate storm 
%              event". Environmetrics Journal, 811–819 (DOI:10.1002/env.483).
%
% INPUT ARGUMENTS:
% 
% RangeX1   A row vector of the range values to be plotted for variable X1
%
% RangeX2   A row vector of the range values to be plotted for variable X2
%
% MedianX1  The median (central tendency) value of the lognormally distributed
%           variable X1
%
% sigmalnX1 The standard deviation of the normally distributed variable lnX1
%
% MedianX2  The median (central tendency) value of the lognormally distributed
%           variable X2
%
% sigmalnX2 The standard deviation of the normally distributed variable lnX2
%
% Corr      The population product-moment correlation coefficient of lnX1
%           and lnX2
%
%   Author        : Ahmed Elkady (ahmed.elkady@epf.ch)
%   Published on  : 14th August 2018 
%
% Example:
% Plot_Correlated_Bivariate_LognCDF (0.001:0.001:0.05, 0.001:1:60, 0.015, 0.4, 15, 0.2, 0.25)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Deduce the "mean" of the normally distributed variables, lnX1 and lnX2 
mulnX1=log(MedianX1);
mulnX2=log(MedianX2);

%% Deduce the population parameters (mu and sigma) of the lognormally distributed variables, X1 and X2 
%  (These are not used but just for completion of calculations)
% muX1=exp(mulnX1+sigmalnX1^2/2);
% sigmaX1=sqrt((exp(sigmalnX1^2)-1)*muX1^2);
% muX2=exp(mulnX2+sigmalnX2^2/2);
% sigmaX2=sqrt((exp(sigmalnX2^2)-1)*muX2^2);

%% Deduce the lnX1-lnX2 correlation parameter py
%py=(exp(Corr*sigmaX1*sigmaX2)-1)/sqrt((exp(sigmaX1)-1)*(exp(sigmaX2)-1));
       
% % Calucalting the Lognormal PDF
% for i=1:size(RangeX1,2)
%    for j=1:size(RangeX2,2)
%        a1=(log(RangeX1(i))-mulnX1)/sigmalnX1;
%        a2=(log(RangeX2(j))-mulnX2)/sigmalnX2;
%        q=1/(1-py^2) * (a1^2 - 2*Corr*a1*a2 + a2^2);
%        
%        X1(i,j)=RangeX1(i);
%        X2(i,j)=RangeX2(j);
%        PDF(i,j)=(1/(2*pi*RangeX1(i)*RangeX2(j)*sigmalnX1*sigmalnX2*(1-py^2)^0.5))*exp(-q/2);       
%    end
% end


%% Calucalting the Lognormal PDF
for i=1:size(RangeX1,2)
   for j=1:size(RangeX2,2)
       a1=(log(RangeX1(i))-mulnX1)/sigmalnX1;
       a2=(log(RangeX2(j))-mulnX2)/sigmalnX2;
       q=1/(1-Corr^2) * (a1^2 - 2*Corr*a1*a2 + a2^2);
       
       X1(i,j)=RangeX1(i);
       X2(i,j)=RangeX2(j);
       PDF(i,j)=(1/(2*pi*RangeX1(i)*RangeX2(j)*sigmalnX1*sigmalnX2*(1-Corr^2)^0.5))*exp(-q/2);       
   end
end


%% Deducing the Lognormal CDF by numerically integerating the CDF
for i=1:size(RangeX1,2)
    for j=1:size(RangeX2,2)
        sum3=sum(sum(PDF(1:i,1:j)));
        sum1=sum(sum(PDF(1:size(RangeX1,2),1:j)));
        sum2=sum(sum(PDF(1:i,1:size(RangeX2,2))));
        CDF(i,j)=sum1+sum2-sum3;
    end
end

%% Get the maximum values to normalize the PDF and CDF in the plots
MaxPDF=max(max(PDF));
MaxCDF=max(max(CDF));

if Module~=222
    %% Plot the PDF
    figure('position',[500 300 1400 350],'color','white');
    subplot(1,3,1);
    surf(X1,X2,PDF./MaxPDF,'FaceColor','white','EdgeColor','r');
    box on; grid on; hold on;
    xlabel ('\itRDR\rm [rad]'); 
    if Units==1
        ylabel ('\itVRD\rm [in]');
    else
        ylabel ('\itVRD\rm [mm]');
    end
    zlabel ('\itf\rm(Demolition|\itRDR,VRD\rm)');
    set(gca,'XLim',[0.0 max(RangeX1)])
    set(gca,'YLim',[0.0 max(RangeX2)])
    set(gca,'ZLim',[0 1])
    set(gca, 'fontname', 'times', 'fontsize',14);
    %% Plot contour plan view of the PDF
    subplot(1,3,2);
    contourf(X1,X2,PDF./MaxPDF,10);
    colormap hot
    oldcmap = colormap;
    colormap(flipud(oldcmap));
    box on; grid on; hold on;
    xlabel ('\itRDR\rm [rad]'); 
    if Units==1
        ylabel ('\itVRD\rm [in]');
    else
        ylabel ('\itVRD\rm [mm]');
    end
    set(gca,'XLim',[0.0 max(RangeX1)])
    set(gca,'YLim',[0.0 max(RangeX2)])
    set(gca, 'fontname', 'times', 'fontsize',14);
    plot([0 0.05],[MedianX2 MedianX2],'--k')
    plot([MedianX1 MedianX1],[0 50],'--k')
    %% Plot the CDF
    subplot(1,3,3);
    surf(X1,X2,CDF./MaxCDF,'FaceColor','white','EdgeColor','r');
    box on; grid on; hold on;
    xlabel ('\itRDR\rm [rad]'); 
    if Units==1
        ylabel ('\itVRD\rm [in]');
    else
        ylabel ('\itVRD\rm [mm]');
    end
    zlabel ('P(Demolition|\itRDR,VRD\rm)');
    set(gca,'XLim',[0.0 max(RangeX1)])
    set(gca,'YLim',[0.0 max(RangeX2)])
    set(gca,'ZLim',[0 1])
    set(gca, 'fontname', 'times', 'fontsize',14);
else
    figure('position',[500 300 400 350],'color','white');
    surf(X1,X2,CDF./MaxCDF,'FaceColor','white','EdgeColor','r');
    box on; grid on; hold on;
    xlabel ('\itEDP'); 
    ylabel ('\itP');
    zlabel ('P(DS_i|\itEDP,P\rm)');
    set(gca,'XLim',[0.0 max(RangeX1)])
    set(gca,'YLim',[0.0 max(RangeX2)])
    set(gca,'ZLim',[0 1])
    set(gca, 'fontname', 'times', 'fontsize',14);    
end

