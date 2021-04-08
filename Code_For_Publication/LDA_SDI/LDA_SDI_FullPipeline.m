clear all
n_ROI=379;
N_sub=100;
%paths
findpath=which('LDA_SDI_FullPipeline');
mypath=findpath(1:end-30);
addpath(genpath(mypath));% add path to matlab path folders
data_path=strcat(mypath,'Data');

%% IMPORTANT: SET PARAMETERS

LDA_task=1;% 1 if LDA to separate tasks for DECODING, 0 if LDA to separate subjects for FINGERPRINTING

test_type=1; %Choose setting for crossvalidation: only relevant for fingerprinting (LDA_TASK=0).
%1: leave-one-subject-task-out (100foldCV), 
%2: leave-one-task-out(8foldCV), 
%3: train one one task, test on another (all paiorwise combinations)


%% LOAD DATA SDI
FCnodestrength=0; % Load SDI values
Load_data_SDI_LDA

%% ANOVA to define task effect (decoding brain map), subject effect (fingerprinting brain map)
%compute ONLY INCASE OF LDA_TASK=1 = trials are regressed out
if LDA_task
    ANOVA_SDI
end

%% LDA
switch LDA_task
    case 1 %% DECODING
        %% surrogate null distribution to obtain Zscores for Weights
        X_LDA=SDIs'; % samplesxfeatures array
        Y_LDA=GROUP; %samplesx1 array
        nSurr=9999;
        surr_LDA; %% output: Weights_surr
        %% re-assign real values of Y_LDA for empirical analysis
        Y_LDA=GROUP; %samplesx1 array
        perform_LDA_SDI       
        %% compute *TASK-specific* classification maps from LDA weights  + BAR PLOTS
        %%OUTPUT--> Weights, where each column relates to a task-condition (REST, EMO, GAM, LAN, MOT, REL, SOC, WM)
        compute_task_maps;   
        %% compute standardized Weights (Weights-mean_null/std_null)
        mean_null=mean(Weights_surr,3);
        std_null=std(Weights_surr,0,3);
        zWeights=(Weights-mean_null)./std_null;
        %% PLOTS
        for i=1:size(zWeights,2)
            plot_surface_glasser(mypath,zWeights(:,i),othercolor('BuOr_10'),-prctile(abs(zWeights(:,i)),95),prctile(abs(zWeights(:,i)),95))
        end
        %% Compute bar plots
        figs='on';weights_to_consider= zWeights; %set variable weights_to_consider to the brainmap to consider
        compute_bar_plots;
        %% LDA CLASSIFICATION
        LDA_SDI_classify
        
      
    case 0 %FINGERPRINTING
        X_LDA=newSDIs'; % samplesxfeatures array
        Y_LDA=newGROUP; %samplesx1 array
        perform_LDA_SDI
        %% LDA CLASSIFICATION
        LDA_SDI_classify

end

%% COMPARISON WITH FC nodestrength
FCnodestrength=1;
Load_data_SDI_LDA

switch LDA_task
    case 1 %% DECODING
        X_LDA=SDIs'; % samplesxfeatures array
        Y_LDA=GROUP;
        perform_LDA_SDI
        LDA_SDI_classify
        
    case 0 %FINGERPRINTING
        X_LDA=newSDIs'; % samplesxfeatures array
        Y_LDA=newGROUP; %samplesx1 array
        perform_LDA_SDI
        %% LDA CLASSIFICATION
        LDA_SDI_classify
end
