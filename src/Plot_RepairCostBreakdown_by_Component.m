function []= Plot_RepairCostBreakdown_by_Component(DEAGG_DATA,C_Data,COMPDATA,N_Story,IMpoints,Sa_target,BarChart,UnitOption,Replacement_Cost,RunMethodology,R_target,nRealization,TargetIM,Stripe)

if UnitOption==1
    NormVal=10^6;
    label='Repair cost [M$]';
else
    NormVal=Replacement_Cost/100;    
    label='Repair cost [% \itCost\rm]';
end

if RunMethodology==1
    
    % Get index of target IM point
    for i=1:length(IMpoints)-1
        if Sa_target>=IMpoints(1,i) && Sa_target<IMpoints(1,i+1)
            indexSa1=i;
            break
        end
    end    

    % Get the unique SC IDs
    CIDs = unique(C_Data(:,1));

    DEAGG_STORY_LOSS=zeros(size(CIDs,1),N_Story+1);
    % Get Repair cost losses at target IM
    for i=1:size(CIDs,1)  % Loop over all Components
        for n=1:N_Story+1   % Loop over all stories
            INDX =find(CIDs(i,1)==DEAGG_DATA(:,3) & n==DEAGG_DATA(:,2) & indexSa1==DEAGG_DATA(:,1));
            SUM=0.0;
            for k=1:size(INDX,1)
                SUM=SUM+DEAGG_DATA(INDX(k,1),4);
            end
            DEAGG_STORY_LOSS(i,n)=SUM;
        end
        Name(i,1)=COMPDATA.C_shortername(CIDs(i,1));
    end

    Clabel=unique(Name(:,1),'stable');

    DEAGG_STORY_LOSSX=zeros(size(Clabel,1),N_Story+1);
    % Sum up repair costs for components with similar "short names"
    for i=1:size(Clabel,1)
        SUM=0.0;
        for j=1:size(DEAGG_STORY_LOSS,1)  % Loop over all Componentss
            if Clabel(i,1)==Name(j,1)
                SUM=SUM+DEAGG_STORY_LOSS(j,:);
            end
        end
        DEAGG_STORY_LOSSX(i,:)=SUM;
    end

    DEAGG_STORY_LOSSX=sum(DEAGG_STORY_LOSSX,2);

else
    
    % Get the unique SC IDs
    CIDs = unique(C_Data(:,1));
    IDX_STRIP=find(DEAGG_DATA(:,1)==Stripe & DEAGG_DATA(:,6)==R_target);

    DEAGG_STORY_LOSS=zeros(size(CIDs,1),1);
    for i=1:size(CIDs,1)
        for j=min(IDX_STRIP):max(IDX_STRIP)
            if DEAGG_DATA(j,3)==CIDs(i,1)
                DEAGG_STORY_LOSS(i,1) = DEAGG_STORY_LOSS(i,1) + DEAGG_DATA(j,4);                      
            end
        end
        Name(i,1)=COMPDATA.C_shortername(CIDs(i,1));
    end
        
    Clabel=unique(Name(:,1),'stable');
    DEAGG_STORY_LOSSX=zeros(size(Clabel,1),1);
    for i=1:size(Clabel,1)
        for j=1:size(DEAGG_STORY_LOSS,1)
            if Clabel(i,1)==Name(j,1)
                DEAGG_STORY_LOSSX(i,1) = DEAGG_STORY_LOSSX(i,1) + DEAGG_STORY_LOSS(j,1);                      
            end
        end
        Name(i,1)=COMPDATA.C_shortername(CIDs(i,1));
    end

end

%% PLOT

if BarChart==1
    figure('Color','w','Position', [500 300 550 350]);
    bar(DEAGG_STORY_LOSSX/NormVal,'r');
    set(gca, 'fontname', 'Courier', 'fontsize',12);
    ylabel (label,'fontsize',16);
    set(gca,'Ylim',[0.0 max(0.01,max(DEAGG_STORY_LOSSX)/NormVal*1.2)]);
    set(gca,'XTickLabel',Clabel, 'fontsize',12);
    rotateXLabels( gca(), 45)
else
    % Plot with respect to component IDs
    figure('Color','w','Position', [500 300 750 350]);
    p=pie(DEAGG_STORY_LOSSX/sum(DEAGG_STORY_LOSSX));
    for i=1:size(p,2)
        if mod(i,2)==0
            t=p(i);
            t.FontName = 'Courier';
            t.FontWeight = 'bold';
            t.FontSize=12;
        end
    end
    set(gca, 'fontname', 'Courier', 'fontsize',12);
    legend(Clabel,'Location','eastoutside','Orientation','vertical','Fontsize',12)  
end

if RunMethodology==1
    title(gca,[num2str(round(sum(DEAGG_STORY_LOSSX)/10^6*100)/100),'M$ in repairs at IM=', num2str(round(Sa_target*100)/100),'g'], 'fontname', 'Courier', 'fontsize',12);
else
    title(gca,[num2str(round(sum(DEAGG_STORY_LOSSX)/10^6*100)/100),'M$ in repairs at IM=', num2str(TargetIM(1,Stripe)),'g, Ri #', num2str(R_target)], 'fontname', 'Courier', 'fontsize',12);
end

end