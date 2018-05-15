I = imread('anio.jpeg');

Ibw = not(im2bw(rgb2gray(I)));
imshow(Ibw);

impixelinfo();

W = Ibw(210:(210+70), 590:(590+70));
figure, imshow(W);

W2 = ones(size(W));

W2mD = not(W);

figure, imshow(W2mD);

%%erosionar 

T1 = imerode(Ibw, W2);
figure, imshow(W2);

T2 = imerode(not(Ibw), W2mD);
figure, imshow(T2);
Tfinal = T1 & T2;
figure, imshow(Tfinal);

%%%%%



