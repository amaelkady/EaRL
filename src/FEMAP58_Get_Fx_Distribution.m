 function [Fx,S,hx,W,W1] = FEMAP58_Get_Fx_Distribution(N_Story,HStory,SaT1,Load,Vy1,T1,SiteClass,FrameType)
 
W = sum(Load);

% FEMA P58 Computation            
S=SaT1*W/Vy1;

if SiteClass==1 || SiteClass==2;        a=130;
elseif SiteClass==3;                    a=90;
elseif SiteClass==4 || SiteClass==5;    a=60;    
end

if T1<=0.2;                 C1=1+(S-1)/0.04/a;
elseif T1>0.2 && T1 <=1;    C1=1+(S-1)/a/T1^2;
else;                       C1=1;
end

if T1<=0.2;                 C2=1+(S-1)^2/32;
elseif T1>0.2 && T1 <=0.7;  C2=1+(S-1)^2/800/T1^2;
else;                       C2=1;
end

% ASCE 41-17 Clause 7.4 and Table 7-4    
cm=[1.0 1.0 1.0 1.0 1.0; 0.9 0.9 1.0 0.9 0.8];
if N_Story<=2; Cm=cm(1,FrameType); end
if N_Story>2;  Cm=cm(2,FrameType); end
if T1>1.0; Cm=1.0; end 
W1=Cm*W; % W1 is the first modal effective weight in the direction under consideration, taken as not less than 80% of the total weight, W

V_P58 = C1 * C2 * SaT1 * W1;

if     T1<=0.5;  k=1;
elseif T1>2.5;   k=2;
else;            k=1+(T1-0.5)*0.5;
end

Floor(1) =1;
hx(1)=0.0;
Cvx(1)=1.0;
for i=2:N_Story+1
    Floor(i) =i;
    hx(i)=sum(HStory(1:i-1));
    Wx(i)=Load(i-1);
    WxHk(i)=Wx(i)*hx(i)^k;
end
Wx(1)=sum(Wx(2:end));
WxHk(1)=sum(WxHk(2:end));

for i=2:N_Story+1
    Cvx(i)=WxHk(i)/WxHk(1);
    Fx(i)=Cvx(i)*V_P58; % Force induced at level x
end
Fx(1)=sum(Fx(2:end));
    %%
    
end