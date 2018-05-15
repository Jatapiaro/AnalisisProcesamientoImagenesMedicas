I1 = imread('chest_xray.tif');
I2 = imread('tijeras.jpg');
I4 = rgb2gray(imread('lena.tiff'));

subplot(3,2,1), imshow(I1);
subplot(3,2,2), imhist(I1);
subplot(3,2,3), imshow(I2);
subplot(3,2,4), imhist(I2);


[y,x] = imhist(I4);

%figure, plot(x,y);

I3 = histeq(I1,y);

subplot(3,2,5), imshow(I3);
subplot(3,2,6), imhist(I3);
subplot(3,2,5), imshow(I3);
subplot(3,2,6), imhist(I3);
