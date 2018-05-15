I = dicomread('N1.dcm');
I = squeeze(I);

f = figure;
p = uipanel('Parent', f, 'BorderType', 'none');
p.Title = strcat('Filtrado de bordes');
p.TitlePosition = 'centertop';
p.FontSize = 12;
p.FontWeight = 'bold';

for i=1:16
    I1 = I(:,:,i);
    
    noiseReduction = medfilt2(I1); %filter2(fspecial('gaussian',2,10),I1)/255;
    
    sobeli = edge(noiseReduction,'sobel');
    sobeli2 = int16(sobeli);
    
    kernel = -1*ones(3);
    kernel(2,2) = 17;
    
    enhancedImage = imfilter(noiseReduction, kernel);
    

    subplot(1,2,1,'Parent',p), imshow(I1, []);
    title(strcat('Imagen original en el frame ',num2str(i)));
    subplot(1,2,2,'Parent',p), imshow(sobeli2+noiseReduction, []);
    title(strcat('Imagen filtrada en el frame ',num2str(i)));
    pause(0.1);
end

