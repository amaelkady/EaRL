function [countSurvive,EDP_survive,INDX_LAST_SA_ALL_SURVIVE,INDX_FIRST_SA_NO_SURVIVE]= Count_Surviving_GMs(N_GM,SA_Refined,EDP_Refined,SAi,i,INDX_LAST_SA_ALL_SURVIVE,INDX_FIRST_SA_NO_SURVIVE)

EDP_survive=0;
% Count surviving records at each IM and the asscoiated EDP for each of those records
countSurvive=0;
for GM_No=1:N_GM
    [MaxEDP indx]=max(EDP_Refined(:,GM_No));
    Collapse_SA_for_GMi=SA_Refined(indx,1);
    if SAi<=Collapse_SA_for_GMi
        countSurvive=countSurvive+1;
        EDP_survive(countSurvive,1)=interp1(SA_Refined(:,1),EDP_Refined(:,GM_No),SAi);
    end
end

if countSurvive==N_GM
    INDX_LAST_SA_ALL_SURVIVE=i; 
end

if countSurvive==0
    INDX_FIRST_SA_NO_SURVIVE=min(i,INDX_FIRST_SA_NO_SURVIVE);
end