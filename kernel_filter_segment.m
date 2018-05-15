k = [0 1 0; 1-4 1; 0 1 0];
 
for i = 1:22, subplot (6,4,i), imshow(I(:,:,i)), end 
I18 = I(:,:,18);
imshow(I18,[]);
Im18f = imfilter(I18, k , 'same');
figure, imshow(Im18f,[]);