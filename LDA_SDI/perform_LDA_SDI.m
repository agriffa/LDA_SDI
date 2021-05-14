%% LDA
%%
% Number of parameter and number of classes
np = size(X_LDA,2);
nc = length(unique(Y_LDA));
ns = length(find(Y_LDA==1));%number of samples per class - OK if classes of same size
% Mean by class
MBC = splitapply(@mean,X_LDA,Y_LDA);
% Compute the Within class Scatter Matrix WSM
WSM = zeros(np);
for ii = 1:nc
    FM = X_LDA(Y_LDA==ii,:)-MBC(ii,:);
    WSM = WSM + FM.'*FM;
end
% Compute the Between class Scatter Matrix
BSM = zeros(np);
GPC = accumarray(Y_LDA,ones(size(Y_LDA)));
for ii = 1:nc
    BSM = BSM + GPC(ii)*((MBC(ii,:)-mean(X_LDA)).'*(MBC(ii,:)-mean(X_LDA)));
end

% Now we compute the eigenvalues and the eigenvectors (eigenvecs will be
% the coefficients of the linear combination to build new features, i.e.,
% the linear discriminants (components))
[eig_vec,eig_val] = eig(inv(WSM)*BSM);
eig_val=diag(real(eig_val));

% Sort eigenvectors
[eig_val, ii] = sort(eig_val, 'descend');
eig_vec = eig_vec(:,ii);

%eigenvectors weighted for the eigenval to show relative importance of each
%old feature in the discrimination
Weig_vec=eig_vec(:,1:nc-1)*(eig_val(1:nc-1)); 

% Compute the new features:
newX_LDA = X_LDA*eig_vec(:,1:nc-1);

%% lDA visualizations
if LDA_task
    % %% Show data in linear discriminants space (meaningful for task-LDA)
    figure;
    for i=1:nc
        plot(newX_LDA(Y_LDA==i,1),newX_LDA(Y_LDA==i,2),'.');hold on;end
    xlabel('LD1');
    ylabel('LD2');
    figure;
    for i=1:nc
        plot(newX_LDA(Y_LDA==i,3),newX_LDA(Y_LDA==i,4),'.');hold on;end
    xlabel('LD3');
    ylabel('LD4');
    figure;
    for i=1:nc
        plot(newX_LDA(Y_LDA==i,5),newX_LDA(Y_LDA==i,6),'.');hold on;end
    xlabel('LD5');
    ylabel('LD6');
end


