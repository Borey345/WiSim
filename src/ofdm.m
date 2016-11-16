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

% global added;                % Для OFDM - систем added не ноль
% added = 0;

packetLength = 48*2;
%-------------------------------------------------------------------------%
counter = 0;
consol = waitbar(0,'Please wait...');
SNR = zeros( 22, 1 );
% 
% H = channelCoefficients( beta );
% H = H*64/sum( abs(H) );
%H = (sqrt(0.5) + sqrt(0.5)*1i)*ones( 64, 1 );
bitSource = SignalSource(1, SignalSource.TYPE_BIT);
modulation = QamModulation(QamModulation.nModulatedBitsToModulationType(modulationType));

nPoints = -min(snrValues)+max(snrValues);
ofdmModulation = OfdmModulation(0);
for snr = min(snrValues):max(snrValues)                                % in dB

    counter = counter + 1;
    SNR(counter) = snr;
    noiseSource = SignalSource( 10^(-snr/10), SignalSource.TYPE_GAUSS );

    for realisation = 1 : nRealiz
        
        bits = bitSource.getSignal([1, modulationType*nbits] );
        if coderOn
            codedBits = Coder_Wi_Fi( bits );                   % action of coder
        else
            codedBits = bits;
        end
        
%         codedBits = interleaver( codedBits, modulationType, nSubcarriers );
        modulatedSignal = modulation.modulate( codedBits );         % action of modulator
        mappedSignalOriginal = mapper( modulatedSignal, nSubcarriers );  
        
        timeDomainSignal = ofdmModulation.modulate(mappedSignalOriginal);
        
        for noiseRealiz = 1:nNoise
            
            noise = noiseSource.getSignal(size(timeDomainSignal));
            
            for channelRealiz = 1:nChannel
            
                mappedSignal = mappedSignalOriginal;

%                 if channelOn
%                     H = channelCoefficients( beta );
%                 else 
                    H = ones( 1, 64 );
%                 end
%                 
% 
%                 if channelOn
%                     for i=1:64
%                         mappedSignal( i,: ) = H( 1, i )*mappedSignal( i, : );
%                     end
%                 end
     
                signalWithNoise = timeDomainSignal + noise;

%                 if channelOn
%                     for i=1:64
%                         signalWithNoise( i,: ) = signalWithNoise( i, : )/H( 1, i );
%                     end      
%                 end

                signalWithNoise = ofdmModulation.demodulate(signalWithNoise);

                demappedSignal = demapper( signalWithNoise );
                
                channelPowers = channelPowerForDemappedSignal( H', modulationType, size( demappedSignal, 2) );

                demodulatedSignal = modulation.demodulate( demappedSignal, channelPowers );       % action of demapper
%                 demodulatedSignal = demappedSignal;
%                 demodulatedSignal = deinterleaver( demodulatedSignal, modulationType, nSubcarriers );
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
 

