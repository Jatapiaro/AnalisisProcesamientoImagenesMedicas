load imagen.mat
for i = 1:22, subplot(6,4,i), imshow(I(:,:,i)), end;

%Arreglo con los indicies de las imágenes
%que se va a verificar
imagenesMaximos = [3,4,7,8,11,14,15,18,19];
areas = zeros(1,22);

for i = 1:1:length(imagenesMaximos)
    
    Io = I(:,:,imagenesMaximos(i));

    SE = strel('disk', 31);
    Id = imclose(Io,SE);
    %figure, imshow(Id);
    Ie = imerode(Io, SE);
    %figure, imshow(Ie);
    Ig = imsubtract(Id, Ie);
    %figure, imshow(Ig);
    Igbw = im2bw(Ig, 30/255);
    %figure, imshow(Igbw);

    noBorderImage = imclearborder(not(Igbw));
    %figure, imshow(noBorderImage);

    area = bwarea(noBorderImage);
    
    %{
    % agregamos al arreglo
    % el resultado del area
    % tomemos en cuenta que necesitamos el indice 
    % de la imagen, por lo tanto hacemos imagenesMaximos(i)
    %}
    areas(imagenesMaximos(i)) = area;

    nuevaImagen = cat(3,uint8(255 * Igbw),uint8(0 * Igbw),uint8(0 * Igbw));
    %figure, imshow(imfuse(nuevaImagen, Io, 'blend', 'Scaling', 'joint'));
    
    f = figure;
    p = uipanel('Parent', f, 'BorderType', 'none');
    p.Title = strcat('Figura de la imagen   ', num2str(imagenesMaximos(i)) ,' del video original');
    p.TitlePosition = 'centertop';
    p.FontSize = 12;
    p.FontWeight = 'bold';
    subplot(2,2,1,'Parent',p), imshow(Io);
    title('Imagen original');
    subplot(2,2,2,'Parent',p), imshow(Igbw);
    title('Imagen binaria del borde de la válvula');
    subplot(2,2,3,'Parent',p), imshow(noBorderImage);
    title('Area valvular efectiva');
    subplot(2,2,4,'Parent',p), imshow(imfuse(nuevaImagen, Io, 'blend', 'Scaling', 'joint'));
    title('Imagen original superpuesta con borde rojo');
end

figure, plot(areas);

