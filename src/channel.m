%-------------------Simulator of MIMO system M*N-antennaes------------------%
%------------------------- The function for channel-------------------------%

function [H] = channel(N);

N=2;%количество антенн

p0=10;
for i=1:10000;%количество векторов
h(i,:) = (randn(1,N)+j*randn(1,N))./sqrt(2);% Релеевский канал
end
H=h';
if (N==1 )
p=((conj(H).*H).*p0);
else
p=sum((conj(H).*H).*p0);
end
%==========================================
%==теоретический график============
f=1/(factorial(N-1)*p0^(N-1)).*p.^(N-1).*exp(-p./p0);
plot(p,f,'*')
hold on
x=0.1:0.1:100;
y=hist(p,x);
y=y/100;
plot(x,y,'r')