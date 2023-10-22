function [DEAGGREGATED_LOSS_DATA, REALIZATIONS_EDP_DATA, DEAGGREGATED_LOSS_DATA_Titles]=Get_Summarized_Data(RunMethodology,DEAGG_DATA,REALIZATIONS,Component_Option,Placardstatus)

if RunMethodology==1
    
else
    if Component_Option==1
        REALIZATIONS_EDP_DATA=REALIZATIONS;
        DEAGGREGATED_LOSS_DATA(:,1)  = DEAGG_DATA(:,1);  % Stripe no.
        DEAGGREGATED_LOSS_DATA(:,2)  = DEAGG_DATA(:,6);  % Realization no.
        DEAGGREGATED_LOSS_DATA(:,3)  = DEAGG_DATA(:,7);  % Occuring event flag
        DEAGGREGATED_LOSS_DATA(:,4)  = DEAGG_DATA(:,2);  % Level number
        DEAGGREGATED_LOSS_DATA(:,5)  = DEAGG_DATA(:,3);  % Component ID
        DEAGGREGATED_LOSS_DATA(:,6)  = DEAGG_DATA(:,5);  % Component classification
        DEAGGREGATED_LOSS_DATA(:,7)  = DEAGG_DATA(:,12); % Realization EDP value
        DEAGGREGATED_LOSS_DATA(:,8)  = DEAGG_DATA(:,8);  % Activated damage state
        DEAGGREGATED_LOSS_DATA(:,9)  = DEAGG_DATA(:,9);  % Damage state cost
        DEAGGREGATED_LOSS_DATA(:,10) = DEAGG_DATA(:,10); % Number of component unit
        DEAGGREGATED_LOSS_DATA(:,11) = DEAGG_DATA(:,4);  % Repair cost
        DEAGGREGATED_LOSS_DATA(:,12) = DEAGG_DATA(:,11); % Repair time
        DEAGGREGATED_LOSS_DATA(:,13) = DEAGG_DATA(:,13); % Injury number;
        DEAGGREGATED_LOSS_DATA(:,14) = DEAGG_DATA(:,14); % Casualty number;
        if Placardstatus==1
        DEAGGREGATED_LOSS_DATA(:,15) = DEAGG_DATA(:,16); % Unsafe placard flag (0/1)
        end
        DEAGGREGATED_LOSS_DATA_Titles={'Stripe number','Realization number','Occurying event flag','Story/Floor number','Component ID','Component classification','Realization EDP value','Active damage state','Damage state repair cost','Number of component units','Repair cost','Repair time','Number of injuries','Number of casualties','unsafe placard flag'};
    else
        REALIZATIONS_EDP_DATA=REALIZATIONS;
        DEAGGREGATED_LOSS_DATA(:,1)  = DEAGG_DATA(:,1);  % Stripe no.
        DEAGGREGATED_LOSS_DATA(:,2)  = DEAGG_DATA(:,2);  % Realization no.
        DEAGGREGATED_LOSS_DATA(:,3)  = DEAGG_DATA(:,3);  % Level number
        DEAGGREGATED_LOSS_DATA(:,4)  = DEAGG_DATA(:,8);  % Realization SDR value
        DEAGGREGATED_LOSS_DATA(:,5)  = DEAGG_DATA(:,9);  % Realization PFA value
        DEAGGREGATED_LOSS_DATA(:,6)  = DEAGG_DATA(:,10); % Realization PGA value
        DEAGGREGATED_LOSS_DATA(:,7)  = DEAGG_DATA(:,4);  % Structural component repair cost
        DEAGGREGATED_LOSS_DATA(:,8)  = DEAGG_DATA(:,5);  % Non-Structural SDR-sensitive component repair cost
        DEAGGREGATED_LOSS_DATA(:,9)  = DEAGG_DATA(:,6);  % Non-Structural ACC-sensitive component repair cost
        DEAGGREGATED_LOSS_DATA_Titles={'Stripe number','Realization number','Story/Floor number','Realization SDR value','Realization PFA value','Realization PGA value','SC Repair Cost','NSC SDR-Sensitive Repair Cost','NSC ACC-Sensitive Repair Cost'};
    end
end