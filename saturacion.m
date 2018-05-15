Id = im2double(I);
Io = 4*log(1+Id);
figure, imshow(Io);

I4 = imread('tijeras.jpg');
I4 = im2double(I4);
Io2 = 1*(((1+0.5).^(I4))-1);
figure, imshow(Io2);