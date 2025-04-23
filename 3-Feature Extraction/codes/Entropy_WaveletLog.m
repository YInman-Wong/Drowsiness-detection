function WaveletEn = Entropy_WaveletLog(sequence, waveletName, NumL)
%% input
%% sequence是向量，waveletName是使用的小波名字，如'db2'，NumL是分解的层数
%%
    En = [];
    [C, L] = wavedec(sequence, NumL, waveletName);%多尺度一维小波分解     

    approx = appcoef(C, L, waveletName, NumL);%低频信号系数
    En = [En wentropy(approx, 'log energy')];
    for i = NumL:-1:1
        detail = detcoef(C, L, i);%高频信号系数
        En = [En wentropy(detail, 'log energy')];
    end           

    WaveletEn = En;
end