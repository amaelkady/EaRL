function Report_LossBreakdownatIM_by_Event(COLLAPSE_LOSSES_Per_IM,DEMOLITION_LOSSES_Per_IM,SC_REPAIR_COST_PerIM,NSC_SDR_REPAIR_COST_PerIM,NSC_ACC_REPAIR_COST_PerIM,IMpoints,Sa_target,Replacement_Cost,UnitOption,ReportFilesPath)
global MainDirectory

for i=1:length(IMpoints)-1
    if Sa_target>=IMpoints(1,i) && Sa_target<IMpoints(1,i+1)
        indexSa1=i;
        X = [COLLAPSE_LOSSES_Per_IM(i,1) DEMOLITION_LOSSES_Per_IM(i,1) SC_REPAIR_COST_PerIM(i,1) NSC_SDR_REPAIR_COST_PerIM(i,1) NSC_ACC_REPAIR_COST_PerIM(i,1)];
        break
    end
end

cd (ReportFilesPath)
fileX = fopen('Loss Breakdown by Event.txt','wt');
fprintf(fileX,'%s\n',[num2str(round(sum(X/10^6)*100)/100),'M$ Loss at IM=', num2str(round(Sa_target*100)/100),'g']);
fprintf(fileX,'%s\n','----------------------------');
if UnitOption==1
    fprintf(fileX,'%s\t%s\n','EVENT     ','LOSS [M$] ');
    fprintf(fileX,'%s\n','----------------------------');
    fprintf(fileX,'%s\t%f\n', 'Collapse  ', X(1,1)/10^6);
    fprintf(fileX,'%s\t%f\n', 'Demolition', X(1,2)/10^6);
    fprintf(fileX,'%s\t%f\n', 'SC        ', X(1,3)/10^6);
    fprintf(fileX,'%s\t%f\n', 'NSC-SDR   ', X(1,4)/10^6);
    fprintf(fileX,'%s\t%f',   'NSC-ACC   ', X(1,5)/10^6);
else
    fprintf(fileX,'%s\t%s\n','EVENT     ','LOSS [% RC]');
    fprintf(fileX,'%s\n','----------------------------');
    fprintf(fileX,'%s\t%f\n', 'Collapse  ', X(1,1)*100/Replacement_Cost);
    fprintf(fileX,'%s\t%f\n', 'Demolition', X(1,2)*100/Replacement_Cost);
    fprintf(fileX,'%s\t%f\n', 'SC        ', X(1,3)*100/Replacement_Cost);
    fprintf(fileX,'%s\t%f\n', 'NSC-SDR   ', X(1,4)*100/Replacement_Cost);
    fprintf(fileX,'%s\t%f',   'NSC-ACC   ', X(1,5)*100/Replacement_Cost);
end
fclose(fileX);
cd (MainDirectory)
end