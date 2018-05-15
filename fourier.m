I = imread('cameraman.tif');
figure, imshow(I, []);
S = fft2(I);
S = log(abs(S)+1);
figure, imshow(S,[]);
colorbar

S = fftshift(S);
figure, imshow(S,[]);

%H = roipoly;

figure, imshow(H, []);

G = S .* double(H);

figure, imshow(G, []);

G = exp(G);

G = ifftshift(G);
%figure, imshow(G, []);

If = real(ifft2(G));

imshow(If,[]);
