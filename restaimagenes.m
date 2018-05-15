I1 = dicomread('IM-0001-0014.dcm');
I2 = imread('cola2.png');

subplot(1,2,1), imshow(I1, []);
%subplot(1,2,2), imshow(I2, []);

%figure, imshow(imsubtract(I1,I2));

%figure, imshow(imabsdiff(I1,I2));

%Ibw = im2bw(I1);
%imshow(Ibw);
%figure, imshow(imcomplement(Ibw));

