function        [DEAGG_DATA]=Assemble_Deaggregated_Data(DEAGG_DATA,COMPDATA,counter,im,Ri,n,Ci_ID,Ri_EDP,ActiveDS,ActiveDScost,ActiveCnUnits,RepairCost,RepairTime,COLLAPSE_LOSSES_Per_Ri,DEMOLITION_LOSSES_Per_Ri)

IDXC=find(Ci_ID==COMPDATA.C_ID); % Find the location (i.e., row index) of the current Ci in the COMPDATA Matrix

DEAGG_DATA(counter,6)=Ri;                                                  % Realization Number          
DEAGG_DATA(counter,1)=im;                                                  % Stripe Number
DEAGG_DATA(counter,2)=n;                                                   % Story/Floor Number
DEAGG_DATA(counter,3)=Ci_ID;                                               % Component ID
DEAGG_DATA(counter,4)=RepairCost;                                          % Repair Cost
if  COMPDATA.C_Category2(IDXC)=="Superstructure"
    DEAGG_DATA(counter,5)=1;                                                   % Component Category
elseif COMPDATA.C_Category2(IDXC)~="Superstructure" && COMPDATA.C_EDP(IDXC)=="SDR"
    DEAGG_DATA(counter,5)=2;            
elseif COMPDATA.C_Category2(IDXC)~="Superstructure" && COMPDATA.C_EDP(IDXC)=="PFA"
    DEAGG_DATA(counter,5)=3;    
elseif COMPDATA.C_Category2(IDXC)~="Superstructure" && COMPDATA.C_EDP(IDXC)=="PGA"
    DEAGG_DATA(counter,5)=3;    
end

if COLLAPSE_LOSSES_Per_Ri(Ri,im)~=0                      % Event Type
    DEAGG_DATA(counter,7)=999;
elseif DEMOLITION_LOSSES_Per_Ri(Ri,im)~=0
    DEAGG_DATA(counter,7)=888; 
else
    DEAGG_DATA(counter,7)=0;    
end

DEAGG_DATA(counter,8)=ActiveDS;                                            % Damaged DS
DEAGG_DATA(counter,9)=ActiveDScost;                                        % Damaged DS Cost
DEAGG_DATA(counter,10)=ActiveCnUnits;                                      % Number Damaged DS Cost Units

DEAGG_DATA(counter,11)=RepairTime;                                         % Repair Time
DEAGG_DATA(counter,12)=Ri_EDP;                                             % Realization EDP