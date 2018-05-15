I = imread('lena.tiff');

plot(I(256, : , 1));

Ibw = im2bw(I);

SE = strel('disk',5);

figure, imshow(imopen(Ibw, SE));

figure, imshow(IBw);
