%{
% .dcm son imagenes en formato "médico"
% ponemos el nombre del folder donde se van a 
% jalar todas las imágenes del MRI
%}

mriFolder = fullfile(pwd, 'examen_2');

%{
% jalamos cada una de las imagenes 
% con terminación o extensión .dcm
%}
imagenes = dir(fullfile(mriFolder, '*.dcm'));

nombreImagenes = {imagenes.name};

%{
% una vez que tenemos estas direcciones
% guardemoslas en un arreglo
% sin embargo, debemos saber la cantidad de imagenes
%}
I = dicomread(fullfile(mriFolder, nombreImagenes{1}));
classI = class(I);
% almacenamos el tipo de dato que se usara

informacion = dicominfo(fullfile(mriFolder, nombreImagenes{1}));

sizeI = size(I);
totalImagenes = length(nombreImagenes);

%Reservemos la memoria necesaria para poder tener las imagenes

info = dicominfo(fullfile(mriFolder, nombreImagenes{1}));
estudioMRI = zeros(info.Rows,info.Columns, totalImagenes, classI);


%{
% verifiquemos que todas las imagenes estén ahi
% leyendolas
%}
for i = totalImagenes:-1:1
    nombreImagen = fullfile(mriFolder, nombreImagenes{i});
    imagen = dicomread(nombreImagen);
    estudioMRI(:,:,i) = uint16(imagen);
    
    h = waitbar((length(nombreImagenes)-i+1)/length(nombreImagenes));
    if (i == 1)
        close(h);
    end   
end

%{
% Volteamos el orden de las imagenes
% pues fueron introducidas al revés
% para poder ver el waitbar
%}

f = figure('units','normalized','outerposition',[0 0 1 1]);
p = uipanel('Parent', f, 'BorderType', 'none');
p.Title = strcat('Segmentación ventriculo izquierdo');
p.TitlePosition = 'centertop';
p.FontSize = 10;
p.FontWeight = 'bold';
p.FontName = 'Monospaced';
%{
% Debido a que insertamos las imagenes
% al revés para poder ver el waitbar
% leemos nuevamente de atrás hacia adelante
% creamos otra variable auxiliar que nos de el
% frame verdadero
%}
frame = 1;
for i = totalImagenes:-1:1
    
    delete(h);
    
    originalAtI = estudioMRI(:,:,i);
    subplot(2,6,1,'Parent',p), imshow(originalAtI,[]);
    title(strcat('Original #', int2str(frame)));
    
    %{
    %% Primero ajustamos la imagen para que los negros sean
    %% mas negros utilizando imadjust
    %% luego con histeq buscamos ver mejor los bordes de la imagen
    %% binarizamos y hacemos un not que nos permita quitar el borde
    %% de la imagen pues dificulta la segmentación
    %}
    
    
    originalAdjusted = imadjust(originalAtI);
    subplot(2,6,2,'Parent',p), imshow(originalAdjusted,[]);
    title(strcat('Original ajustada con imadjust #', int2str(frame)));
    
    %{
    %%Sin este paso fue díficil ver los segmentos de la imagen
    %}
    originalHisteq = histeq(originalAdjusted);
    subplot(2,6,3,'Parent',p), imshow(originalHisteq,[]);
    title(strcat('imadjust + histeq #', int2str(frame)));
    
    BinaryImage = im2bw(originalHisteq);
    subplot(2,6,4,'Parent',p), imshow(BinaryImage,[]);
    title(strcat('imagen BW #', int2str(frame)));
    
    %{
    %% Ahora al hacer el inverso, podemos percibir
    %% aquellas estructuras circulares que pueden ser de
    %% nuestro interés
    %}
    NotBinaryImage = not(BinaryImage);
    subplot(2,6,5,'Parent',p), imshow(NotBinaryImage,[]);
    title(strcat('imagen not(BW) #', int2str(frame)));
    
    %{
    %% Quitamos el borde para hacer más fácil
    %% la segmentación
    %}
    BW = imclearborder(NotBinaryImage);
    subplot(2,6,6,'Parent',p), imshow(BW,[]);
    title(strcat('imagen not(BW) sin bordes #', int2str(frame)));
    
    %{
    %% Ahora procedimos a hacer un imclose con un disco
    %% de esta forma podemos filtrar y quedarnos con
    %% los elementos circulares
    %}
    
    SE = strel('disk', 10);
    Id = imclose(BW,SE);
    subplot(2,6,7,'Parent',p), imshow(Id,[]);
    title(strcat('imagen tras imclose #', int2str(frame)));
    subplot(2,6,8,'Parent',p), imshow(not(Id),[]);
    title(strcat('not(imagen) tras imclose #', int2str(frame)));
    
    %{
    %% Hacemos el not para que el área de
    %% interés nos quede rodeada de todo lo negro
    %% y aplicamos un clearborder, de esta forma, se nos va a dejar
    %% el espacio en negro que dentor tiene un espacio blanco
    %% quedará como una máscara que podemos ocupar
    %% Es decir lo blanco que rodeaba a lo negro
    %% lo convertimos todo en negro
    %}
    Id2 = imclearborder(not(Id));
    subplot(2,6,9,'Parent',p), imshow(Id2,[]);
    title(strcat('imagen sin bordes (máscara) #', int2str(frame)));
    
    
    Mask = int16(Id2);
    
    Inew = originalAdjusted.*Mask;
    subplot(2,6,10,'Parent',p), imshow(Inew,[]);
    title(strcat('Máscara aplicada #', int2str(frame)));

    
    %%https://www.mathworks.com/examples/image/mw/images-ex49644526-detect-and-measure-circular-objects-in-an-image
    [centers, radii] = imfindcircles(Inew,[10 10],'ObjectPolarity','bright', ...
    'Sensitivity',1, 'EdgeThreshold',0.6);

    [centers2, radii2] = imfindcircles(Inew,[20 20],'ObjectPolarity','dark', ...
    'Sensitivity',1, 'EdgeThreshold',0.9);

    subplot(2,6,11,'Parent',p);
    imshow(Inew);
    title(strcat('imfindcircles(original.*máscara) #', int2str(frame)));
    h = viscircles(centers,radii);
    h2 = viscircles(centers2,radii2,'EdgeColor','g');
    
    subplot(2,6,12,'Parent',p);
    imshow(originalHisteq);
    title(strcat('Resultado #', int2str(frame)));
    h3 = viscircles(centers,radii, 'LineStyle', '--');
    h4 = viscircles(centers2,radii2,'EdgeColor','g', 'LineStyle', '--');
    
    frame = frame + 1;
    pause(0.1);
    
    
end
close(f);