function [sr,vr,svr] = hrv(Fs,xn,nfft)
%% 输出
% sr = s_lf / (s_vlf + s_lf + s_hf);
% vr = s_hf / (s_vlf + s_lf + s_hf);
% svr = s_lf / s_hf;
%% 输入
% - Fs: 采样频率
% - xn：原始脉搏信号
% - nfft: DFT运算点数，为正整数。对于实输入信号x的PSD评估，
%         若nfft为偶，则pxx=(nfft/2+1)；
%         若nfft为奇，则pxx=(nfft+1)2。对于复输入信号x的PSD评估，pxx的长度总是nfft。
%         若nfft为空，则使用默认值。
%         数据类型：单、双精度。

window=boxcar(length(xn)); % 矩形窗
[Pxx,f]=periodogram(xn,window,nfft,Fs); % 直接法

figure;
subplot(2,1,1);
plot(xn);
subplot(2,1,2);
plot(f(f<0.4),Pxx(f<0.4));
% 
% inty=cumtrapz(f,Pxx);%梯形近似
% S = trapz(f,Pxx);

s_vlf = power_trapz(Pxx(f>0 & f<=0.04),f(f>0 & f<=0.04));
s_lf = power_trapz(Pxx(f>0 & f<=0.15),f(f>0 & f<=0.15)) - s_vlf;
s_hf = power_trapz(Pxx(f>0 & f<=0.4),f(f>0 & f<=0.4)) - power_trapz(Pxx(f>0 & f<=0.15),f(f>0 & f<=0.15));

sr = s_lf/(s_vlf+s_lf+s_hf);
vr = s_hf/(s_vlf+s_lf+s_hf);
svr = s_lf/s_hf;