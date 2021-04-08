%% Data loading for LDA

%% CASE 1 : LDA to classify tasks
if LDA_task
    if FCnodestrength %same classification but with FC ns
        SDIs=load(strcat(data_path,'/Final_FCns/FCns_TASK_CLASSIFICATION.mat'));
        SDIs=SDIs.FCns;
    else
        SDIs=load(strcat(data_path,'/Final_SDIs/SDIs_TASK_CLASSIFICATION.mat'));
        SDIs=SDIs.SDIs;
    end
    
    %%GROUP definition (task separation)
    GROUP=zeros(1600,1);
    for t=1:8%task
        GROUP(1+(200*(t-1)):200+(200*(t-1)),1)=t;
    end
else
    %% CASE 2 : LDA to classify subjects
    if FCnodestrength %same classification but with FC ns
        SDIs=load(strcat(data_path,'/Final_FCns/FCns_SUBJECT_CLASSIFICATION.mat'));
        SDIs=SDIs.FCns;
    else
        SDIs=load(strcat(data_path,'/Final_SDIs/SDIs_SUBJECT_CLASSIFICATION.mat'));
        SDIs=SDIs.SDIs;
    end
    
     %change order in the matrix (subject1...subject2....etc)
    newSDIs=[];
    for s=1:N_sub
        sbj_index=[];
        for n=1:16 %16 samples for each subject
            sbj_index=[sbj_index,s+((n-1)*100)];
        end
        newSDIs=[newSDIs,SDIs(:,sbj_index)];
    end
    
    %%GROUP definition (conventional order, goes with SDIs)
    GROUP=[1:100];
    for t=1:4
        GROUP=[GROUP,GROUP];
    end
    GROUP=GROUP';
    %%new GROUP definition (subject order, goes with newSDIs)
    newGROUP=[];
    for s=1:100
        newGROUP=[newGROUP;ones(16,1)*s];
    end
end
