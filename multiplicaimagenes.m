%Aumentas o diminuyes el brillo de la imagen 
% al multiplicarla
clc;
I3 = imread('cameraman.tif');
imshow(I3);
figure, imshow(immultiply(I3,0.25));