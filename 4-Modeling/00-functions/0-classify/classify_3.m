function [y] = classify_3(a)
% a y 都是列向量
for k = 1:length(a)
    if a(k,1) < 5.5
        y(k,1) = 1;
    end
    if a(k,1) >= 5.5 && a(k,1) < 7.5
        y(k,1) = 2;
    end
    if a(k,1) >= 7.5
        y(k,1) = 3;
    end
end