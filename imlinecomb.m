I1 = imread('toycars.png');
I2 = imread('toycars.png');

imshow(I1);
imshow(I2);

figure, imshow(imlinecomb(.5,I1,.5,I2))