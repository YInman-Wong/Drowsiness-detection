function WaveletEn = Entropy_WaveletLog(sequence, waveletName, NumL)
%% input
%% sequence��������waveletName��ʹ�õ�С�����֣���'db2'��NumL�Ƿֽ�Ĳ���
%%
    En = [];
    [C, L] = wavedec(sequence, NumL, waveletName);%��߶�һάС���ֽ�     

    approx = appcoef(C, L, waveletName, NumL);%��Ƶ�ź�ϵ��
    En = [En wentropy(approx, 'log energy')];
    for i = NumL:-1:1
        detail = detcoef(C, L, i);%��Ƶ�ź�ϵ��
        En = [En wentropy(detail, 'log energy')];
    end           

    WaveletEn = En;
end