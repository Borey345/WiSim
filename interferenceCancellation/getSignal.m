function signal = getSignal(nSamples)

%gaussian
% signal = (randn(1, nSamples) + 1i*randn(1, nSamples))/sqrt2;
%qpsk
signal = randi([0 1], [2, nSamples]);
signal(signal == 0) = -1;
signal = (signal(1,:) + 1i*signal(2,:))/sqrt(2);

end