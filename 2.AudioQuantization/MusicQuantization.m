clc;clear;close all;
[x,fs] = audioread('music.au');
x = double(x);
folder = './';

%Quantization(量化)
b = [7,4,2,1];
for i=1:4
    n = 2^b(i);
    Y=Uquant(x,n);
    subplot(2,2,i);%Use subplot to plot in the same figure, the four quantized speech signals over the index range 7201:7400.
    plot(Y);
    axis([7201,7400,-1,1]);
    title(sprintf('%d bits/sample quantization of music.au', b(i)));
    playblocking(audioplayer(Y,fs));
end

orient tall;
print -dpdf MusicQuantization
saveas(gcf,'musicout.png');
%play music
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