%{
% .dcm son imagenes en formato "médico"
% ponemos el nombre del folder donde se van a 
% jalar todas las imágenes del MRI
%}

mriFolder = fullfile(pwd, 'T1W');

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
    imagen = rgb2gray(dicomread(nombreImagen));
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
estudioMRI = flip(estudioMRI);

f = figure;
p = uipanel('Parent', f, 'BorderType', 'none');
p.Title = strcat('MRI');
p.TitlePosition = 'centertop';
p.FontSize = 12;
p.FontWeight = 'bold';
for i = 1:1:totalImagenes
    
    originalAtI = estudioMRI(:,:,i);
    levelOtsu = graythresh(originalAtI);
    BW = im2bw(originalAtI,levelOtsu);
    
    radius = 24;
    
    if (levelOtsu < 0.24)
        radius = 18;
    end
    
    if (levelOtsu>0.25)
        radius = 14;
    end
    
    if (levelOtsu>0.36)
        radius = 100;
    end
    
    
    
    SE = strel('disk', radius);
    Id = imopen(BW,SE);
    
    isolatedImage = originalAtI; % Make a copy so you don't destroy the original.
    isolatedImage(not(Id)) = 0;  % Set black areas to black, leaving gray areas intact.
  
    subplot(2,2,1,'Parent',p), imshow(originalAtI);
    title(strcat('Imagen original en el frame #', int2str(i)));
    subplot(2,2,2,'Parent',p), imshow(BW);
    title(strcat('Imagen BW en el frame #',num2str(i), 'con un nivel otsu de: ', num2str(levelOtsu)));
    subplot(2,2,3,'Parent',p), imshow(Id);
    title(strcat('Imagen tras imopen en el frame #',num2str(i)));
    subplot(2,2,4,'Parent',p), imshow(isolatedImage);
    title(strcat('Imagen original tras aplicar la máscara en el frame #',num2str(i)));
    pause(0.1);
    
end
close(f);