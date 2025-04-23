clc
clear
cd('E:\00-毕业论文\2-平滑消噪')

addpath('..\1-readfiles');
load('PhysioDat.mat')

addpath(genpath(pwd))
%% 计算【心率】、【脉搏信号幅值】、【呼吸周期】、【呼吸信号幅值】
for i = 1:length(EDA)
    [HR{i},PPG_F{i}] = PPGprocess(PPG{i}(:,2),PPG{i}(:,1));
    temp_ppg{i} = [PPG{i} HR{i} PPG_F{i}];
    [RESP_T{i},RESP_F{i}] = RESPprocess(RESP{i}(:,2),RESP{i}(:,1));
    temp_resp{i} = [RESP{i} RESP_T{i} RESP_F{i}];
end
disp('生理信号计算完毕')
%% 读取【实验时间】及【疲劳等级】
FL_NAMES = dir('.\time_series&FL\FL*.csv');
for i = 1:length(FL_NAMES)
    FL{i} = readmatrix(FL_NAMES(i,1).name);
end
disp('疲劳等级读取完毕')
%% 截取实验数据
for i = 1:length(FL)
    eda{i} = EDA{i}( EDA{i}(:,1)>FL{i}(1,1)*60 & EDA{i}(:,1)<=FL{i}(length(FL{i}),1)*60,: );
    ppg{i} = temp_ppg{i}( temp_ppg{i}(:,1)>FL{i}(1,1)*60 & temp_ppg{i}(:,1)<=FL{i}(length(FL{i}),1)*60,: );
    HRV{i} = PPG_PROCESS{i}( PPG_PROCESS{i}(:,1)>FL{i}(1,1)*60 & PPG_PROCESS{i}(:,1)<=FL{i}(length(FL{i}),1)*60,: );
    resp{i} = temp_resp{i}( temp_resp{i}(:,1)>FL{i}(1,1)*60 & temp_resp{i}(:,1)<=FL{i}(length(FL{i}),1)*60,: );
end
disp('实验数据截取完毕')
%% 收尾
clear EDA FL_NAMES HR i PPG PPG_F PPG_PROCESS RESP RESP_F RESP_T temp_ppg temp_resp
save('experiment_data.mat')