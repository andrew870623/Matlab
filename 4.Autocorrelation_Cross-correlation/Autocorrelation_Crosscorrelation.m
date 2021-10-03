%ErrorCorrelation
clc;clear;close all;
[x] = audioread('speech.au');
x = double(x);

%Quantization and Calculate Autocorrelation & Cross-correlation
b = [7,4,2,1];
for i=1:4
    n = 2^b(i);
    Y=Uquant(x,n);
    E=Y-x;%error
    
    figure(1);%Autocorrelation
    subplot(2,2,i);
    [r,lags]=xcorr(E,200,'unbiased');
    plot(lags,r);
    title(sprintf('%d b/sample autocorrelation', b(i)));
    saveas(gcf,'Autocorrelation','jpg');%存圖
    
    figure(2);%Cross-correlation
    subplot(2,2,i);
    [c,lags]=xcorr(E,Y,200,'unbiased');
    plot(lags,c);
    title(sprintf('%d b/sample cross-correlation', b(i)));
    saveas(gcf,'Cross-correlation','jpg');%存圖
end
%Matlab function
function Y=Uquant(X,N)
delta=(max(max(X))-min(min(X)))/(N-1);
r = (X-min(min(X))) ./ delta ;
r=round(r);
Y=r.*delta+min(min(X));
end