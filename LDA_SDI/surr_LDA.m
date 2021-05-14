%% create surrogate null distribution for task-specific classification maps 

for i_surr=1:nSurr
   
    Y_LDA=Y_LDA(randperm(size(Y_LDA,1)));    % permutation of original LDA labels
    perform_LDA_SDI
    
    %% compute *TASK-specific* classification maps from LDA weights  & BAR PLOTS
    %%OUTPUT--> Weights, where each column relates to a task-condition (REST, EMO, GAM, LAN, MOT, REL, SOC, WM)
    compute_task_maps;
    Weights_surr(:,:,i_surr)=Weights;
    
end
clear Weights 