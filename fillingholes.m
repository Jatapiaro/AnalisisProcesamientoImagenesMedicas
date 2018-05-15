A = ones(50);
figure, imshow(A);
Xo = zeroes(size(A));
Xo(18,16) = 1;
figure, imshow(Xo);
hold on, figure, imshow(A);
hold on, figure, imshow(Xo);

B = [0 1 0; 1 1 1; 0 1 0];

for i = 1: 10
    Xo = A;
    X = (imdilate(Xo,B) && not(A));
    imshow(X)
end