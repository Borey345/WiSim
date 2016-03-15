nTonesInRb = 12;
nRbs = 50;

carrierFreq = 2e9;

frequencyDelta = 15000;
freqGrid = 0:nTonesInRb*frequencyDelta:nRbs*nTonesInRb*frequencyDelta;

[H, delay] = scmWrap(8,1);

phaseShift = exp(2i*pi*bsxfun(@times, (carrierFreq+freqGrid)', delay));

freqChannel = sum(bsxfun(@times, H, permute(phaseShift, [1 3 2])), 3);

surf(abs(freqChannel))

freqChannel = ifftshift(ifft(freqChannel));
freqChannel = fft(permute(freqChannel, [2 1]));
freqChannel = fftshift(freqChannel);
freqChannel = permute( freqChannel, [2 1]);
figure
surf(abs(freqChannel))








