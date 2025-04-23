clear
cd('E:\00-毕业论文')
addpath(genpath(pwd))
%% 识别文件名
EDA_NAMES = dir('.\1-readfiles\newdata\EDA1_Entire Recording_RawData*.csv');
PPG_NAMES = dir('.\1-readfiles\newdata\PPG1_Entire Recording_RawData*.csv');
PPG_PROCESS_NAMES = dir('.\1-readfiles\newdata\PPG1_Entire Recording_Processed*.csv');
RESP_NAMES = dir('.\1-readfiles\newdata\RESP1_Entire Recording_RawData*.csv');
%% 读取文件
for i = 1:length(EDA_NAMES)
    EDA{i} = readmatrix(EDA_NAMES(i,1).name);
    PPG{i} = readmatrix(PPG_NAMES(i,1).name);
    PPG_PROCESS{i} = readmatrix(PPG_PROCESS_NAMES(i,1).name);
    RESP{i} = readmatrix(RESP_NAMES(i,1).name);
end
clear EDA_NAMES PPG_NAMES RESP_NAMES i PPG_PROCESS_NAMES
save('.\1-readfiles\PhysioDat.mat')