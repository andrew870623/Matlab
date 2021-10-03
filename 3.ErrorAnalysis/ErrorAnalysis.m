clc;clear;close all;
[x,fs] = audioread('speech.au');
x = double(x);

%Quantization and Calculate Error Value
b = [7,4,2,1];
for i=1:4
    n = 2^b(i);
    Y=Uquant(x,n);
    subplot(2,2,i);
    E=Y-x;%計算error
    hist(E,20);
    title(sprintf('%d bits/sample error quantization', b(i)));
end

orient tall;
print -dpdf ErrorAnalysis;
saveas(gcf,'ErrorAnalysis.png');

%Matlab function
function Y=Uquant(X,N)
delta=(max(max(X))-min(min(X)))/(N-1);
r = (X-min(min(X))) ./ delta ;
r=round(r);
Y=r.*delta+min(min(X));
end