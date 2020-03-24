function []= MDoF_CREATOR_ELASTIC ()
global MainDirectory ProjectName ProjectPath
clc;
cd(ProjectPath)
load(ProjectName,'Option6Data');
cd (MainDirectory);

v2struct(Option6Data); % unpack Option5Data 

% Open File to Write Code
INP = fopen('Option6.tcl','w+');

% HEADER LINES
fprintf(INP,'# %d-story Building\n',N_Story);
fprintf(INP,'#############################################################\n');
fprintf(INP,'\n');

fprintf(INP,'# CLEAR ALL;\n');
fprintf(INP,'wipe all;\n');
fprintf(INP,'\n');

fprintf(INP,'# BUILD MODEL (2D - 3 DOF/node)\n');
fprintf(INP,'model basic -ndm 2 -ndf 3\n');
fprintf(INP,'\n');


fprintf(INP,'#############################################################\n');
fprintf(INP,'#############################################################\n');

fprintf(INP,'# TYPE OF ANALYSIS\n'); 
fprintf(INP,'geomTransf PDelta 1;\n'); 
fprintf(INP,'\n');

fprintf(INP,'# SOURCING SUBROUTINES\n');
if ShowAnimation==1
fprintf(INP,'source DisplayModel3D.tcl;\n');
fprintf(INP,'source DisplayPlane.tcl;\n');
end
fprintf(INP,'source Spring_Rigid.tcl;\n');
fprintf(INP,'source Spring_Zero.tcl;\n');
fprintf(INP,'\n');

fprintf(INP,'# RESULT FOLDER\n');
fprintf(INP,'set MainFolder "Results";\n'); 
fprintf(INP,'file mkdir $MainFolder;\n');            
fprintf(INP,'\n');

fprintf(INP,'####################################################################################################\n');
fprintf(INP,'#                                              INPUT                                               #\n');
fprintf(INP,'####################################################################################################\n');
fprintf(INP,'\n');

fprintf(INP,'# FRAME CENTERLINE DIMENSIONS\n');
fprintf(INP,'set N_Story %2.0f;\n', N_Story);          
fprintf(INP,'\n');

fprintf(INP,'set A_Stiff 1000.0;\n');    
fprintf(INP,'set I_Stiff 100000.0;\n');  
fprintf(INP,'\n');

fprintf(INP,'# Basic Materials\n'); 
fprintf(INP,'uniaxialMaterial Elastic  99 1000000000.;  #Rigid Material \n'); 
fprintf(INP,'uniaxialMaterial Elastic  9  1.e-9; 		#Flexible Material \n'); 
fprintf(INP,'\n');

fprintf(INP,'####################################################################################################\n'); 
fprintf(INP,'#                                          PRE-CALCULATIONS                                        #\n'); 
fprintf(INP,'####################################################################################################\n'); 
fprintf(INP,'\n');

fprintf(INP,'# FRAME GRID LINES\n');
fprintf(INP,'set HBuilding %5.2f;\n',sum(HStory));
for Floor=N_Story+1:-1:2
	Story=Floor-1;
	fprintf(INP,'set Floor%d  %5.2f;\n', Floor,sum(HStory(1:Story)));      
end
fprintf(INP,'set Floor1 0.0;\n');                                        
fprintf(INP,'\n');

fprintf(INP,'set Axis0 0.0; ');
fprintf(INP,'set Axis1 %5.2f;\n',HStory(1));
fprintf(INP,'\n');

fprintf(INP,'####################################################################################################\n'); 
fprintf(INP,'#                                				NODES       				                        #\n'); 
fprintf(INP,'####################################################################################################\n'); 
fprintf(INP,'\n');

fprintf(INP,'# NODES\n'); 
for Floor=N_Story+1:-1:2
    node00=Floor*100+00; node10=Floor*100+10;
    node01=Floor*100+01; node11=Floor*100+11;
    node03=Floor*100+03; node13=Floor*100+13;
    node02=Floor*100+02;
    if Floor~=N_Story+1
        fprintf(INP,'node %d   $Axis0  $Floor%d;  ',node03,Floor); 
        fprintf(INP,'node %d   $Axis1  $Floor%d;\n',node13,Floor); 
    end
    fprintf(INP,'node %d   $Axis0  $Floor%d;  ',node00,Floor); 
	fprintf(INP,'node %d   %5.2f   $Floor%d;  ',node02,HStory(1)/2,Floor); 
	fprintf(INP,'node %d   $Axis1  $Floor%d;\n',node10,Floor); 
	fprintf(INP,'node %d   $Axis0  $Floor%d;  ',node01,Floor); 
	fprintf(INP,'node %d   $Axis1  $Floor%d;\n',node11,Floor); 
end
fprintf(INP,'node 100   $Axis0  $Floor1;  '); 
fprintf(INP,'node 102   %5.2f  $Floor1;  ',HStory(1)/2); 
fprintf(INP,'node 110   $Axis1  $Floor1;\n'); 
fprintf(INP,'\n');

for Story=N_Story:-1:1
    node05=Story*100+05; 
    node06=Story*100+06;
    fprintf(INP,'node %d   %5.2f  %5.2f;  ',node05,HStory(1)/2,HStory(Story)/2); 
    fprintf(INP,'node %d   %5.2f  %5.2f;\n',node06,HStory(1)/2,HStory(Story)/2); 
end

fprintf(INP,'###################################################################################################\n');
fprintf(INP,'#                                        COLUMN RIGID SPRINGS                                     #\n');
fprintf(INP,'###################################################################################################\n');
fprintf(INP,'\n');	

for Floor=N_Story+1:-1:2
    if Floor~=N_Story+1
        fprintf(INP,'Spring_Zero  103%d %d00 %d03;  ', Floor, Floor, Floor);
        fprintf(INP,'Spring_Zero  113%d %d10 %d13;\n', Floor, Floor, Floor);
    end
    fprintf(INP,'Spring_Zero  101%d %d00 %d01;  ', Floor, Floor, Floor);
    fprintf(INP,'Spring_Zero  111%d %d10 %d11;\n', Floor, Floor, Floor);
end
fprintf(INP,'\n');

fprintf(INP,'###################################################################################################\n');
fprintf(INP,'#                                           SHEAR SPRINGS                                         #\n');
fprintf(INP,'###################################################################################################\n');
fprintf(INP,'\n');

for Story=N_Story:-1:1
    node05=Story*100+05; 
    node06=Story*100+06;
%     if ModelType==1
        fprintf(INP,'uniaxialMaterial Elastic %d5 %.4f;\n', Story, Parameters(Story,1));
        fprintf(INP,'element zeroLength 900%d %d %d  -mat %d5 -dir 1;\n', Story, node05, node06, Story);        
%     elseif ModelType==2
%         fprintf(INP,'uniaxialMaterial Steel02 %d5 %.4f %.4f %.4f 15 0.925 15;\n', Floor-1, Parameters(Story,2), Parameters(Story,1), Parameters(Story,3));
%         fprintf(INP,'element zeroLength 900%d %d %d  -mat %d5 -dir 1;\n', Story, node05, node06, Story);        
%     elseif ModelType==3
%         fprintf(INP,'uniaxialMaterial IMKBilin %d5 %.4f %.4f %.4f  %.4f %.4f %.4f  %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f 1.0 1.0;\n',Story,Parameters(Story,1),Parameters(Story,5),Parameters(Story,6),Parameters(Story,7),Parameters(Story,2),Parameters(Story,3),Parameters(Story,4),Parameters(Story,5),Parameters(Story,6),Parameters(Story,7),Parameters(Story,2),Parameters(Story,3),Parameters(Story,4),Parameters(Story,8),Parameters(Story,8),Parameters(Story,8),Parameters(Story,9),Parameters(Story,9),Parameters(Story,9));
%         fprintf(INP,'element zeroLength 900%d %d %d  -mat %d5 -dir 1;\n', Story, node05, node06, Story);        
%     elseif ModelType==4
%         fprintf(INP,'uniaxialMaterial IMKPeakOriented %d5 %.4f %.4f %.4f  %.4f %.4f %.4f  %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f 1.0 1.0;\n',Story,Parameters(Story,1),Parameters(Story,5),Parameters(Story,6),Parameters(Story,7),Parameters(Story,2),Parameters(Story,3),Parameters(Story,4),Parameters(Story,5),Parameters(Story,6),Parameters(Story,7),Parameters(Story,2),Parameters(Story,3),Parameters(Story,4),Parameters(Story,8),Parameters(Story,8),Parameters(Story,8),Parameters(Story,8),Parameters(Story,9),Parameters(Story,9),Parameters(Story,9),Parameters(Story,9));
%         fprintf(INP,'element zeroLength 900%d %d %d  -mat %d5 -dir 1;\n', Story, node05, node06, Story);        
%     end
end
fprintf(INP,'\n');

fprintf(INP,'####################################################################################################\n');
fprintf(INP,'#                                       RIGID BEAM & COLUMN ELEMENTS                               #\n');
fprintf(INP,'####################################################################################################\n');
fprintf(INP,'\n');

for Story=N_Story:-1:1  
    node02bottom=Story*100+02; 
    node02top=(Story+1)*100+02; 
    node05=Story*100+05; 
    node06=Story*100+06;

    if Story==1
        fprintf(INP,'element elasticBeamColumn 100%d0 %d00 %d01 100000000. 100000000. 100000000. 1;  ',Story, Story, Story+1);
        fprintf(INP,'element elasticBeamColumn 100%d1 %d10 %d11 100000000. 100000000. 100000000. 1;\n',Story, Story, Story+1);
    else
        fprintf(INP,'element elasticBeamColumn 100%d0 %d03 %d01 100000000. 100000000. 100000000. 1;  ',Story, Story, Story+1);
        fprintf(INP,'element elasticBeamColumn 100%d1 %d13 %d11 100000000. 100000000. 100000000. 1;\n',Story, Story, Story+1);        
    end
    fprintf(INP,'element elasticBeamColumn 200%d1 %d %d 100000000. 100000000. 100000000. 1;\n',Story, node02bottom, node05);        
    fprintf(INP,'element elasticBeamColumn 200%d2 %d %d 100000000. 100000000. 100000000. 1;\n',Story, node02top, node06);        

end

for Floor=N_Story+1:-1:2   
    node00=Floor*100+00; node10=Floor*100+10;
    node02=Floor*100+02;
    fprintf(INP,'element elasticBeamColumn 500%d01 %d %d 100000000. 100000000. 100000000. 1; ',Floor, node00, node02);
    fprintf(INP,'element elasticBeamColumn 500%d02 %d %d 100000000. 100000000. 100000000. 1;\n',Floor, node02, node10);
end
fprintf(INP,'\n');

fprintf(INP,'###################################################################################################\n');
fprintf(INP,'#                                       BOUNDARY CONDITIONS                                       #\n');
fprintf(INP,'###################################################################################################\n');
fprintf(INP,'\n');	

fprintf(INP,'# Base Support\n');
fprintf(INP,'fix 100 1 1 0; fix 102 1 1 1; fix 110 1 1 0;');
fprintf(INP,'\n');

fprintf(INP,'# Spring Supports\n');
for Floor=N_Story+1:-1:2
    fprintf(INP,'fix %d00 0 1 0; equalDOF %d00 %d10 2; \n', Floor, Floor, Floor);
end
fprintf(INP,'\n');

fprintf(INP,'###############################################################################################################################################################################\n');
fprintf(INP,'###############################################################################################################################################################################\n');
fprintf(INP,'                                                                                  puts "Model Built"\n');
fprintf(INP,'###############################################################################################################################################################################\n');
fprintf(INP,'###############################################################################################################################################################################\n');
fprintf(INP,'\n');

fprintf(INP,'###################################################################################################\n');
fprintf(INP,'#                                             RECORDERS                                           #\n');
fprintf(INP,'###################################################################################################\n');
fprintf(INP,'\n');

fprintf(INP,'# Story Drift\n');
for i=N_Story:-1:1
    fprintf(INP,'recorder Drift -file $MainFolder/SDR%d.out   -iNode %d00 -jNode %d00 -dof 1 -perpDirn 2;\n',i,i,i+1); 
end
fprintf(INP,'\n');

fprintf(INP,'# Floor Displacement\n');
for Floor=N_Story+1:-1:2
    fprintf(INP,'recorder Node -file $MainFolder/Disp%d.out -node %d00  -dof 1 disp;\n',Floor,Floor); 
end
fprintf(INP,'\n');

fprintf(INP,'###################################################################################################\n');
fprintf(INP,'#                                      STATIC GRAVITY ANALYSIS                                    #\n');
fprintf(INP,'###################################################################################################\n');
fprintf(INP,'\n');

fprintf(INP,'pattern Plain 100 Linear {\n');
fprintf(INP,'\n');
fprintf(INP,'# FLOOR LOADS\n');
for Floor=N_Story+1:-1:2
    fprintf(INP,'load %d00 0. %6.3f 0.; load %d10 0. %6.3f 0.;\n',Floor,-Load(Floor-1,1)/2,Floor,-Load(Floor-1,1)/2); 
end
fprintf(INP,'\n');
fprintf(INP,'\n');
fprintf(INP,'}\n');
fprintf(INP,'\n');

fprintf(INP,'# Conversion Parameters\n');
fprintf(INP,'constraints Plain;\n');     		
fprintf(INP,'numberer RCM;\n');			
fprintf(INP,'system BandGeneral;\n');		
fprintf(INP,'test NormDispIncr 1.0e-5 60 ;\n'); 		
fprintf(INP,'algorithm Newton;\n');			
fprintf(INP,'integrator LoadControl 0.1;\n');
fprintf(INP,'analysis Static;\n');			
fprintf(INP,'analyze 10;\n');  
fprintf(INP,'\n');

fprintf(INP,'loadConst -time 0.0;\n');
fprintf(INP,'\n');

fprintf(INP,'###############################################################################################################################################################################\n');
fprintf(INP,'###############################################################################################################################################################################\n');
fprintf(INP,'                                                                                     puts "Gravity Done"\n');
fprintf(INP,'###############################################################################################################################################################################\n');
fprintf(INP,'###############################################################################################################################################################################\n');
fprintf(INP,'\n');

fprintf(INP,'##############################################################################################################################################################################\n');
fprintf(INP,'#                                                                              Linear Static Push Analysis                     		    #\n');
fprintf(INP,'##############################################################################################################################################################################\n');

fprintf(INP,'# Create Load Pattern\n');
fprintf(INP,'pattern Plain 200 Linear {\n');
for i=2:N_Story+1
    fprintf(INP,'load %d00 %6.4f 0.0 0.0\n',i,Fx(i));
end
fprintf(INP,'}\n');

fprintf(INP,'# Load Control Parameters\n');	
fprintf(INP,'constraints Plain;\n');
fprintf(INP,'numberer RCM; \n');
fprintf(INP,'system BandGeneral;\n');
fprintf(INP,'test NormDispIncr 1.0e-5 400;\n');
fprintf(INP,'algorithm 	Newton;\n');
fprintf(INP,'integrator LoadControl 0.1;\n');
fprintf(INP,'analysis 	Static;\n');
fprintf(INP,'analyze 	10;\n');

fprintf(INP,'puts "Linear static push complete"\n');
	

fprintf(INP,'wipe all;\n');

fclose all;