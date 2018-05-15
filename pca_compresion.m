clear all
close all
clc

imagen = dicomread('VRIEs/Pac30.dcm');
i = imshow(uint16(imagen(:,:,1)),[]);
i = im2double(imagen(:,:,1));    
figure, 
set(gcf,'numbertitle','off','name','Imagen Original'),  
imshow(i)          
i_mean = mean(i);      
[a b] = size(i); 
i_mean2 = repmat(i_mean,a,1); 
i_Adjust = i - i_mean2; 
i_cov = cov(i_Adjust);   
[V, D] = eig(i_cov); 
i_eigen=V'*i_Adjust';   
%%  
% Start of Inverse PCA code, 
i_Original = inv(V') * i_eigen;                         
i_Original = i_Original' + i_mean2;           
figure, 
set(gcf,'numbertitle','off','name','Image recuperada'), 
imshow(i_Original)       
% End of Inverse PCA code 
  
% Image compression 
PCs=input('Ingrese el n?mero de columnas necesarias?  ');                    
PCs = b - PCs;                                                         
V_red = V;                                                         
for idx = 1:PCs,                                                         
V_red(:,1) =[]; 
end 
Y=V_red'* i_Adjust';                                        
i_compres=V_red*Y;                                           
i_compres = i_compres' + i_mean2;                     
figure,                                                                
set(gcf,'numbertitle','off','name','Imagen Comprimida'),  
imshow(i_compres) 
% End of image compression 
