function []=Plot_LAMBDA(DEAGG_DATA,COLLAPSE_LOSSES_Per_Ri,DEMOLITION_LOSSES_Per_Ri,nRealization,UnitOption,Replacement_Cost,IMpoints,MAF,TargetIM,Stripe,Component_Option)

if Component_Option==1
    REPAIR_COST_Per_Ri=zeros(nRealization,1);
    IDX_STRIP=find(DEAGG_DATA(:,1)==Stripe);
    for Ri=1:nRealization
        for i=min(IDX_STRIP):max(IDX_STRIP)
            if DEAGG_DATA(i,6)==Ri
                REPAIR_COST_Per_Ri(Ri,1)=REPAIR_COST_Per_Ri(Ri,1) + DEAGG_DATA(i,4);
            end
        end
    end  
else
    REPAIR_COST_Per_Ri=zeros(nRealization,1);
    IDX_STRIP=find(DEAGG_DATA(:,1)==Stripe);
    for Ri=1:nRealization
        for i=min(IDX_STRIP):max(IDX_STRIP)
            if DEAGG_DATA(i,2)==Ri
                REPAIR_COST_Per_Ri(Ri,1)=REPAIR_COST_Per_Ri(Ri,1) + DEAGG_DATA(i,7);
            end
        end
    end                  
end

counter=1;
for Ri=1:size(REPAIR_COST_Per_Ri,1)
    if COLLAPSE_LOSSES_Per_Ri(Ri,Stripe)==0 && DEMOLITION_LOSSES_Per_Ri(Ri,Stripe)==0
        Realization_Filtered(counter,1)=Ri;
        REPAIR_COST_Per_Ri_Filtered(counter,1)=REPAIR_COST_Per_Ri(Ri,1);
        counter=counter+1;
    end
end  
                    
if UnitOption==1
    NormVal=1.0;
    str='Repair Cost [M$]';
else
    NormVal=Replacement_Cost/10^6/100;
    str='Repair Cost [% \itCost\rm]';
end

%% Plot Annual Rate of Exceeding the repair cost
X=0.0:(max(REPAIR_COST_Per_Ri_Filtered)-min(REPAIR_COST_Per_Ri_Filtered))/50:max(REPAIR_COST_Per_Ri_Filtered)*1.1;
Y=normcdf(X,mean(REPAIR_COST_Per_Ri_Filtered),std(REPAIR_COST_Per_Ri_Filtered));
Y=1-Y;
HazardSlope = abs(diff(MAF));
for i=1:length(IMpoints)-1
    if TargetIM(1,Stripe)>=IMpoints(1,i) && TargetIM(1,Stripe)<IMpoints(1,i+1)
        indexSa1=i;
        break
    end
end

HazardSlope_at_TargetIM=abs((MAF(indexSa1,1)-MAF(indexSa1-1,1))/(IMpoints(1,indexSa1)-IMpoints(1,indexSa1-1)));
Y=Y*HazardSlope_at_TargetIM;
X(end+1)=max(X);
Y(end+1)=0.0;
figure('Color','w','Position', [500 300 450 350]);
plot(X/10^6/NormVal,Y,'-k','linewidth',2);                 
grid on; box on; hold on;
set(gca,'Ylim',[0.0 max(max(Y),0.00001)]);
set(gca,'Xlim',[0.0 max(max(X/10^6/NormVal),0.00001)]);
ylabel ('\lambda(cost \geq Cost)');
xlabel (str);

Area=0;
for i=1:size(X,2)-1
    Area=Area+(X(i+1)-X(i))*(Y(i+1)+Y(i))/2;
end

xx2{1}=['Mean cumulative annual '];
xx2{2}=['repair cost=',num2str(round(Area)),'$'];
text(0.3*max(X)/10^6/NormVal,0.8*max(Y),xx2, 'fontname', 'Courier', 'fontsize',12, 'fontweight','bold');

X=[0;X'];Y=[0;Y'];
pgon = polyshape(X/10^6/NormVal,Y);
plot(pgon,'FaceColor','y')
set(gca, 'fontname', 'Euclid', 'fontsize',16);

end