

function [h] = rdc_32(fd,Timp,L,type);

% RDC - Rayleigh Dopler Channel

 %fd =100;       %Max Dopler Frequency
 %Timp =0,00001; %Time of impuls
 %L  =10000;      % Length
 % type = 1;
% H - Output channel


n=32;

%xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_Build_Adamar_Matrix_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

a2=[1 1
    1 -1];
a4=[1 1 1 1
    1 -1 1 -1
    1 1  -1 -1
    1 -1 -1 1];
a8=[1     1     1     1     1     1     1     1
     1    -1     1    -1     1    -1     1    -1
     1     1    -1    -1     1     1    -1    -1
     1    -1    -1     1     1    -1    -1     1
     1     1     1     1    -1    -1    -1    -1
     1    -1     1    -1    -1     1    -1     1
     1     1    -1    -1    -1    -1     1     1
     1    -1    -1     1    -1     1     1    -1];
a16=[1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
     1    -1     1    -1     1    -1     1    -1     1    -1     1    -1     1    -1     1    -1
     1     1    -1    -1     1     1    -1    -1     1     1    -1    -1     1     1    -1    -1
     1    -1    -1     1     1    -1    -1     1     1    -1    -1     1     1    -1    -1     1
     1     1     1     1    -1    -1    -1    -1     1     1     1     1    -1    -1    -1    -1
     1    -1     1    -1    -1     1    -1     1     1    -1     1    -1    -1     1    -1     1
     1     1    -1    -1    -1    -1     1     1     1     1    -1    -1    -1    -1     1     1
     1    -1    -1     1    -1     1     1    -1     1    -1    -1     1    -1     1     1    -1
     1     1     1     1     1     1     1     1    -1    -1    -1    -1    -1    -1    -1    -1
     1    -1     1    -1     1    -1     1    -1    -1     1    -1     1    -1     1    -1     1
     1     1    -1    -1     1     1    -1    -1    -1    -1     1     1    -1    -1     1     1
     1    -1    -1     1     1    -1    -1     1    -1     1     1    -1    -1     1     1    -1
     1     1     1     1    -1    -1    -1    -1    -1    -1    -1    -1     1     1     1     1
     1    -1     1    -1    -1     1    -1     1    -1     1    -1     1     1    -1     1    -1
     1     1    -1    -1    -1    -1     1     1    -1    -1     1     1     1     1    -1    -1
     1    -1    -1     1    -1     1     1    -1    -1     1     1    -1     1    -1    -1     1];
 

for i=1:n/2
for j=1:n/2
    a32(i,j)=a16(i,j);
    a32(i+n/2,j)=a16(i,j);
    a32(i,j+n/2)=a16(i,j);
    a32(i+n/2,j+n/2)=(-1)*a16(i,j);
end
end

%xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_End_of_Build_Adamar_Matrix_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

for j=1:n
    amplitude(1,j)=a32(type,j);
    tetta(1,j)=2*pi*rand(1,1);
    fn(1,j)=fd*cos(pi*((j-0.5)/(2*n)));
end

cosinus = zeros(L,n);
for m=1:L
for j=1:n
    cosinus(m,j)=cos(2*pi*Timp*m*fn(1,j)+tetta(1,j));
end
end


for j=1:n
    Ref(1,j)=cos(pi*j/n);
    Imf(1,j)=sin(pi*j/n);
end


Re = zeros(L,n);
Im = zeros(L,n);
for m=1:L
for j=1:n
    Re(m,j)=amplitude(1,j)*Ref(1,j)*cosinus(m,j);
    Im(m,j)=amplitude(1,j)*Imf(1,j)*cosinus(m,j);
end
end


RE=((2/n)^0.5)*sum(Re')';
IM=((2/n)^0.5)*sum(Im')';

h = zeros(L,1);
for i=1:L
    h(i,1)=RE(i,1)+1j*IM(i,1);
end


