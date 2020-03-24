
function MDoF_Save_IDA_Data(MainDirectory,RFname,GM,Nstory,IncrNo,IncrDATA,Delete_Flag)

%% Delete All OpenSEES Output Files
if Delete_Flag==1
	cd (RFname);
	cd (GM.GMname);
	delete *.out
	cd (MainDirectory);
end

%% Save Predetermined Limit Values at End of Vectors for IDA Ploting Reasons
IncrDATA.SA         (IncrNo) = max(IncrDATA.SA);

IncrDATA.SDR_Max    (IncrNo) = 0.2;
IncrDATA.RDR_Max    (IncrNo) = 0.2;
% IncrDATA.SF1_LC_Max (IncrNo) = max(IncrDATA.SF1_LC_Max);
for i=1:Nstory
    evalc(strcat('IncrDATA.SDR',num2str(i),'(IncrNo)=0.2'));
    evalc(strcat('IncrDATA.RDR',num2str(i),'(IncrNo)=0.2'));
end

for i=1:Nstory+1
    evalc(strcat('IncrDATA.PFA',num2str(i),'(IncrNo)= max (IncrDATA.PFA',num2str(i),')'));
end

%% Save Processed IDA Data to a Text File in a Different Folder for Each GM
cd (RFname);
cd (GM.GMname);

% SDR IDA DATA
file5 = fopen('IDA SDR.txt','wt');
for incr=1:IncrNo
  fprintf(file5,'%f\t',IncrDATA.SA(incr));
  for i = 1:Nstory
    fprintf(file5,'%f\t',eval(['IncrDATA.SDR' num2str(i) '(' num2str(incr) ')']));
  end
  fprintf(file5,'\n');
end
fclose(file5);

% RDR IDA DATA
file7 = fopen('IDA RDR.txt','wt');
for incr=1:IncrNo
  fprintf(file7,'%f\t%f\t',IncrDATA.SA(incr), IncrDATA.RDR_Max(incr));
%   for i = 1:Nstory
%     fprintf(file7,'%f\t',eval(['IncrDATA.RDR' num2str(i) '(' num2str(incr) ')']));
%   end
  fprintf(file7,'\n');
end
fclose(file7);

% PFA IDA DATA
file6 = fopen('IDA PFA.txt','wt');
for incr=1:IncrNo
  fprintf(file6,'%f\t',IncrDATA.SA(incr));
  for i = 1:Nstory+1
    fprintf(file6,'%f\t',eval(['IncrDATA.PFA' num2str(i) '(' num2str(incr) ')']));
  end
  fprintf(file6,'\n');
end
fclose(file6);

cd (MainDirectory);