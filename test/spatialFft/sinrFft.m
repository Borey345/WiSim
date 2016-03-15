nSamples = 1000;
nAntennas = 64;
% nSamples = 4;
% nAntennas = 4;
angularSpread = 8;

antennasPositions = 0:0.5:(nAntennas/2-0.5);

covarianceMatrix = channelCovarianceMatrix(angularSpread, antennasPositions, 0);
channelObj = RayleighChannel(nAntennas, covarianceMatrix);
H = channelObj.getChannel(nSamples);


A = steeringVector(uniform(-pi/3, pi/3, [1, nSamples]), antennasPositions);

H = A.*H;
H = normalizeVectorsInMatrix(H);

[Hselect, idx] = sort(H, 1);

for iRemoveAntenna = 0:nAntennas-1
    Huse = Hselect(1+iRemoveAntenna:end, :);
    outSnr(iRemoveAntenna+1) = mean(sum(Huse.*conj(Huse),1));
end

plot(64:-1:1, 10*log10(outSnr))
hold on
Hfft = fft(H);

Hfft = normalizeVectorsInMatrix(Hfft);

[Hselect, idx] = sort(Hfft, 1);

for iRemoveAntenna = 0:nAntennas-1
    Huse = Hselect(1+iRemoveAntenna:end, :);
    outSnr(iRemoveAntenna+1) = mean(sum(Huse.*conj(Huse),1));
end

plot( 64:-1:1, 10*log10(outSnr), 'r')

grid on
xlabel('Num RF paths')
ylabel('SNR');
