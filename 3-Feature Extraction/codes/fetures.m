clc; clear
cd('E:\00-毕业论文\3-特征提取')
addpath('..\2-平滑消噪')
load('experiment_data.mat')
addpath(genpath(pwd))
%% 数据切片
% 时间分割
deltaT = input('请定义数据切片时间间隔（s）');
for i = 1:length(FL)
    time{i}(:,1) = ( FL{i}(1,1)*60 : deltaT : FL{i}(length(FL{i}),1)*60-deltaT );
    time{i}(:,2) = ( FL{i}(1,1)*60+deltaT : deltaT : FL{i}(length(FL{i}),1)*60 );
end
disp('时间分割完毕~')
% 特征提取
for i = 1:length(FL)
    for j = 1:length(time{i})
        eda_slize = eda{i}(eda{i}(:,1)>time{i}(j,1) & eda{i}(:,1)<=time{i}(j,2),:);
        if isempty(eda_slize)
            eda_slize = eda_temp;
        end
        fuzzy =  Entropy_Fuzzy(eda_slize(:,2)');
        wavelet = Entropy_WaveletLog(eda_slize(:,2)','db2', 2);
        
        ppg_slize = ppg{i}(ppg{i}(:,1)>time{i}(j,1) & ppg{i}(:,1)<=time{i}(j,2),:);
        if isempty(ppg_slize)
            ppg_slize = ppg_temp;
        end
        
        hrv_slize = HRV{i}(HRV{i}(:,1)>time{i}(j,1) & HRV{i}(:,1)<=time{i}(j,2),:);
        if isempty(hrv_slize)
            hrv_slize = hrv_temp;
        end
        [sr,vr,svr] = hrv(64,hrv_slize,4096);
        
        resp_slize = resp{i}(resp{i}(:,1)>time{i}(j,1) & resp{i}(:,1)<=time{i}(j,2),:);
        if isempty(resp_slize)
            resp_slize = resp_temp;
        end
        number{i}(j,1) = i;
        info{i}(j,:) = personal_information(i,:);
        features{i}(j,:) = [ mean(eda_slize(:,2)) std(eda_slize(:,2)) ,...
                             fuzzy wavelet ,...
                             mean(ppg_slize(:,3)) std(ppg_slize(:,3)) mean(ppg_slize(:,4)) std(ppg_slize(:,4)) ,...
                             sr vr svr ,...
                             mean(resp_slize(:,3)) std(resp_slize(:,3)) mean(resp_slize(:,4)) std(resp_slize(:,4)) ];
        disp(['第' num2str(i) '个人的第' num2str(j) '段弄好啦'])
    end
    
    eda_temp = eda_slize;
    ppg_temp = ppg_slize;
    hrv_temp = hrv_slize;
    resp_temp = resp_slize;
end
clear eda_slize hrv_slize ppg_slize resp_slize sr svr vr
%% 疲劳等级特征
for i = 1:length(FL)
    m=[];
    for j = 1:( length(FL{i})-1 )
        m(j,1) = mean( FL{i}(j:j+1) );
    end
    fl{i} = [FL{i}(1,1) ; m ; FL{i}(length(FL{i}),1)];
    fl{i}(2:length(fl{i}),2) = FL{i}(:,2);
end

for i = 1:length(fl)
    fl_features{i} = [];
    for j = 2:length(fl{i})
        fatigue_level_temp = [];
        fatigue_level_temp(1:((fl{i}(j,1)-fl{i}(j-1,1))*60/deltaT),1 )=fl{i}(j,2);
        fl_features{i} = [fl_features{i}; fatigue_level_temp];
    end
end

for i = 1:length(fl)
    number{i}(isnan(fl_features{i}),:) = [];
    features{i}(isnan(fl_features{i}),:) = [];
    info{i}(isnan(fl_features{i}),:) = [];
    fl_features{i}(isnan(fl_features{i}),:) = [];
end

clear i j m time deltaT fatigue_level_temp fl FL fuzzy wavelet
PhysioDat = struct('eda',eda,'ppg',ppg,'hrv',HRV,'resp',resp);
clear eda HRV ppg resp eda_temp ppg_temp hrv_temp resp_temp

save('features.mat')