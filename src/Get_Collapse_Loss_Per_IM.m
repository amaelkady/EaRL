function [COLLAPSE_LOSSES_Per_IM,Pr_Collapse_per_IM]=Get_Collapse_Loss_Per_IM(app,IMpoints,MedianCPS,SigmaCPS,Replacement_Cost)

app.ProgressText.Value='CALCULATING LOSS DUE TO COLLAPSE'; drawnow;

Pr_Collapse_per_IM = logncdf(IMpoints,log(MedianCPS),SigmaCPS);   % Get the Probability Values of the Collapse Fragility Lognormal Distribution
Pr_Collapse_per_IM = Pr_Collapse_per_IM';
Pr_Collapse_per_IM(isnan(Pr_Collapse_per_IM))=0;
COLLAPSE_LOSSES_Per_IM = Pr_Collapse_per_IM * Replacement_Cost;    % Calculate Collapse Cost
