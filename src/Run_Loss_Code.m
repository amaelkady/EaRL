function Run_Loss_Code(app)
global MainDirectory ProjectPath ProjectName RunMethodology
clc;
cd (ProjectPath)
load(ProjectName,'ResponseDataStatus','Response_Option','Component_Option','ResultsStatus','RunMethodology','Option5_Type')
cd (MainDirectory)

if ResponseDataStatus~=1
    warndlg('Response Data is missing!');
    return
end

if RunMethodology ==1
    if ResultsStatus==1
        cd (ProjectPath)
        variableInfo = who('-file', ProjectName);
        cd (MainDirectory)
        if ismember('COLLAPSE_LOSSES_Per_IM', variableInfo) && ismember('DEMOLITION_LOSSES_Per_IM', variableInfo)&& ismember('DEAGG_COMPONENT_REPAIR_COST', variableInfo)
            rmvar(ProjectPath,ProjectName, 'COLLAPSE_LOSSES_Per_IM', 'DEMOLITION_LOSSES_Per_IM','DEAGG_COMPONENT_REPAIR_COST')
            cd (MainDirectory)
        end
        if ismember('STORY_REPAIR_COST', variableInfo) && ismember('STORY_REPAIR_COST_SC', variableInfo)&& ismember('STORY_REPAIR_COST_NSC_SDR', variableInfo)&& ismember('NSC_ACC_REPAIR_COST_PerIM', variableInfo)&& ismember('REPAIR_COST_TOTAL_PerIM', variableInfo)&& ismember('TOTAL_LOSSES_PerIM', variableInfo)
            rmvar(ProjectPath,ProjectName, 'STORY_REPAIR_COST','STORY_REPAIR_COST_SC','STORY_REPAIR_COST_NSC_SDR','STORY_REPAIR_COST_NSC_ACC','SC_REPAIR_COST_PerIM','NSC_SDR_REPAIR_COST_PerIM','NSC_ACC_REPAIR_COST_PerIM','REPAIR_COST_TOTAL_PerIM','TOTAL_LOSSES_PerIM')
            cd (MainDirectory)
        end
    end
    
    if Response_Option~=5; Option5_Type=0; end
    
    if Response_Option==1 || Option5_Type==1
        if     Component_Option==1; LossCode_PEER_CO1_IDA(app);
        elseif Component_Option==2; LossCode_PEER_CO2_IDA(app);
        elseif Component_Option==3; LossCode_PEER_CO3_IDA(app);
        end
    else
        if     Component_Option==1; LossCode_PEER_CO1(app);
        elseif Component_Option==2; LossCode_PEER_CO2(app);
        elseif Component_Option==3; LossCode_PEER_CO3(app);
        end
    end
end

if RunMethodology==2
    if ResultsStatus==1
        cd (ProjectPath)
        variableInfo = who('-file', ProjectName);
        cd (MainDirectory)
        if ismember('COLLAPSE_LOSSES_Per_IM', variableInfo) && ismember('DEMOLITION_LOSSES_Per_IM', variableInfo)&& ismember('DEAGG_DATA', variableInfo)
            rmvar(ProjectPath,ProjectName, 'COLLAPSE_LOSSES_Per_IM', 'DEMOLITION_LOSSES_Per_IM','DEAGG_DATA')
            cd (MainDirectory)
        end
    end
    
    if      Component_Option==1; LossCode_FEMAP58_CO1(app);
    elseif  Component_Option==2; LossCode_FEMAP58_CO2(app);
    elseif  Component_Option==3; LossCode_FEMAP58_CO3(app);
    end
end

end