%% LlodysFunc.m
clc;clear;close all;
[x,fs] = audioread('speech.au');
x = double(x);
hist(x,40);%plot a 40-bin histogram
title('Original histogram');
saveas(gcf,'Original histogram','jpg');%存圖

b = [7,4,2,1];
for i=1:4
    n = 2^b(i);
    [codebook, partition] = lloyds(x,n);    
    [indx, quant] = quantiz(x, codebook, partition);
    Y = transpose(quant);
    
    %Histogram after lloyds max-quantization
    figure(2);
    subplot(2,2,i);
    hist(Y,40);
    title(sprintf('%d bits/sample lloyds max-quantization', b(i)));
    saveas(gcf,'Lloyds Max Quantization','jpg');%存圖
    
    %error signal of lloyds comparison
    figure(3);
    E = Y-x;
    subplot(2,2,i);
    plot(Y,'b');
    hold on;
    Y1=Uquant(x,n);
    subplot(2,2,i);
    plot(Y1,'r');
    axis([7201,7400,-1,1]);
    title(sprintf('%d bits/sample', b(i)));
    saveas(gcf,'Error Signal of Lloyds Comparison','jpg');%存圖
   
    %error analysis of histogram using lloyds
    figure(4);
    subplot(2,2,i);
    E=Y-x;
    hist(E,40);
    title(sprintf('%d bits/sample error lloyds max-quantization', b(i)));
    saveas(gcf,'Error Lloyds Max Quantization','jpg');%存圖
    %PSNR
    Py=mean(Y.^2);
    Pe=mean(E.^2);
    psnr=Psnr(Py,Pe)
    psnr(i)=psnr;
    distortion(i)=1/psnr(i);
    bitsrate(i)=b(i)*fs/1000; %kbps
    
    

end

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
    distortion1(i)=1/psnr(i);
    fprintf('The 1/psnr value is %f.\n', distortion1(i));
    bitsrate1(i)=b(i)*fs/1000; %kbps
    
end

figure(5);
plot(bitsrate,distortion);
hold on;
plot(bitsrate1,distortion1,'r');
title('Rate Distortion Curve Comparison');
xlabel('Bit Rate (kbits/sec)');
ylabel('Distortion (1/PSNR)');
saveas(gcf,'RateDistortionCurveComparison','jpg');%存圖

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