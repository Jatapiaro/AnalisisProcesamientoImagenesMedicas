I = imread('chest_xray.tif');
subplot(2,2,1), imshow(I);
subplot(2,2,2), imhist(I);
subplot(2,2,3), histeq(I);
subplot(2,2,4), imhist(histeq(I));