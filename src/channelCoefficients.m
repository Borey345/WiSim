function H = channelCoefficients( beta )

k = 1 - exp( -beta );

TAU = 3.84;

delays = 0:63;

coef = 1/2;

%h = ;
P = k*coef*exp( -beta*delays );
h = sqrt( P ).*(randn(1,64) + 1i*randn(1,64));
%h = P./coef;
% 
% P = k*exp( -beta*delays(6) );
% h(6) = P*coef*(randn() + 1i*randn());
% 
% 
% P = k*exp( -beta*delays(13) );
% h(13) = P*coef*(randn() + 1i*randn());
% 
% P = k*exp( -beta*delays(18) );
% h(18) = P*coef*(randn() + 1i*randn());
% 
% P = k*exp( -beta*delays(30) );
% h(30) = P*coef*(randn() + 1i*randn());
% 
% P = k*exp( -beta*delays(43) );
% h(43) = P*coef*(randn() + 1i*randn());

H = fft( h );
