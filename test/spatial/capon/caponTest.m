function [ output_args ] = caponTest( input_args )

nTxAntennas = 8;
nRxAntennas = 1;
snr = 0.1;
angularSpread_deg = 0.1;

antennaPositions = 0:0.5:(nTxAntennas-1)/2;

sourceAngles = [-30, -10, 2, 15];
sourceAngles = [-45, -30, -10, 2, 15, 30, 45];
% sourceAngles = [-40];
channel = RayleighChannel(nTxAntennas, channelCovarianceMatrix(angularSpread_deg, antennaPositions, 0));

a = steeringVector(sourceAngles*pi/180, antennaPositions);

H = channel.getChannel(length(sourceAngles));
H = bsxfun(@times, a, H);

% a = bsxfun(@times, [0.2,0.4, 0.6,1], a);

M = H*H'+snr*eye(nTxAntennas);

testAngles = -90:0.1:90;

spectrumSamples = steeringVector(testAngles*pi/180, antennaPositions);

pseudoSpectrum = (M^-1)*spectrumSamples;
pseudoSpectrum = 1./sum(bsxfun(@times, conj(pseudoSpectrum), pseudoSpectrum), 1);

pseudoSpectrum1 = (M^-3)*spectrumSamples;
pseudoSpectrum1 = 1./sum(bsxfun(@times, conj(pseudoSpectrum1), pseudoSpectrum1), 1);

plot(testAngles, pseudoSpectrum);
grid on
hold on
figure
plot(testAngles, pseudoSpectrum1, 'r');

end

% H = scmWrap(nTxAntennas, nRxAntennas);
% H = sum(H, 3);
