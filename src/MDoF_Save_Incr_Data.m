function [IncrDATA]= MDoF_Save_Incr_Data(MainDirectory,RFname,GM,Nstory,IncrNo, SAcurrent,DATA,g,SFcurrent,IncrDATA)

% Save SA level in Storage Vector "SA"
IncrDATA.SA (IncrNo) = SAcurrent;

% Save Maximum SDR for Story i in Storage Vector "SDRi"
for i=1:Nstory
    evalc(strcat('IncrDATA.SDR',num2str(i),'(IncrNo) = max(abs (DATA.SDR', num2str(i), '(:,1)))'));
end

% Save Residual (Last value) SDR for Story i in Storage Vector "RDRi"
for i=1:Nstory
    evalc(strcat('IncrDATA.RDR',num2str(i),'(IncrNo) =     abs (DATA.SDR', num2str(i), '(end,1))'));
end

% Save Maximum Absolute Acceleration for Floor i in Storage Vector "PFAi"
for i=1:Nstory+1
    evalc(strcat('IncrDATA.PFA',num2str(i),'(IncrNo) = max(abs (DATA.PFA' , num2str(i), '))'));
end


% Save Maximum SDR for All Stories in Storage Vector "SDR_Max"
IncrDATA.SDR_Max (IncrNo)=0.0;
for i=1:Nstory
    x = eval(['IncrDATA.SDR' num2str(i) '(IncrNo)']);
    if x >= IncrDATA.SDR_Max (IncrNo)
    IncrDATA.SDR_Max (IncrNo) = x;
    end
end

% Save Maximum RDR for All Stories in Storage Vector "RDR_Max"
IncrDATA.RDR_Max (IncrNo)=0.0;
for i=1:Nstory
    x = eval(['IncrDATA.RDR' num2str(i) '(IncrNo)']);
    if x >= IncrDATA.RDR_Max (IncrNo)
    IncrDATA.RDR_Max (IncrNo) = x;
    end
end
