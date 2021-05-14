

%% compute *TASK-specific* classification maps from LDA weights: fit a linear model for each task, with LDA scores as regressors, then use betas as weights for a linear combination of LDA eigenvectors
Y_T=zeros(1600,8);
for i=1:8
    Y_T((i-1)*200+1:(i-1)*200+200,i)=1;
end
for cond=1:8 % for each task condition, fit that condition and find coefficients
    tbl1 = table(Y_T(:,cond),newX_LDA(:,1),newX_LDA(:,2),newX_LDA(:,3),newX_LDA(:,4),newX_LDA(:,5),newX_LDA(:,6),newX_LDA(:,7));
    mdl1 = fitlm(tbl1,'Var1 ~ Var2 + Var3 + Var4 + Var5 + Var6 + Var7 + Var8'); % by default with constant
    coeffs(:,cond)=table2array(mdl1.Coefficients(:,1));
end

% goodness of fit evaluate
Y_est=[ones(1600,1),newX_LDA]*coeffs; %baseline first!

%sum of eigenvectors weighted by coefficients, for each condition
for cond=1:8 
Weights(:,cond)=eig_vec(:,1:nc-1)*(coeffs(2:8,cond)); 
end
