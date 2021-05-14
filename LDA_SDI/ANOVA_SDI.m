
%% INTERTASK VARIANCE (std across tasks, avg over sbjs)
for r=1:size(SDIs,1)
    data=[];
    for i=1:8
        data=[data;SDIs(r,1+200*(i-1):200+200*(i-1))];
    end
    std_task(r)=mean(std(data));%approx task main effect - approximation of F value computed later
    std_subject(r)=mean(std(data'));% %% it doesn't approx well F_S
end

%% Build GLM and F-test, with INTERACTION TASK*SUBJECT 
n_t=8;
n_s=100;
TASK=zeros(size(SDIs,2),1);
for t=1:n_t%task
    TASK(1+(200*(t-1)):200+(200*(t-1)),1)=t;
end
SUBJECT=[1:100]';
for t=1:4
    SUBJECT=[SUBJECT;SUBJECT];
end

TASK=categorical(TASK);%%NB - must be set to CATEGORICAL otherwise it doesn't consider them as separate regr. in the model
SUBJECT=categorical(SUBJECT);

for r=1:size(SDIs,1)
    Y=SDIs(r,:)';
    [p(:,r),anovatable{r}]= anovan(Y,{TASK SUBJECT},'model','interaction','varnames',{'TASK','SUBJECT'},'display','off');
end
for r=1:size(SDIs,1)
    F1(r)=anovatable{r}{2,6};% TASK EFFECT
    F2(r)=anovatable{r}{3,6};% SUBJECT EFFECT
    F3(r)=anovatable{r}{4,6};% INTERACTION EFFECT
end


%TASK EFFECT
F1sig=F1;
F1sig(p(1,:)>0.05/379)=0;
plot_surface_glasser(mypath,F1sig,othercolor('YlOrRd5'),8,180)


%SUBJECT EFFECT
F2sig=F2;
F2sig(p(2,:)>0.05/379)=0;
plot_surface_glasser(mypath,F2sig,othercolor('YlOrRd5'),8,22)

%INTERACTION EFFECT
F3sig=F3;
F3sig(p(3,:)>0.05/379)=0;


