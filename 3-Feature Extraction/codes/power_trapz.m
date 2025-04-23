function [S_vlf] = power_trapz(Pxx,f)
%  [inty,S_vlf] = power_trapz(Pxx,f)

if length(f) > 1
%     inty = cumtrapz(f,Pxx);%梯形近似
    S_vlf = trapz(f,Pxx);
else
    S_vlf = 0;
end