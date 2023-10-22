%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                This function queries collapse occurance based on Monte Carlo simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [COLLAPSE_LOSSES_Per_Ri] = Get_Collapse_Loss_Per_Ri(app, CPS_Option,IMpoints,MedianCPS,SigmaCPS,nRealization,nStripe,Demolition_Cost,Replacement_Cost,TargetIM)

app.ProgressText.Value='CALCULATING LOSS DUE TO COLLAPSE'; drawnow;

% Get the Probability Vector of the Lognormal Collapse Fragility  Distribution
nIMpoints=length(IMpoints);
Pr_Collapse_per_IM = logncdf(IMpoints,log(MedianCPS),SigmaCPS);          
Pr_Collapse_per_IM = Pr_Collapse_per_IM';
Pr_Collapse_per_IM(isnan(Pr_Collapse_per_IM))=0;

COLLAPSE_LOSSES_Per_Ri=zeros(nRealization,nStripe);
if CPS_Option~=0                % If Collapse event is considered
    for im=1:nStripe            % Loop over analysis stripes
        
        for ii=1:nIMpoints-1    % Loop over IM levels
            if TargetIM(1,im)>=IMpoints(1,ii) && TargetIM(1,im)<IMpoints(1,ii+1)
                indexIM(1,im)=ii;
                break
            end
        end

        for Ri=1:nRealization                                                           % Loop over realizations 
            RndVar_P_Collapse=randi(100)/100;                                           % Generate a random number 0 to 1
            if RndVar_P_Collapse<=Pr_Collapse_per_IM(indexIM(1,im),1)                   % Query if collapse occures
                COLLAPSE_LOSSES_Per_Ri(Ri,im)=1 * (Demolition_Cost+Replacement_Cost);
            else
                COLLAPSE_LOSSES_Per_Ri(Ri,im)=0;
            end
        end

        app.ProgressText.Value=['CALCULATING COLLAPSE LOSS AT STRIPE #',num2str(im)]; app.ProgressBar.Position=[9 5 im/nStripe*613 6]; drawnow  
        
    end
end