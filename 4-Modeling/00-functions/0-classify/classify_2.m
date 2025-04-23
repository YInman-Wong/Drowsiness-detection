function [y] = classify_2(a)
% a y 都是列向量
for k = 1:length(a)
    if a(k,1) < 5.5
        y(k,1) = 1;
    end
    if a(k,1) >= 5.5
        y(k,1) = 2;
    end
end