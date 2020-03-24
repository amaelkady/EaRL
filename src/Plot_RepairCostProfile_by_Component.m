 function []= Plot_RepairCostProfile_by_Component(DEAGG_DATA,C_Data,COMPDATA,N_Story,IMpoints,Sa_target,UnitOption,Replacement_Cost,RunMethodology,R_target,nRealization,TargetIM,Stripe)
 
if UnitOption==1
    NormVal=10^6;
    label='Repair cost [M$]';
else
    NormVal=Replacement_Cost/100;    
    label='Repair cost [% \itCost\rm]';
end

Elevation=1:N_Story+1;

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

    for i=1:size(CIDs,1)  % Loop over all SC
        for j=1:N_Story+1   % Loop over all stories
            SUM=0.0;
            % find the row index corrosponding to loss at a given story and component and intensity level
            INDX=find(CIDs(i,1)==DEAGG_DATA(:,3) & j==DEAGG_DATA(:,2) & indexSa1==DEAGG_DATA(:,1));
            for k=1:size(INDX,1)
                SUM=SUM+DEAGG_DATA(INDX(k,1),4);
            end
            DEAGG_STORY_LOSS(i,j)=SUM; % the rows of this array represents the component number while the columns represent the story
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
    
else
   
    % Get the unique SC IDs
    CIDs = unique(C_Data(:,1));
    IDX_STRIP=find(DEAGG_DATA(:,1)==Stripe);

    DEAGG_STORY_LOSS=zeros(size(CIDs,1),N_Story+1);
    for i=1:size(CIDs,1)
        for j=min(IDX_STRIP):max(IDX_STRIP)
            for n=1:N_Story+1
            if DEAGG_DATA(j,3)==CIDs(i,1) && DEAGG_DATA(j,2)==n && DEAGG_DATA(j,6)==R_target
                DEAGG_STORY_LOSS(i,n) = DEAGG_STORY_LOSS(i,n) + DEAGG_DATA(j,4);                      
            end
            end
        end
        Name(i,1)=COMPDATA.C_shortername(CIDs(i,1));
    end
        
    Clabel=unique(Name(:,1),'stable');

    DEAGG_STORY_LOSSX=zeros(size(Clabel,1),N_Story+1);
    for i=1:size(Clabel,1)
        for j=1:size(DEAGG_STORY_LOSS,1)
            if Clabel(i,1)==Name(j,1)
                DEAGG_STORY_LOSSX(i,:) = DEAGG_STORY_LOSSX(i,:) + DEAGG_STORY_LOSS(j,:);                      
            end
        end
        Name(i,1)=COMPDATA.C_shortername(CIDs(i,1));
    end
    
end

% Plot with respect to SC component IDs
figure('Color','w','Position', [500 300 600 350]);
grid on; box on; hold on;   
for i=1:size(Clabel,1)  % Loop over all SC
    plot(DEAGG_STORY_LOSSX(i,:)/NormVal,Elevation,'-o','linewidth',1.5);
end
set(gca, 'fontname', 'Courier', 'fontsize',14);
xlabel (label,'fontsize',14);
ylabel ('Story/Floor','fontsize',14);
MaxLosses=ceil(max(max(DEAGG_STORY_LOSSX/NormVal))*10)/10;
set(gca,'Xlim',[0.0 max(MaxLosses,0.01)]);
set(gca,'Ylim',[1 N_Story+1]);
set(gca,'YTick',Elevation);

legend1=legend (Clabel);
set(legend1,'fontname', 'Courier', 'fontsize',12,'Location','eastoutside');

MaxLosses=sum(sum(DEAGG_STORY_LOSSX));

if RunMethodology==1
    title(gca,[num2str(round(MaxLosses/10^6*100)/100),'M$ in repairs at IM=', num2str(round(Sa_target*100)/100),'g'], 'fontname', 'Courier', 'fontsize',12);
else
    title(gca,[num2str(round(MaxLosses/10^6*100)/100),'M$ in repairs at IM=', num2str(TargetIM(1,Stripe)),'g, Ri #', num2str(R_target)], 'fontname', 'Courier', 'fontsize',10);
end
 end