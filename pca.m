VRIE=dicomread('N1.dcm');
H=fspecial('gaussian',[7,7],1);
for i=1:15
    Ifilt(:,:,i)=filter2(H,VRIE(:,:,i));
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% RUTINA PARA EL CALCULO DE LA IMAGEN FACTORIAL DE FASE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%CALCULO DE LOS FACTORES PRINCIPALES
X=Ifilt;
for k=1:15
    image_data = X(:,:,k);
    x(:,k) = image_data(:); 
end;
curvas=[x]; %En curvas esta el paciente

%%%%%%%CALCULA LOS COEFICIENTES DEL ENSAMBLE DE LA IMAGEN DE 64x64 %%%%%
cov_mat =cov(curvas);  %%CALCULA LA MATRIZ DE COVARIANZA (REMUEVE LA MEDIA)
[V,D] = eig(cov_mat);         %eigen values of cov matrix
KLCoefcz =V*(abs(D))^-0.5;%image decomposition coefficients WITH NORMALIZATION
media=mean(curvas);
media=repmat(media,length(curvas),1);
Pcurvas=curvas-media;
V1cz = Pcurvas*KLCoefcz; %%EIGEN IMAGEN


