A = zeros(7,15);
A(2,2:5) = 1;
A(2,1:14) = 1;
A(6,2:5) = 1;
A(6,1:14) = 1;
A(3:5,2:14) = 1;
image(A);
imshow(A);
imagesc(A);

B = [0 1 0, 1 1 1, 0 1 0];

Ie = imerode(A,B);
imshow(Ie);