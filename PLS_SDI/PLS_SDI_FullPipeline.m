clear all
%paths
findpath = which('PLS_SDI_FullPipeline');
[PLSpath,~,~] = fileparts(findpath); % Code_For_Publication/PLS_SDI path
addpath(genpath(fullfile(PLSpath,'myPLS-master'))); % add myPLS-master to matlab path
[CODEpath,~,~] = fileparts(PLSpath);
addpath(genpath(fullfile(CODEpath,'surface_plotkit')));
DATApath = fullfile(CODEpath,'Data'); % data path
cd(PLSpath)

%% LOAD DATA SDI
% IMPORTANT: SELECT THE TASK YOU WANT TO CONSIDER AMONG REST / EMOTION / 
% GAMBLING / LANGUAGE / MOTOR / RELATIONAL / SOCIAL / WM 
selected_task = 'WM';
load(fullfile(DATApath,'Final_SDIs',['SDIs_SUBJECT_',selected_task,'_avg_PLS.mat']),'X'); % X (average LR, RL)

%% LOAD COGNITIVE DATA
load(fullfile(DATApath,'Final_Cognition','10features_Cognition_ScoreSign.mat')); % Bpca, domains

%% LOAD FINGERPRINT AND DECODING PATTERNS
% Load node weights indicating predictive value for subject ('FINGERPRINTING PATTERN' from ANOVA)
load(fullfile(DATApath,'Final_Patterns','nodes_SUBJECT_nonTHR.mat')); % nodes_SBJ
% Load node weights indicating predictive value for all tasks ('DECODING PATTERN' from ANOVA)
load(fullfile(DATApath,'Final_Patterns','nodes_TASK_nonTHR.mat')); % nodes_TASK

%% RUN PLS ANALYSIS
% PLS settings
myPLS_inputs_SDI_cognition;

% Initialize
[input,pls_opts,save_opts] = myPLS_initialize(input,pls_opts,save_opts);

% Run analysis
res = myPLS_analysis(input,pls_opts);
% Bonferroni-corrected p-values
disp('Bonferroni-corrected p-values for PLS latent components (SDI-cognitive saliences):');
pval_corrected = res.LC_pvals * length(domains)
        
% Plot and save results (Figure 4b)
myPLS_plot_results(res,save_opts);

%% PLOT SDI SALIENCE ON CORTICAL SURFACE (Figure 4a)
% Plot the first SDI salience. Note that the other saliences are stored in the
% variable res.V
plot_surface_glasser(CODEpath,res.V(1:360,1),othercolor('YlOrRd5'),0.03,0.07);

%% PIE CHARTS (Figure 4c)
% RGB colors of Yeo 7 Net
rgbmatrix = [130,57,139;...
      101,154,196;...
      26,133,53;...
      159,103,164;...
      232,237,181;...
      246,173,70;...
      216,92,110;...
      0,0,0] / 255;
labels_rsn = {'Vis','SomMot','DorsAttn','SalVentAttn','Limbic','Cont','Default','SubCort'}';
nrsn = length(labels_rsn);

% Load matching between Glasser and Yeo7(~Schaefer1000)
load(fullfile(DATApath,'match_glasser-TO-schYeo7.mat')); % parc_match

% IMPORTAN - SELECT MEASURE FOR PIE CHART: brain salience [res.V(:,1)],
% fingerprint patterns [nodes_SBJ] or decoding pattern [nodes_TASK]
% -------------------------------------------------------------------------
y = res.V(:,1);
val = zeros(nrsn,1);
th = prctile(y,75);
ii_above_th = find(y >= th);
for i = 1:nrsn-1
    ii = find(contains(parc_match.label_glasserTOschYeo7,strcat('_',labels_rsn{i},'_')));
    val(i) = length(intersect(ii,ii_above_th)) / length(ii_above_th); 
end
val(nrsn) = length(intersect([361:379],ii_above_th)) / length(ii_above_th); 
% Pie chart
close all
clc
fig = figure;
ax = axes('Parent', fig);
hPieComponentHandles = pie(ax, val);
for i = 1:nrsn
    pieColorMap = rgbmatrix(i,:); % Color for this segment
    set(hPieComponentHandles(i*2-1), 'FaceColor', pieColorMap);
    set(hPieComponentHandles(i*2), 'FontSize', 16);
    set(hPieComponentHandles(i*2), 'String', strcat(labels_rsn{i},': ',num2str(round(val(i)*100)),'%'), 'FontSize', 16);
    disp([labels_rsn{i} ' - ' strcat(num2str(round(val(i)*100)))]);
end
set(gcf,'color','w');

