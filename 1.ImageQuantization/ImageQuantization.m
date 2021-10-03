y = imread('fountainbw.tif');
image(y);
colormap(gray(256));%灰階化
axis('image');%兩軸刻度比例一致
z=double(y);%將圖片改成double型態
folder = './';
b=[7,4,2,1]
for i=1:4
    n = 2^b(i);
    Q=Uquant(y,n);
    figure(i+1);
    Pic(i) = imshow(Q);
    title(sprintf('%d b/pel', b(i)));
    imwrite(Q,fullfile(folder,sprintf('%d_b_pel_image_quantization', b(i))+".jpg"))%%將圖片輸出
end 
%%Matlab function
function Y=Uquant(X,N)
    delta=(max(max(X))-min(min(X)))/(N-1);
    r = (X-min(min(X))) ./ delta ;
    r=round(r);
    Y=r.*delta+min(min(X));
end