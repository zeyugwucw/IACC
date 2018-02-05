function  [ n v ] = my_hist( I )
n = 0:255;
v = zeros(1,256);
[l w] = size(I);
for i = 1:l
    for j = 1:w
        v(I(i,j)+1) = v(I(i,j)+1) + 1;
    end
end

figure, bar(n,v,1);

end

