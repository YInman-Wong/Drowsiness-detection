clear
cd('E:\00-毕业论文')
addpath(genpath(pwd))
load('features.mat')

p = [];
f = [];
num = [];
i = [];
for j = 1:35
    p = [p; mapminmax(features{j}')'];
    f = [f; classify_3(fl_features{j})];
    num = [num; number{j}];
    i = [i; info{j}];
end

clearvars -except p f i num

save('.\4-模型搭建\modeling.mat')