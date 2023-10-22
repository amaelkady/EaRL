function [CDF_Demolition,PDF_Demolition] = Get_CorrBivariateDemolitionCDF(RangeX1, RangeX2, MedianX1, betaLnX1, MedianX2, betaLnX2, Corr)

mu1=log(MedianX1);
mu2=log(MedianX2);

% Calucalting the Lognormal PDF
X1=zeros(size(RangeX1,2),size(RangeX2,2));
X2=zeros(size(RangeX1,2),size(RangeX2,2));
PDF_Demolition=zeros(size(RangeX1,2),size(RangeX2,2));

for i=1:size(RangeX1,2)
   for j=1:size(RangeX2,2)
       a1=(log(RangeX1(i))-mu1)/betaLnX1;
       a2=(log(RangeX2(j))-mu2)/betaLnX2;
       q=1/(1-Corr^2) * (a1^2 - 2*Corr*a1*a2 + a2^2);
       
       X1(i,j)=RangeX1(i);
       X2(i,j)=RangeX2(j);
       PDF_Demolition(i,j)=(1/(2*pi*RangeX1(i)*RangeX2(j)*betaLnX1*betaLnX2*(1-Corr^2)^0.5))*exp(-q/2);             
   end
end

CDF_Demolition=zeros(size(RangeX1,2),size(RangeX2,2));
% Deducing the Lognormal CDF
for i=1:size(RangeX1,2)
    for j=1:size(RangeX2,2)
        sum3=sum(sum(PDF_Demolition(1:i,1:j)));
        sum1=sum(sum(PDF_Demolition(1:size(RangeX1,2),1:j)));
        sum2=sum(sum(PDF_Demolition(1:i,1:size(RangeX2,2))));
        CDF_Demolition(i,j)=sum1+sum2-sum3;
    end
end

% Get the maximum values to normalize the PDF and CDF in the plots
MaxPDF=max(max(PDF_Demolition));
MaxCDF=max(max(CDF_Demolition));

PDF_Demolition=PDF_Demolition./MaxPDF;
CDF_Demolition=CDF_Demolition./MaxCDF;