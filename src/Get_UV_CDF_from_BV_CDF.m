function [CDF_Demolition_RDR] = Get_UV_CDF_from_BV_CDF(RangeX1, TargetX2, MedianX1, betaLnX1, MedianX2, betaLnX2, Corr)

RangeX2=TargetX2/100:TargetX2*3/100:TargetX2*3;

mu1=log(MedianX1);
mu2=log(MedianX2);

% Calucalting the Lognormal PDF
for i=1:size(RangeX1,2)
   for j=1:size(RangeX2,2)
       a1=(log(RangeX1(i))-mu1)/betaLnX1;
       a2=(log(RangeX2(j))-mu2)/betaLnX2;
       q=1/(1-Corr^2) * (a1^2 - 2*Corr*a1*a2 + a2^2);
       
       X1(i,j)=RangeX1(i);
       X2(i,j)=RangeX2(j);
       PDF_Demolition_RDR(i,j)=(1/(2*pi*RangeX1(i)*RangeX2(j)*betaLnX1*betaLnX2*(1-Corr^2)^0.5))*exp(-q/2);             
   end
end

% Deducing the Lognormal CDF
for i=1:size(RangeX1,2)
    for j=1:size(RangeX2,2)
        sum3=sum(sum(PDF_Demolition_RDR(1:i,1:j)));
        sum1=sum(sum(PDF_Demolition_RDR(1:size(RangeX1,2),1:j)));
        sum2=sum(sum(PDF_Demolition_RDR(1:i,1:size(RangeX2,2))));
        CDF_Demolition_RDR(i,j)=sum1+sum2-sum3;
        if RangeX2(1,j)==TargetX2; indxTargetX2=j; end
    end
end

% Get the maximum values to normalize the PDF and CDF in the plots
MaxPDF=max(max(PDF_Demolition_RDR));
MaxCDF=max(max(CDF_Demolition_RDR));

PDF_Demolition_RDR=PDF_Demolition_RDR./MaxPDF;
CDF_Demolition_RDR=CDF_Demolition_RDR./MaxCDF;

figure
surf(X1,X2,CDF_Demolition_RDR);
hold on;
P_at_TargetX2=CDF_Demolition_RDR(:,indxTargetX2);
RangeX2=zeros(1,size(RangeX1,2));
RangeX2(:,:)=TargetX2;
plot3(RangeX1,RangeX2,P_at_TargetX2,'--r','linewidth',2)