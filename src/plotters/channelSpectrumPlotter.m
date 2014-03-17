function channelSpectrumPlotter()

delays = 0:63;
coef = 1/2;

%h = ;
beta = 0.1;
k = 1 - exp( -beta );
P = k*coef*exp( -beta*delays );
h = sqrt( P ).*(randn(1,64) + 1i*randn(1,64));
H = fft( h );
stem( delays, abs(H) )
figure



beta = 0.5;
k = 1 - exp( -beta );
P = k*coef*exp( -beta*delays );
h = sqrt( P ).*(randn(1,64) + 1i*randn(1,64));
H = fft( h );
stem( delays, abs(H) )
figure

beta = 1;
k = 1 - exp( -beta );
P = k*coef*exp( -beta*delays );
h = sqrt( P ).*(randn(1,64) + 1i*randn(1,64));
H = fft( h );
stem( delays, abs(H) )