function channelCoefficientsPlotter()

delays = 0:63;
coef = 1/2;

%h = ;
beta = 1000;
k = 1 - exp( -beta );
P = k*coef*exp( -beta*delays );
h = sqrt( P ).*(randn(1,64) + 1i*randn(1,64));
stem( delays, abs(h) )
figure

return

beta = 0.5;
k = 1 - exp( -beta );
P = k*coef*exp( -beta*delays );
h = sqrt( P ).*(randn(1,64) + 1i*randn(1,64));
stem( delays, abs(h) )
figure

beta = 1;
k = 1 - exp( -beta );
P = k*coef*exp( -beta*delays );
h = sqrt( P ).*(randn(1,64) + 1i*randn(1,64));
stem( delays, abs(h) )
stem( delays, angle(h) )