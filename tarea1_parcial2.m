I = dicomread('Cardio_RM.dcm');
I = squeeze(I);

f = figure;
p = uipanel('Parent', f, 'BorderType', 'none');
p.Title = strcat('Filtrado de bordes');
p.TitlePosition = 'centertop';
p.FontSize = 12;
p.FontWeight = 'bold';

for i=1:30
    I1 = im2double(I(:,:,i));
    
    %k = fspecial('average', [7 7]);
    k = fspecial('laplacian');
    
    If1 = imfilter(I1, k, 'same');
    

    subplot(1,2,1,'Parent',p), imshow(I1, []);
    title(strcat('Imagen original en el frame ',num2str(i)));
    subplot(1,2,2,'Parent',p), imshow(I1-If1, []);
    title(strcat('Imagen filtrada en el frame ',num2str(i)));
    pause(0.1);
end
