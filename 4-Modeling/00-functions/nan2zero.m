function a = nan2zero(b)

b(isnan(b)) = 0;
a = b;