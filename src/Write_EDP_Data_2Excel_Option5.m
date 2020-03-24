function Write_EDP_Data_2Excel_Option5(N_GM,N_Story, EDP_Data, MainDirectory, FilePath ,FileName)

GM_No=(1:N_GM)'; GM_No = table(GM_No);
Story=(1:N_Story); Story = table(Story);
Floor=(1:N_Story+1); Floor = table(Floor);

cd (FilePath)
writetable(GM_No,FileName,'Sheet','SDR','Range','A2')
writetable(Story,FileName,'Sheet','SDR','Range','B2')
writematrix(EDP_Data.SDR.S1,FileName,'Sheet','SDR','Range','B3')

writetable(GM_No,FileName,'Sheet','RDR','Range','A2')
writetable(Story,FileName,'Sheet','RDR','Range','B2')
writematrix(EDP_Data.RDR.S1,FileName,'Sheet','RDR','Range','B3')

writetable(GM_No,FileName,'Sheet','PFA','Range','A2')
writetable(Floor,FileName,'Sheet','PFA','Range','B2')
writematrix(EDP_Data.PFA.S1,FileName,'Sheet','PFA','Range','B3')
cd (MainDirectory)

end