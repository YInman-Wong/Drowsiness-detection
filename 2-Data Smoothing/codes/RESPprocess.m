function [RESP_T,RESP_F] = RESPprocess(a,t)
%% Coments
% [RESP_T,RESP_F] = RESPprocess(a,t)
% 【输出】
% - RESP_T: 呼吸信号周期
% - RESP_F: 呼吸信号幅值
% 【输入】
% - a : 原始呼吸信号
% - t ：原始呼吸信号时间线
%% Exanple:
% clear
% load('E:\newsamples\1-数据导入\PhysioDat.mat')
% i = 1;
% a = RESP{i}(:,2);
% t = RESP{i}(:,1);
%% 原始信号通过滤波器
[Bb,Ba] = butter(2,0.01); 
a = filter(Bb,Ba,a);
%% 找滤波信号极值点
[PKS,LOCS] = findpeaks(a,64,'MinPeakDistance',2.7,'MinPeakHeight',63);%
deltaT([1:length(LOCS)],1) = t(1,1);
LOCS = LOCS + deltaT;
% 顺便画个图
% figure;
% plot(t,a);
% hold on;
% plot(LOCS,PKS,'.','color','r');
%% 算周期 和 每次呼吸的开始时间以及结束时间
for i = 2:length(LOCS)
    T(i,1) = LOCS(i,1)-LOCS(i-1,1);
    time(i,1) = LOCS(i-1,1);% 呼吸开始时间
    time(i,2) = LOCS(i,1);% 呼吸结束时间
end
%% 算幅值
for i = 2:length(PKS)
    BRT = a( t>time(i,1) & t<= time(i,2));
    LPKS(i,1) = min(BRT);
end
F = PKS - LPKS;
%% 周期幅值扩样
for i = 1:length(time)
    for j = 1:length(t)
        if t(j,1)>=time(i,1) && t(j,1)<time(i,2)
            RESP_T(j,1) = T(i,1);
            RESP_F(j,1) = F(i,1);
        end
    end
end
RESP_T(length(RESP_T)+1:length(t),:) = 0;
RESP_F(length(RESP_F)+1:length(t),:) = 0;