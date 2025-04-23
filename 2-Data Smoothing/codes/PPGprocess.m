function [HEART_RATE,PPG_F] = PPGprocess(a,t)
%% Coments
% [HEART_RATE,PPG_F] = PPGprocess(a,t)
% 【输出】
% - HEART_RATE: 心率
% - PPG-F: 脉搏信号幅值
% 【输入】
% - t: 原始PPG信号时间序列
% - a: 原始PPG信号
%% Example
% clc
% clear
% addpath('G:\基于生理数据的疲劳驾驶识别\1-数据导入与实验数据提取')
% load('E:\newsamples\1-数据导入\PhysioDat.mat')
% i = 8;
% a = PPG{i}(:,2);
% t = PPG{i}(:,1);
%% 原始信号通过滤波器
[Bb,Ba] = butter(2,0.2); 
a = filter(Bb,Ba,a);
%% 找滤波信号极值点
[PKS,LOCS] = findpeaks(a,64, 'MinPeakDistance',0.5,'MinPeakProminence',2);% 'MinPeakDistance'、'MinPeakHeight'、'MinPeakProminence'
deltaT([1:length(LOCS)],1) = t(1,1);
LOCS = LOCS + deltaT;
% 顺便画个图
figure;
plot(t,a);
hold on;
plot(LOCS,PKS,'.','color','r');
%% 算周期 和 每次心跳的开始时间以及结束时间
for i = 2:length(LOCS)
    HR(i,1) = 60/(LOCS(i,1)-LOCS(i-1,1));
    time(i,1) = LOCS(i-1,1);% 心跳开始时间
    time(i,2) = LOCS(i,1);% 心跳结束时间
end
%% 算幅值
for i = 2:length(PKS)
    BRT = a( t>=time(i,1) & t<time(i,2));
    T = t( t>=time(i,1) & t<time(i,2));
    [LPKS(i,1) b] = min(BRT);
    LLOCS(i,1) = T(b);
end
hold on
plot(LLOCS,LPKS,'.','color','r');

F = PKS - LPKS;
%% 周期扩样
for i = 1:length(time)
    for j = 1:length(t)
        if t(j,1)>=time(i,1) && t(j,1)<time(i,2)
            HEART_RATE(j,1) = HR(i,1);
            PPG_F(j,1) = F(i,1);
        end
    end
end
HEART_RATE((length(HEART_RATE)+1:length(t)),:) = 0;
PPG_F((length(PPG_F)+1:length(t)),:) = 0;