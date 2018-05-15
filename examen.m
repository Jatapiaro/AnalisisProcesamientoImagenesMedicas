%{
% .dcm son imagenes en formato "médico"
% ponemos el nombre del folder donde se van a 
% jalar todas las imágenes del MRI
%}

mriFolder = fullfile(pwd, 'VRIEs');

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
    %imshow(imagen);
    estudioMRI(:,:,i) = uint16(imagen);
    
    h = waitbar((length(nombreImagenes)-i+1)/length(nombreImagenes));
    if (i == 1)
        close(h);
    end   
end

f = figure('units','normalized','outerposition',[0 0 1 1]);
p = uipanel('Parent', f, 'BorderType', 'none');
p.Title = strcat('MRI');
p.TitlePosition = 'centertop';
p.FontSize = 12;
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
    originalAtI = estudioMRI(:,:,i);
    levelOtsu = graythresh(originalAtI);
    BW = im2bw(originalAtI,levelOtsu);
    
    radius = 18;
    
    SE = strel('disk', radius);
    Id = imopen(BW,SE);
    
    isolatedImage = originalAtI; %Make a copy so you don't destroy the original.
    isolatedImage(not(Id)) = 0;  %Set black areas to black, leaving gray areas intact.

  
    subplot(2,2,1,'Parent',p), imshow(originalAtI);
    title(strcat('Imagen original en el frame #', int2str(frame)));
    subplot(2,2,2,'Parent',p), imshow(BW);
    title(strcat('Imagen BW en el frame #',num2str(frame), 'con un nivel otsu de: ', num2str(levelOtsu)));
    subplot(2,2,3,'Parent',p), imshow(Id);
    title(strcat('Imagen tras imopen en el frame #',num2str(frame)));
    subplot(2,2,4,'Parent',p), imshow(isolatedImage);
    title(strcat('Imagen original tras aplicar la máscara en el frame #',num2str(frame)));
    frame = frame + 1;
    pause(0.1);
    
end
close(f);