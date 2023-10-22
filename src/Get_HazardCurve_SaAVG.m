%% CODE CAN BE USED TO TRANSFORM USGS HAZARD CURVE FROM SA(T1) to SAavg
function [HazardCurveData]= Get_HazardCurve_SaAVG (MainDirectory,HazardFolderPath,Latitude,Longitude,Ti,Vs30,IMpoints);


IMpoints=0.001:0.005:3.0;
Latitude=33.996;
Longitude=-118.162;
Vs30=259;
HazardFolderPath='D:\USGS Hazard Data';
MainDirectory=pwd;
Vs30=259;
T=1.25;

    count=0;
for Ti=0.2*T:0.1:3.0*T
    count=count+1;
    [HazardCurveData]= Get_HazardCurve_USGSMaps (MainDirectory,HazardFolderPath,Latitude,Longitude,Ti,Vs30,IMpoints);
    evalc(strcat(['HazardCurves.T',num2str(count),'=HazardCurveData']));
end

nPeriods=count;

lmbda=[10e-6:10e-6:10e-5 20e-5:10e-5:10e-4 20e-4:10e-4:10e-3 0.02:0.01:0.1 0.2:0.1:1.0];

    count=0;
for i=1:size(lmbda,2)
    
    count=count+1;
    for n=1:nPeriods
        evalc(strcat(['X=HazardCurves.T',num2str(n)]));
        SaT1(n,1)=interp1(X(:,2),X(:,1),lmbda(1,i));
    end
    
    Sa_PRODUCT=1;
    for n=1:nPeriods
        Sa_PRODUCT=Sa_PRODUCT*SaT1(n,1)^(1/nPeriods);
    end
    SAavg(count,1)=Sa_PRODUCT;
    
end

figure
plot(SAavg,lmbda);
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')