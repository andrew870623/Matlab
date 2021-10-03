clc;clear;close all;
[x,fs] = audioread('speech.au');
x = double(x);


%Quantization(量化)
b = [7,4,2,1];
for i=1:4
    n = 2^b(i);
    Y=Uquant(x,n);
    subplot(2,2,i);%分成四個小圖
    plot(Y);
    axis([7201,7400,-1,1]);%range
    title(sprintf('%d bits/sample quantization of speech.au', b(i)));
    playblocking(audioplayer(Y,fs));
end

orient tall;
print -dpdf SpeechQuantization
saveas(gcf,'speechout.png');
%play speech
%playblocking(audioplayer(Uquant(x,2^7),fs));
%playblocking(audioplayer(Uquant(x,2^4),fs));
%playblocking(audioplayer(Uquant(x,2^2),fs));
%playblocking(audioplayer(Uquant(x,2^1),fs));

%Matlab function
function Y=Uquant(X,N)
delta=(max(max(X))-min(min(X)))/(N-1);
r = (X-min(min(X))) ./ delta ;
r=round(r);
Y=r.*delta+min(min(X));
end