function [TrainingAccuracy,TestingAccuracy,performance_time] = pca_elm_training(X,T,test_ratio,precisious)
[coeff,score,latent] = pca(X');%我们这里需要他的pc和latent值做分析
s = cumsum(latent)./sum(latent);
s = s(s<=precisious); %精度取0.9
score = score(:,1:(length(s)+1));% score是降维旋转后矩阵

[Xsampledata, Xgroup, Csampledata, Cgroup] = subset(score,T,test_ratio);
[TrainingAccuracy,TestingAccuracy, performance_time] = elm(Xsampledata, Xgroup, Csampledata, Cgroup,1,17,'sig');

