function powerDelayProfilePlotter()

delays = 0:63;
coef = 1;

%h = ;
beta = 0.1;
k = 1 - exp( -beta );
P = k*coef*exp( -beta*delays );
plot( delays, P, '--r' )
hold on



beta = 0.5;
k = 1 - exp( -beta );
P = k*coef*exp( -beta*delays );
plot( delays, P, '.-b' )
hold on

beta = 1;
k = 1 - exp( -beta );
P = k*coef*exp( -beta*delays );
plot( delays, P, '-g' )
hold on

legend( 'beta = 0.1', 'beta = 0.5', 'beta = 1' )
