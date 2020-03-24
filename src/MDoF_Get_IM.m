function [GM]=MDoF_Get_IM(GMFolderName, T1, GM, g, zeta, SA_metric)

if SA_metric==1
    GM.GMpsaT1 = cent_diff(GMFolderName, T1, GM.GMdt, zeta, [GM.GMname '.th'], g)/g;
else
    Sa_PRODUCT=1;
    nsample=0;
    for Ti=0.2*T1:0.01:3*T1
        nsample=nsample+1;
    end
    for Ti=0.2*T1:0.01:3*T1
        Sa_Ti = cent_diff(GMFolderName, Ti, GM.GMdt, zeta, [GM.GMname '.th'], g)/g;
        Sa_PRODUCT=Sa_PRODUCT*Sa_Ti^(1/nsample);
    end
    GM.GMpsaT1=(Sa_PRODUCT);
end