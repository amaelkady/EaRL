
function [DATA]= MDoF_Read_Data(MainDirectory,RFname,GM,GMFolderName,Nstory,g,SFcurrent,DATA)

cd (RFname);                 % Go Inside the 'Results' Folder 
cd (GM.GMname);              % Go Inside the  Current GM Folder

% Read Time
DATA.TimeX= importdata('Time.out');

% Read Story Drifts
for i=1:Nstory
	FilenameX1=strcat('SDR',num2str(i),'.out');
	evalc(strcat('DATA.SDR',num2str(i),' = importdata(''',FilenameX1,''')'));
end


% Read Floor Accelerations      
for i=1:Nstory+1
	FilenameX2=strcat('RFA',num2str(i),'.out');
	evalc(strcat('DATA.RFA',num2str(i),' = importdata(''',FilenameX2,''')'));
end


%% Calculate Absolute Acceleration per Floor
cd (MainDirectory);      
cd (GMFolderName);
A = importdata([GM.GMname '.th']);
L = length(A(:,1));
CL = length(A(1,:));
for i = 1:L
   GMArrangement((1+(i-1)*CL):(CL+(i-1)*CL),1) = A(i,:)';
end
evalc(strcat('Time=DATA.TimeX(:,1)'));
Time2 = 0:GM.GMdt:(length(GMArrangement)-1)*GM.GMdt;
Eq (:,1) = Time2;
Eq (:,2) = GMArrangement;
DATA.EQ_Inter = interp1(Eq(:,1),Eq(:,2), Time(11:end,1));

for i=1:Nstory+1
	evalc(strcat('DATA.PFA',num2str(i),'= DATA.RFA', num2str(i), '(11:end,1)/g + SFcurrent * DATA.EQ_Inter(:,1)'));
end

%%
for i=1:Nstory
    evalc(strcat('DATA.SDRincrmaxi(i)=max(abs(DATA.SDR',num2str(i),'))'));
    evalc(strcat('DATA.RDRincrmaxi(i)=abs(DATA.SDR',num2str(i),'(end,1))'));
end
for i=1:Nstory+1
    evalc(strcat('DATA.PFAincrmaxi(i)=max(abs(DATA.PFA',num2str(i),'))'));
end
DATA.SDRincrmax=max(DATA.SDRincrmaxi);
DATA.PFAincrmax=max(DATA.PFAincrmaxi);
DATA.RDRincrmax=max(DATA.RDRincrmaxi);
         
cd (MainDirectory);
