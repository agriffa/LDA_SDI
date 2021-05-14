switch LDA_task
    case 1
        %% CLASSIFICATION OF TASK
        %%LDA with manual cv - exclude one entire subject each time (100foldCV)
        clear pred_class
        DATAMAT=SDIs;
        for i=1:100 % for each subject
            test_index=[];
            for n=1:16 %test all sequences for that subject (8 tasks x2)
                test_index=[test_index,i+((n-1)*100)];
            end
            train_index=setdiff(1:size(DATAMAT,2),test_index);
            train=DATAMAT(:,train_index)';
            group_train=GROUP(train_index);
            test=DATAMAT(:,test_index)';
            Mdlcv=fitcdiscr(train,group_train);
            pred_class(:,i)=predict(Mdlcv,test);
            num_errors(i)=size(nonzeros(GROUP(test_index)-pred_class(:,i)),1);
        end
        Acc=1-(sum(num_errors)./size(DATAMAT,2)) 
       
    case 0
        %% CLASSIFICATION OF SUBJECT
        
        switch test_type
            case 1 
                %800foldCV to exclude one subject's task: leave-one-subject-out CV
                clear pred_class num_errors
                n=1;
                DATAMAT=newSDIs;
                LABELS=newGROUP;
                for i=1:2:size(DATAMAT,2)
                    test_index=[i,i+1];
                    train_index=setdiff(1:size(DATAMAT,2),test_index);
                    train=DATAMAT(:,train_index)';
                    group_train=LABELS(train_index);
                    test=DATAMAT(:,test_index)';
                    Mdlcv=fitcdiscr(train,group_train);
                    pred_class(:,n)=predict(Mdlcv,test);
                    num_errors(n)=size(nonzeros(LABELS(test_index)-pred_class(:,n)),1);
                    n=n+1;
                end
                Acc=1-(sum(num_errors)./1600) %1
                
       
            case 2 %8 fold CV: leave-one-task-out CV
                
                DATAMAT=SDIs;
                LABELS=GROUP;
                for t=1:8%for each task
                    clear pred_class num_errors
                    test_index=[1+(t-1)*200:200+(t-1)*200];
                    train_index=setdiff(1:size(DATAMAT,2),test_index);%all tasks
                    train=DATAMAT(:,train_index)';
                    group_train=LABELS(train_index);
                    test=DATAMAT(:,test_index)';
                    Mdlcv=fitcdiscr(train,group_train);
                    pred_class=predict(Mdlcv,test);
                    num_errors=size(nonzeros(LABELS(test_index)-pred_class),1);
                    Acc(t)=1-(sum(num_errors)./size(test_index,2)) %1, 0.885 with different cutoffs
                end
                Acc_final=mean(Acc)
            
            case 3 %TRAIN on one task at a time, TEST on one task at a time
                DATAMAT=SDIs;
                LABELS=GROUP;
                clear Acc
                for t1=1:8%for each task
                    for t2=setdiff(1:8,t1)
                        clear pred_class num_errors
                        train_index=[1+(t1-1)*200:200+(t1-1)*200];
                        test_index=[1+(t2-1)*200:200+(t2-1)*200];%all tasks
                        train=DATAMAT(:,train_index)';
                        group_train=LABELS(train_index);
                        test=DATAMAT(:,test_index)';
                        Mdlcv=fitcdiscr(train,group_train);
                        pred_class=predict(Mdlcv,test);
                        num_errors=size(nonzeros(LABELS(test_index)-pred_class),1);
                        Acc(t1,t2)=1-(sum(num_errors)./size(test_index,2))
                    end
                end
                
                        
        end  
end