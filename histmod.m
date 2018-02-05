function [ new_I ] = histmod( I, I_mod )

[ n v ] = my_hist(I_mod);
cumu = 0;
[ l w ] = size(I);
[ l_m w_m ] = size(I_mod);
new_I = zeros(l,w);
pdf = v ./ (l_m*w_m);
cpf = zeros(1,256);
for i = 1:256
    cumu = cumu + pdf(i);
    cpf(i) = cumu;
end

tr = round(cpf.*255);
for i = 1:l
    for j = 1:w
        new_I(i,j) = tr(I(i,j)+1);
    end
end
end

