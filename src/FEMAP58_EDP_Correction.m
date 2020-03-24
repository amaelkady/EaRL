function [EDP_Data]=FEMAP58_EDP_Correction(PGA,FrameType,N_Story,T1,hx,HBuilding,S,SDRy,GMPEloc,SDR,DISP,Units,Sa_1sec,W,W1,Vy1)

% Apply EDP corrections
if N_Story<=9
    Corr_Factors_SDR=[0.900 -0.120  0.012 -2.650  2.090  0.000; 0.750  0.180 -0.042 -2.450  1.930  0.000; 0.330  0.140 -0.059 -0.680 0.560  0.000; 0.750 -0.044 -0.010 -2.580 2.300  0.000;  0.920 -0.036 -0.058 -2.560 1.390  0.000];
    Corr_Factors_PFA=[0.660 -0.270 -0.089 -0.075  0.000  0.000; 1.150 -0.470 -0.039 -0.043  0.470  0.000; 0.920 -0.300 -0.042 -0.250 0.430  0.000; 0.660 -0.250 -0.080 -0.039 0.000  0.000;  0.660 -0.150 -0.084 -0.260 0.570  0.000];
    Corr_Factors_PFV=[0.150 -0.100 -0.000 -0.408  0.470  0.000; 0.200  0.230 -0.074 -0.450  0.190  0.000; 1.150 -0.470 -0.039 -0.043 0.470  0.000; 0.025 -0.068  0.032 -0.530 0.540  0.000; -0.033 -0.085  0.055 -0.520 0.470  0.000];
else
    Corr_Factors_SDR=[1.910 -0.120  0.077 -3.780  6.430 -3.420; 1.260  0.053 -0.033 -6.930 10.620 -4.800; 1.110  0.140 -0.057 -5.460  7.380 -2.880; 0.670 -0.044 -0.098 -1.370  1.710 -0.570;  0.860 -0.036 -0.076 -4.580   6.880 -3.240];
    Corr_Factors_PFA=[0.440 -0.270 -0.052  3.240 -9.710  6.830; 0.630 -0.170 -0.046  3.520 -8.510  5.530; 0.930 -0.191 -0.057  1.670 -4.600  3.060; 0.340 -0.250 -0.062  2.860 -7.430  5.100; -0.130 -0.150 -0.100  7.790 -17.520 11.040];
    Corr_Factors_PFV=[0.086 -0.100  0.041  0.450 -2.890  2.570; 0.600 -0.110 -0.064  3.240 -6.690  4.450; 0.810 -0.100 -0.092  2.380 -4.960  3.280;-0.020 -0.068  0.034  0.320 -1.750  1.530; -0.110 -0.085  0.110  0.870  -4.070  3.270];
end

% Correct SDR values
a=Corr_Factors_SDR(FrameType,:);
for i=1:N_Story
    H_sdr=exp( a(1) + a(2)*T1 + a(2)*S + a(3)*hx(i+1)/HBuilding + a(4)*(hx(i+1)/HBuilding)^2 + a(5)*(hx(i+1)/HBuilding)^3  );
    evalc(strcat('EDP_Data.SDRmedian.S1(1,i)=H_sdr * SDR(1,i)'));
end

% Get PFA values
a=Corr_Factors_PFA(FrameType,:);
EDP_Data.PFAmedian.S1(1,1)=PGA;
for i=2:N_Story+1
    H_pfa=exp( a(1) + a(2)*T1 + a(2)*S + a(3)*hx(i)/HBuilding + a(4)*(hx(i)/HBuilding)^2 + a(5)*(hx(i)/HBuilding)^3  );
    evalc(strcat('EDP_Data.PFAmedian.S1(1,i)=H_pfa * PGA'));
end

% Get RDR values
for i=1:N_Story
    if EDP_Data.SDRmedian.S1(1,i)<=SDRy; EDP_Data.RDRmedian.S1(1,i)=0; end
    if EDP_Data.SDRmedian.S1(1,i)>SDRy && EDP_Data.SDRmedian.S1(1,i)<=4*SDRy; EDP_Data.RDRmedian.S1(1,i)=0.3*(EDP_Data.SDRmedian.S1(1,i)-SDRy); end
    if EDP_Data.SDRmedian.S1(1,i)>4*SDRy; EDP_Data.RDRmedian.S1(1,i)=EDP_Data.SDRmedian.S1(1,i)-3*SDRy; end
end
EDP_Data.RDRmedian.S1=max(EDP_Data.RDRmedian.S1);

% Get PFV values
if Units==1; g=386; else g=9.81; end
Sv_1sec = Sa_1sec * g/2/pi;
PGV=Sv_1sec/1.65;
MPF1=W1/W;
EDP_Data.PFVmedian.S1(1,1)=PGV;
for i=2:N_Story+1
    evalc(strcat('PFV_linear(1,i) = PGV + 0.3 * (T1/2/pi) * (Vy1/W1/g) * MPF1 * (DISP(1,i)/DISP(1,N_Story+1))'));
end
a=Corr_Factors_PFV(FrameType,:);
for i=2:N_Story+1
    H_pfv=exp( a(1) + a(2)*T1 + a(2)*S + a(3)*hx(i)/HBuilding + a(4)*(hx(i)/HBuilding)^2 + a(5)*(hx(i)/HBuilding)^3  );
    evalc(strcat('EDP_Data.PFVmedian.S1(1,i)=H_pfv * PFV_linear(1,i)'));
end

Beta_gm=[0.6 0.6 0.61 0.64 0.65 0.67 0.7; 0.53 0.55 0.55 0.58 0.6 0.6 0.6; 0.8 0.8 0.8 0.8 0.8 0.85 0.9];
Beta_m=[0.25 0.25 0.35 0.5 0.5];
Beta_ad=[0.05 0.35 0.4 0.45 0.45; 0.10 0.35 0.40 0.45 0.45; 0.10 0.35 0.4 0.45 0.45; 0.10 0.35 0.40 0.45 0.45; 0.15 0.35 0.4 0.45 0.45; 0.15 0.35 0.40 0.45 0.45; 0.25 0.35 0.40 0.45 0.45];
Beta_aa=[0.10 0.10 0.1 0.10 0.05; 0.15 0.15 0.15 0.15 0.15; 0.20 0.20 0.2 0.20 0.20; 0.25 0.25 0.25 0.25 0.25; 0.30 0.30 0.3 0.30 0.25; 0.35 0.35 0.30 0.30 0.25; 0.50 0.45 0.45 0.40 0.35];
Beta_av=[0.50 0.51 0.4 0.37 0.24; 0.32 0.38 0.43 0.38 0.34; 0.31 0.35 0.41 0.36 0.32; 0.30 0.33 0.39 0.35 0.30; 0.27 0.29 0.37 0.36 0.34; 0.25 0.26 0.33 0.34 0.33; 0.28 0.21 0.25 0.26 0.26];
T=[0.2 0.35 0.5 0.75 1.0 1.5 2.0];
Sx=[1 2 4 6 8];
for i=1:7
    if T1<T(1);                 row=1; break; end
    if T1>=T(i) && T1<T(i+1);   row=i; break; end
    if T1>=T(end);              row=7; break; end
end
for i=1:5
    if S<Sx(1);                 col=1; break; end
    if S>=Sx(i) && S<Sx(i+1);   col=i; break; end
    if S>=Sx(end);              col=5; break; end
end
EDP_Data.SDRsigma.S1(1,1:N_Story)=sqrt(Beta_ad(row,col)^2+Beta_m(1,col)^2);
EDP_Data.PFAsigma.S1(1,1:N_Story+1)=sqrt(Beta_aa(row,col)^2+Beta_m(1,col)^2);
EDP_Data.RDRsigma.S1(1,1)=sqrt(0.8^2+0.2^2);
EDP_Data.PFVsigma.S1(1,1:N_Story+1)=sqrt(Beta_av(row,col)^2+Beta_m(1,col)^2);

EDP_Data.SDRcorr=eye(N_Story);
EDP_Data.PFAcorr=eye(N_Story+1);
EDP_Data.RDRcorr=1;
EDP_Data.PFVcorr=eye(N_Story+1);

end