function []=Report_EAL(EAL,Replacement_Cost,UnitOption,ReportFilesPath)
global MainDirectory

cd (ReportFilesPath)
fileX = fopen('EAL.txt','wt');
TotalEAL=(EAL(1,1)+EAL(1,2)+EAL(1,3)+EAL(1,4)+EAL(1,5))/10^6;
RepairEAL=(EAL(1,3)+EAL(1,4)+EAL(1,5))/10^6;
fprintf(fileX,'%s\n',[num2str(round(TotalEAL*100)/100),'M$ Expected Annual Total  Loss']);
fprintf(fileX,'%s\n',[num2str(round(RepairEAL*100)/100),'M$ Expected Annual Repair Loss']);
fprintf(fileX,'%s\n','-------------------------------------');

if UnitOption==1
    fprintf(fileX,'%s\t%s\n','EVENT     ','EAL [M$]  ');
    fprintf(fileX,'%s\n','----------------------------');
    fprintf(fileX,'%s\t%f\n', 'Collapse  ', EAL(1,1)/10^6);
    fprintf(fileX,'%s\t%f\n', 'Demolition', EAL(1,2)/10^6);
    fprintf(fileX,'%s\t%f\n', 'SC        ', EAL(1,3)/10^6);
    fprintf(fileX,'%s\t%f\n', 'NSC-SDR   ', EAL(1,4)/10^6);
    fprintf(fileX,'%s\t%f',   'NSC-ACC   ', EAL(1,5)/10^6);
else
    fprintf(fileX,'%s\t%s\n','EVENT     ','EAL [% \itCost\rm]');
    fprintf(fileX,'%s\n','----------------------------');
    fprintf(fileX,'%s\t%f\n', 'Collapse  ', EAL(1,1)*100/Replacement_Cost);
    fprintf(fileX,'%s\t%f\n', 'Demolition', EAL(1,2)*100/Replacement_Cost);
    fprintf(fileX,'%s\t%f\n', 'SC        ', EAL(1,3)*100/Replacement_Cost);
    fprintf(fileX,'%s\t%f\n', 'NSC-SDR   ', EAL(1,4)*100/Replacement_Cost);
    fprintf(fileX,'%s\t%f',   'NSC-ACC   ', EAL(1,5)*100/Replacement_Cost);
end
fclose(fileX);
cd (MainDirectory)

end