function [costfun]=LossFunctionsdata

% costpar: 1x2 array, first parameter is a (60 x 1) vector with edp values, second
%          parameter is a (60 x 3) matrix with the 16%, 50%, 84% cost values


[SM1,SM2,SM3,SX1,SX2,SX3,SC1,SC2,SC3,S0,NSidr,NSpfa01,NSpfa02,NSpfa03,NSpfa11,NSpfa21,NSpfa22,Cl,Cm,Ch] = LossFunctions;

i=1;
z0=zeros(size(SM1.EDPval));
zinf=Inf(size(z0));

% Structural components, IDR sensitive,
% SMRF buildings, A < 750m2 
% Normalized to 100 m2 of STORY FLOOR area.
costfun(i).name='BSM1';
costfun(i).EDP='idr';
costfun(i).DS={1}; % 1 sequential DS
edp=SM1.EDPval;
cost=SM1.Costval; 
medCi=cost(:,2); % median cost values
stdCi=0.5*(cost(:,3)-cost(:,1));
%plot(edp,cost(:,1),edp,cost(:,2),edp,cost(:,3))
% Assume lognormal
%betaCi=0.5*(log(costpar{2}(:,3))-log(costpar{2}(:,1)));
%betaCi(isinf(betaCi)|isnan(betaCi))=0;
% Assume normal
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,z0,zinf]}; 
i=i+1;   

% Structural components, IDR sensitive,
% SMRF buildings, 750m2 < A < 1500m2.
% Normalized to 100 m2 of STORY FLOOR area.
costfun(i).name='BSM2';
costfun(i).EDP='idr';
costfun(i).DS={1}; % 1 sequential DS
%plot(edp,cost(:,1),edp,cost(:,2),edp,cost(:,3))
edp=SM2.EDPval;
cost=SM2.Costval; 
medCi=cost(:,2);
% Assume lognormal
%betaCi=0.5*(log(costpar{2}(:,3))-log(costpar{2}(:,1)));
%betaCi(isinf(betaCi)|isnan(betaCi))=0;
% Assume normal
stdCi=0.5*(cost(:,3)-cost(:,1));
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,z0,zinf]}; 
i=i+1;   

% Structural components, IDR sensitive,
% SMRF buildings,  A > 1500m2.
% Normalized to 100 m2 of STORY FLOOR area.
costfun(i).name='BSM3';
costfun(i).EDP='idr';
costfun(i).DS={1}; % 1 sequential DS
%plot(edp,cost(:,1),edp,cost(:,2),edp,cost(:,3))
edp=SM3.EDPval;
cost=SM3.Costval; 
medCi=cost(:,2);
% Assume lognormal
%betaCi=0.5*(log(costpar{2}(:,3))-log(costpar{2}(:,1)));
%betaCi(isinf(betaCi)|isnan(betaCi))=0;
% Assume normal
stdCi=0.5*(cost(:,3)-cost(:,1));
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,z0,zinf]}; 
i=i+1;   

% Structural components, IDR sensitive,
% X-braced buildings, A < 750m2 
% Normalized to 100 m2 of STORY FLOOR area.
costfun(i).name='BSX1';
costfun(i).EDP='idr';
costfun(i).DS={1}; % 1 sequential DS
%plot(edp,cost(:,1),edp,cost(:,2),edp,cost(:,3))
edp=SX1.EDPval;
cost=SX1.Costval; 
medCi=cost(:,2);
% Assume lognormal
%betaCi=0.5*(log(costpar{2}(:,3))-log(costpar{2}(:,1)));
%betaCi(isinf(betaCi)|isnan(betaCi))=0;
% Assume normal
stdCi=0.5*(cost(:,3)-cost(:,1));
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,z0,zinf]}; 
i=i+1;   

% Structural components, IDR sensitive,
% SMRF buildings, 750m2 < A < 1500m2.
% Normalized to 100 m2 of STORY FLOOR area.
costfun(i).name='BSX2';
costfun(i).EDP='idr';
costfun(i).DS={1}; % 1 sequential DS
%plot(edp,cost(:,1),edp,cost(:,2),edp,cost(:,3))
edp=SX2.EDPval;
cost=SX2.Costval; 
medCi=cost(:,2);
% Assume lognormal
%betaCi=0.5*(log(costpar{2}(:,3))-log(costpar{2}(:,1)));
%betaCi(isinf(betaCi)|isnan(betaCi))=0;
% Assume normal
stdCi=0.5*(cost(:,3)-cost(:,1));
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,z0,zinf]}; 
i=i+1;   

% Structural components, IDR sensitive,
% SMRF buildings,  A > 1500m2.
% Normalized to 100 m2 of STORY FLOOR area.
costfun(i).name='BSX3';
costfun(i).EDP='idr';
costfun(i).DS={1}; % 1 sequential DS
%plot(edp,cost(:,1),edp,cost(:,2),edp,cost(:,3))
edp=SX3.EDPval;
cost=SX3.Costval; 
medCi=cost(:,2);
% Assume lognormal
%betaCi=0.5*(log(costpar{2}(:,3))-log(costpar{2}(:,1)));
%betaCi(isinf(betaCi)|isnan(betaCi))=0;
% Assume normal
stdCi=0.5*(cost(:,3)-cost(:,1));
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,z0,zinf]}; 
i=i+1;

% Structural components, IDR sensitive,
% SMRF buildings, A < 750m2 
% Normalized to 100 m2 of STORY FLOOR area.
costfun(i).name='BSC1';
costfun(i).EDP='idr';
costfun(i).DS={1}; % 1 sequential DS
%plot(edp,cost(:,1),edp,cost(:,2),edp,cost(:,3))
edp=SC1.EDPval;
cost=SC1.Costval; 
medCi=cost(:,2);
% Assume lognormal
%betaCi=0.5*(log(costpar{2}(:,3))-log(costpar{2}(:,1)));
%betaCi(isinf(betaCi)|isnan(betaCi))=0;
% Assume normal
stdCi=0.5*(cost(:,3)-cost(:,1));
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,z0,zinf]}; 
i=i+1;   

% Structural components, IDR sensitive,
% SMRF buildings, 750m2 < A < 1500m2.
% Normalized to 100 m2 of STORY FLOOR area.
costfun(i).name='BSC2';
costfun(i).EDP='idr';
costfun(i).DS={1}; % 1 sequential DS
%plot(edp,cost(:,1),edp,cost(:,2),edp,cost(:,3))
edp=SC2.EDPval;
cost=SC2.Costval; 
medCi=cost(:,2);
% Assume lognormal
%betaCi=0.5*(log(costpar{2}(:,3))-log(costpar{2}(:,1)));
%betaCi(isinf(betaCi)|isnan(betaCi))=0;
% Assume normal
stdCi=0.5*(cost(:,3)-cost(:,1));
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,z0,zinf]}; 
i=i+1;   

% Structural components, IDR sensitive,
% SMRF buildings,  A > 1500m2.
% Normalized to 100 m2 of STORY FLOOR area.
costfun(i).name='BSC3';
costfun(i).EDP='idr';
costfun(i).DS={1}; % 1 sequential DS
%plot(edp,cost(:,1),edp,cost(:,2),edp,cost(:,3))
edp=SC3.EDPval;
cost=SC3.Costval; 
medCi=cost(:,2);
% Assume lognormal
%betaCi=0.5*(log(costpar{2}(:,3))-log(costpar{2}(:,1)));
%betaCi(isinf(betaCi)|isnan(betaCi))=0;
% Assume normal
stdCi=0.5*(cost(:,3)-cost(:,1));
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,z0,zinf]}; 
i=i+1;

% Structural components, IDR sensitive, Ground floor column base plates
% Normalized to 100 m2 of STORY FLOOR area.
costfun(i).name='BS0';
costfun(i).EDP='idr';
costfun(i).DS={1}; % 1 sequential DS
edp=S0.EDPval;
cost=S0.Costval; 
medCi=cost(:,2);
% Assume normal
stdCi=0.5*(cost(:,3)-cost(:,1));
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,z0,zinf]}; 
i=i+1;  

% Non-structural components, IDR sensitive, typical floor
% Normalized to 100 m2 of STORY FLOOR area.
costfun(i).name='CNSidr';
costfun(i).EDP='idr';
costfun(i).DS={1}; % 1 sequential DS
[edp,indx]=unique(NSidr.EDPval);
cost=NSidr.Costval(indx,:); 
medCi=cost(:,2);
% Assume normal
stdCi=0.5*(cost(:,3)-cost(:,1));
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,zeros(size(medCi)),inf(size(medCi))]}; 
i=i+1;  

% Non-structural components, PFA sensitive,
% ground floor/basement, A < 2000m2
% Normalized to 100 m2 of TOTAL BUILDING FLOOR area.
costfun(i).name='CNSpfa01';
costfun(i).EDP='pfa';
costfun(i).DS={1}; % 1 sequential DS
edp=NSpfa01.EDPval;
cost=NSpfa01.Costval; 
medCi=cost(:,2);
% Assume normal
stdCi=0.5*(cost(:,3)-cost(:,1));
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,z0,zinf]}; 
i=i+1;

% Non-structural components, PFA sensitive,
% ground floor/basement, 2000m2 < A < 5000m2
% Normalized to 100 m2 of TOTAL BUILDING FLOOR area.
costfun(i).name='CNSpfa02';
costfun(i).EDP='pfa';
costfun(i).DS={1}; % 1 sequential DS
edp=NSpfa02.EDPval;
cost=NSpfa02.Costval; 
medCi=cost(:,2);
% Assume normal
stdCi=0.5*(cost(:,3)-cost(:,1));
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,z0,zinf]}; 
i=i+1;        

% Non-structural components, PFA sensitive,
% ground floor/basement,  A > 5000m2
% Normalized to 100 m2 of TOTAL BUILDING FLOOR area.
costfun(i).name='CNSpfa03';
costfun(i).EDP='pfa';
costfun(i).DS={1}; % 1 sequential DS
edp=NSpfa03.EDPval;
cost=NSpfa03.Costval; 
medCi=cost(:,2);
% Assume normal
stdCi=0.5*(cost(:,3)-cost(:,1));
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,z0,zinf]}; 
i=i+1;  

% Non-structural components, pfa sensitive, typical floor
% Normalized to 100 m2 of STORY FLOOR area.
costfun(i).name='CNSpfa11';
costfun(i).EDP='pfa';
costfun(i).DS={1}; % 1 sequential DS
edp=NSpfa11.EDPval;
cost=NSpfa11.Costval; 
medCi=cost(:,2);
% Assume normal
stdCi=0.5*(cost(:,3)-cost(:,1));
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,z0,zinf]}; 
i=i+1;        

% Non-structural components, pfa sensitive, roof
% Normalized to 100 m2 of STORY FLOOR area.
costfun(i).name='CNSpfa21';
costfun(i).EDP='pfa';
costfun(i).DS={1}; % 1 sequential DS
edp=NSpfa21.EDPval;
cost=NSpfa21.Costval; 
medCi=cost(:,2);
% Assume normal
stdCi=0.5*(cost(:,3)-cost(:,1));
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,z0,zinf]}; 
i=i+1;  

% Non-structural components, PFA sensitive,
% roof, A > 5000m2
% Normalized to 100 m2 of TOTAL BUILDING FLOOR area.
costfun(i).name='CNSpfa22';
costfun(i).EDP='pfa';
costfun(i).DS={1}; % 1 sequential DS
edp=NSpfa22.EDPval;
cost=NSpfa22.Costval; 
medCi=cost(:,2);
% Assume normal
stdCi=0.5*(cost(:,3)-cost(:,1));
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,z0,zinf]}; 
i=i+1;  

% Contents, pfa sensitive, low luxury facility, typical floor
% Normalized to 100 m2 of STORY FLOOR area.
costfun(i).name='ECl';
costfun(i).EDP='pfa';
costfun(i).DS={1}; % 1 sequential DS
edp=Cl.EDPval;
cost=Cl.Costval; 
medCi=cost(:,2);
% Assume normal
stdCi=0.5*(cost(:,3)-cost(:,1));
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,z0,zinf]}; 
i=i+1;  

% Contents, pfa sensitive, medium luxury facility, typical floor
% Normalized to 100 m2 of STORY FLOOR area.
costfun(i).name='ECm';
costfun(i).EDP='pfa';
costfun(i).DS={1}; % 1 sequential DS
edp=Cm.EDPval;
cost=Cm.Costval; 
medCi=cost(:,2);
% Assume normal
stdCi=0.5*(cost(:,3)-cost(:,1));
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,z0,zinf]}; 
i=i+1;  

% Contents, pfa sensitive, high luxury facility, typical floor
% Normalized to 100 m2 of STORY FLOOR area.
costfun(i).name='ECh';
costfun(i).EDP='pfa';
costfun(i).DS={1}; % 1 sequential DS
edp=Ch.EDPval;
cost=Ch.Costval; 
medCi=cost(:,2);
% Assume normal
stdCi=0.5*(cost(:,3)-cost(:,1));
costfun(i).costpar={edp,'tnorminv', [medCi,stdCi,z0,zinf]}; 
i=i+1; 
end
   