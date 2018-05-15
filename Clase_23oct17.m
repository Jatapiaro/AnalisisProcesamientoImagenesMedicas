VRIE=squeeze(dicomread('N1.dcm'));
k=fspecial('gaussian',[ 9 9], 0.9);
VRIEf=imfilter(VRIE,k,'same');
[Ifase,Iamp]=fIfase(double(VRIEf),15);
figure, imshow(Iamp,[]), colormap(jet);
figure, imshow(Ifase,[]), colormap(jet);

%Umbralizando
idx=find(Iamp>(.2*max(max(Iamp))));
BW=zeros(size(Iamp));
BW(idx)=1;
figure, imshow(Ifase.*BW,[])

%Para el VI
BW=roipoly
IfaseVI=((Ifase.*BW)+pi)*180/pi;
figure, imshow(IfaseVI,[]), colormap(jet), colorbar;



