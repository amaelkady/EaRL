function [HStory, Load, Mass, Parameters] = Import_ShearModel_Data_from_Excel(ModelType, ExcelFileName, N_Story)

if ModelType==1; SheetName='Elastic';           nParameters=1; end
if ModelType==2; SheetName='Bilinear';          nParameters=3; end
if ModelType==3; SheetName='IMK Bilinear';      nParameters=9; end
if ModelType==4; SheetName='IMK PeakOriented';  nParameters=9; end
[num,txt,Data] = xlsread(ExcelFileName,'Story_Height','B2:B100');   HStory     = num(1:N_Story,1);
[num,txt,Data] = xlsread(ExcelFileName,'Load','B2:B100');           Load       = num(1:N_Story,1);
[num,txt,Data] = xlsread(ExcelFileName,'Mass','B2:B100');           Mass       = num(1:N_Story,1);
[num,txt,Data] = xlsread(ExcelFileName,SheetName,'B2:Z100');        Parameters = num(1:N_Story,1:nParameters);

end
