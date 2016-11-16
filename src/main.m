%figure
SNR = (-10:1:40);
beta = 1;
channelOn = 0;
coderOn = 0;
berFigure = figure;
thFigure = figure;

[ber per ] = ofdm( 1, beta, coderOn, channelOn, SNR );

save( 'ber mod1 beta1.mat', 'ber' );
save( 'per mod1 beta1.mat', 'per' );

W = 24/(3.2*10^(-6) );

figure( berFigure );
semilogy( SNR, ber );
grid on
hold on
figure( thFigure );
grid on
hold on

th = (1-per)*W*1;
semilogy( SNR, th );

grid on
hold on
[ber per ] = ofdm( 2, beta, coderOn, channelOn, SNR );
figure( berFigure );
semilogy( SNR, ber );
figure( thFigure );

save( 'ber mod2 beta1.mat', 'ber' );
save( 'per mod2 beta1.mat', 'per' );

th = (1-per)*W*2;
plot( SNR, th );

[ber per ] = ofdm(4, beta, coderOn, channelOn, SNR );

save( 'ber mod4 beta1.mat', 'ber' );
save( 'per mod4 beta1.mat', 'per' );

figure( berFigure );
semilogy( SNR, ber );
figure( thFigure );
th = (1-per)*W*4;
plot( SNR, th );

[ber per ] = ofdm( 6, beta, coderOn, channelOn, SNR );


save( 'ber mod6 beta1.mat', 'ber' );
save( 'per mod6 beta1.mat', 'per' );

figure( berFigure );
semilogy( SNR, ber );
figure( thFigure );
th = (1-per)*W*6;
plot( SNR, th );

figure( berFigure );
axis ([min(SNR) max(SNR) 10^(-3) 1]);