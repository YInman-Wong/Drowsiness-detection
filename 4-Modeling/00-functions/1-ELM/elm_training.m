function [TrainingAccuracy,TestingAccuracy,performance_time] = elm_training(X,T,test_ratio)
[Xsampledata, Xgroup, Csampledata, Cgroup] = subset(X,T,test_ratio);
[TrainingAccuracy,TestingAccuracy, performance_time] = elm(Xsampledata, Xgroup, Csampledata, Cgroup,1,30,'sig');