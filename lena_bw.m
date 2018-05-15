I = imread('/Users/jacobotapia/Desktop/lena.tiff');

plot(I(256, : , 1));

BW = im2bw(I);

%imshow(im2bw(I,50/255), []);

%imshow(I(:,:,1)', [])
