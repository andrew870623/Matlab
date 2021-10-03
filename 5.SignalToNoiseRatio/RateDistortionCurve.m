%% DistortionCurve.m
clc;clear;close all;
[x,fs] = audioread('speech.au');
x = double(x);


%Calculate PSNR
b = [7,4,2,1]
for i=1:4
    n = 2^b(i);
    Y=Uquant(x,n);
    E=Y-x;%ERROR
    
    Py=mean(Y.^2);
    Pe=mean(E.^2);
    psnr=Psnr(Py,Pe)
    psnr(i)=psnr;
    distortion(i)=1/psnr(i);
    fprintf('The 1/psnr value is %f.\n', distortion(i));
    bitsrate(i)=b(i)*fs/1000; %kbps
    
end

plot(bitsrate,distortion,'o-');
title('Rate-Distortion Curve');
xlabel('Bit Rate (kbits/sec)');
ylabel('Distortion (1/PSNR)');
saveas(gcf,'RateDistortionCurve','jpg');%存圖


%Matlab function
function Y=Uquant(X,N)
delta=(max(max(X))-min(min(X)))/(N-1);
r = (X-min(min(X)))./ delta ;
r=round(r);
Y=r.*delta+min(min(X));
end

%PSNR function
function psnr=Psnr(Py,Pe)
psnr=Py/Pe;
fprintf('The PSNR value is %f.\n', psnr);
end