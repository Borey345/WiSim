function [mean_ber_coded mean_per] = ofdm( modulationType, beta, coderOn, channelOn, snrValues )
nSubcarriers = 48;

if nargin == 0
    modulationType  = 2;                % Type of modulation: 1-PBSK,2-QPSK,4-16_QAM,6-64_QAM.
end

if nargin < 2
    beta = 0.3;
end

if nargin < 3
    coderOn = 1;                % Флаг включения кодера: 1 - кодер включен; 0 - кодер выключен.
end

if nargin < 4
    channelOn = 1;                % Флаг включения кодера: 1 - кодер включен; 0 - кодер выключен.
end
nbits = 2^2*nSubcarriers;

%nbits = 16;
N           = 1;                % Number of antenn

color = 'r';
nRealiz     = 1;                % The number of realizations in statistical ensemble.
if channelOn
    nbits = 2^4*nSubcarriers;
    nChannel = 200;% 400
    nNoise = 20; %5
    if modulationType ==6
        nbits = 2^4*nSubcarriers;
        nChannel = 100;
    end
else
    nbits = 2^10*nSubcarriers;
    nChannel = 1;
    nNoise = 1;
end
coderRate   = 1;                % Темп кодирования: 1 - 1/2; 2 - 3/4; 3 - 2/3.

m           = 1;                % Флаг включения декодера Витерби: 1 - декодер включен; 0 - декодер выключен.
dectype     = 'unquant';        % Декодер Витерби с мягкими метриками.
global added;                % Для OFDM - систем added не ноль
added = 0;

fd          = 100 ;             % Max Dopler Frequency
Timp        = 100*10^(-6);      % Time of impuls
L           = 6000;            % Length
type        = 1;

packetLength = 48*2;
%-------------------------------------------------------------------------%
counter = 0;
consol = waitbar(0,'Please wait...');
SNR = zeros( 22, 1 );
% 
% H = channelCoefficients( beta );
% H = H*64/sum( abs(H) );
%H = (sqrt(0.5) + sqrt(0.5)*1i)*ones( 64, 1 );
modulation = QamModulation(QamModulation.nModulatedBitsToModulationType(modulationType));

nPoints = -min(snrValues)+max(snrValues);
for snr = min(snrValues):max(snrValues)                                % in dB
    noiseRate = 10^(-snr/20);                        %power is always 1, noise if different
    %noiseRate = 0;
    counter = counter + 1;
    SNR(counter) = snr;
    k=0;
    for realisation = 1 : nRealiz
        bits = randi( [0 1], 1, modulationType*nbits );
        if coderOn
            codedBits = Coder_Wi_Fi( bits );                   % action of coder
        else
            codedBits = bits;
        end
        
        codedBits = interleaver( codedBits, modulationType, nSubcarriers );
        modulatedSignal = modulation.modulate( codedBits );         % action of modulator
        mappedSignalOriginal = mapper( modulatedSignal, nSubcarriers );  
        
        for noiseRealiz = 1:nNoise
            
            noise = noiseRate*(randn(size( mappedSignalOriginal,1 ),size(mappedSignalOriginal,2))...
                + 1i*randn(size( mappedSignalOriginal,1 ),size(mappedSignalOriginal,2)))/sqrt(2);
            %noise = zeros( size( mappedSignalOriginal,1 ), size(mappedSignalOriginal,2) );
            for channelRealiz = 1:nChannel
            
                mappedSignal = mappedSignalOriginal;

                if channelOn
                    H = channelCoefficients( beta );
                else 
                    H = ones( 1, 64 );
                end
                %H = ones( 1, 64 )*(channelRealiz/4)*exp(1i*rand());
                %H = H*64/sum( abs(H) );
                %H = sqrt( 1:64 );
                

                if channelOn
                    for i=1:64
                        mappedSignal( i,: ) = H( 1, i )*mappedSignal( i, : );
                    end
                end

        %         H = ones( size( mappedSignal,1 ),size(mappedSignal,2) );
        %         H( 7:19, : ) = H( 7:19, : )*0.5;
        %         H( 20:32, : ) = H( 20:32, : )*0.3;
        %         H( 33:45, : ) = H( 33:45, : )*1.5;
        %         H( 46:58, : ) = H( 46:58, : )*1.1;        
                signalWithNoise = mappedSignal + noise;

                if channelOn
                    for i=1:64
                        signalWithNoise( i,: ) = signalWithNoise( i, : )/H( 1, i );
                    end      
                end

                demappedSignal = demapper( signalWithNoise );
                
                %demappedSignal = demappedSignal*0(abs(H(1,1))^2);
                
                channelPowers = channelPowerForDemappedSignal( H', modulationType, size( demappedSignal, 2) );

                demodulatedSignal = modulation.demodulate( demappedSignal, channelPowers );       % action of demapper
                demodulatedSignal = deinterleaver( demodulatedSignal, modulationType, nSubcarriers );
                if coderOn
                    outBits = decoder( demodulatedSignal );
                else
                    outBits = demodulatedSignal > 3;
                end

                errors = outBits~=bits;
        %         ber_uncoded(realisation) = mean( errors );
                per(realisation, noiseRealiz, channelRealiz) = mean( sum( reshape( errors, packetLength, [] ) ) > 0 );
                ber_coded(realisation, noiseRealiz, channelRealiz) = mean(outBits~=bits); % ber meter
                %mean(outBits~=bits)
            end
        end
        
        
    end
    ber_coded;
    mean_ber_coded(counter) = mean(mean(mean(ber_coded)));
%     mean_ber_uncoded(counter) = mean( ber_uncoded );
    mean_per(counter) = mean(mean(mean( per )));
    consol = waitbar(counter/nPoints);
% % figure(1);                                               % practice plots
% semilogy(SNR,mean_ber,'.r');
% axis ([-20 20 10^(-4) 1]);
% title('BER in system with N received antens');
% xlabel('SNR, dB');
% ylabel('BER');
% grid on;
% hold on;
end
close(consol);
%-------------------------------------------------------------------------%
%figure;                                               % practice plots
%hold on
%  semilogy(SNR,mean_ber_coded, color);
% hold on
% semilogy(SNR,mean_ber_uncoded, color);
%semilogy(SNR,mean_per, color);
% axis ([-1 20 10^(-5) 10^(-1)]);
%title('BER in OFDM system ');
% xlabel('SNR, dB');
% ylabel('BER');
%legend( 'coded', 'not coded' );
% grid on;
% hold on;
 

