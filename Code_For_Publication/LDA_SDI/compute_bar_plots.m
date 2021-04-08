
%% BAR PLOTS: find percentage of different YEO networks in each task classification map
%compute
load(strcat(data_path,'/Glasser_ch2_yeo_RS7.mat'));
yeoROIs(361:379)=8;%subucortical
labels={'VIS','SM','DA','VA','Limbic','FPN','DMN','SUBC'};

% select highest nodes on Weights (or zWeights)
clear  Weights_perc ROIs_yeo_pos ROIs_yeo_neg percentage_pos percentage_neg pos neg
if contains(figs,'on');figure;end
for i=1:size(weights_to_consider,2)

    Weights_perc(:,i)=abs(weights_to_consider(:,i))>prctile(abs(weights_to_consider(:,i)),95);
    
    pos=find((Weights_perc(:,i)==1).*(weights_to_consider(:,1)>0));
    neg=find((Weights_perc(:,i)==1).*(weights_to_consider(:,1)<0));
    ROIs_yeo_pos{i}=yeoROIs(pos);
    ROIs_yeo_neg{i}=yeoROIs(neg);
    for j=1:8 %networks YEO
        percentage_pos(j,i)=size(find(ROIs_yeo_pos{i}==j),1)./(size(ROIs_yeo_pos{i},1)+size(ROIs_yeo_neg{i},1)); % percentage of task classification map belonging to each network
        percentage_neg(j,i)=size(find(ROIs_yeo_neg{i}==j),1)./(size(ROIs_yeo_pos{i},1)+size(ROIs_yeo_neg{i},1));
    end

    if contains(figs,'on');subplot(2,4,i);bar([percentage_neg(:,i),percentage_pos(:,i)], 'stacked');set(gcf,'color','w');set(gca,'FontSize',15)
    end
end
