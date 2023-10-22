function [MAF,Hazard_Sa]=Fit_Hazard_4Poly(HazardCurveData,IMpoints,nIMpoints)

% Fitting a 4th order polynomial to the hazard curve
IM=HazardCurveData(:,1)';
MAF_IM=HazardCurveData(:,2)';
COEFF=polyfit(log(IM),log(MAF_IM),4);
dIM=diff(IMpoints);
MIDPTS=zeros(nIMpoints+1,1);
for i=1:nIMpoints
    MIDPTS(i,1)=IMpoints(i)-dIM(1)/2;
    if MIDPTS(i,1)<0; MIDPTS(i,1)=IMpoints(i); end
    if i==nIMpoints
        MIDPTS(i+1,1)=IMpoints(i)+dIM(1)/2;
    end
end
MAF=exp(COEFF(1)*log(MIDPTS(:,1)).^4+COEFF(2)*log(MIDPTS(:,1)).^3+COEFF(3)*log(MIDPTS(:,1)).^2+COEFF(4)*log(MIDPTS(:,1)).^1+COEFF(5));

for i=1: size(MAF,1)-1
    r=-1*log(1-0.5)/100;
    if  MAF(i,1)>=r && MAF(i+1,1)<=r
        Hazard_Sa.x50_in_100= IMpoints(1,i);
    end
    r=-1*log(1-0.5)/50;
    if  MAF(i,1)>=r && MAF(i+1,1)<=r
        Hazard_Sa.x50_in_50= IMpoints(1,i);
    end
    r=-1*log(1-0.1)/50;
    if  MAF(i,1)>=r && MAF(i+1,1)<=r
        Hazard_Sa.x10_in_50= IMpoints(1,i);
    end
    r=-1*log(1-0.05)/50;
    if  MAF(i,1)>=r && MAF(i+1,1)<=r
        Hazard_Sa.x5_in_50= IMpoints(1,i);
    end
    r=-1*log(1-0.02)/50;
    if  MAF(i,1)>=r && MAF(i+1,1)<=r
        Hazard_Sa.x2_in_50= IMpoints(1,i);
    end
end

end