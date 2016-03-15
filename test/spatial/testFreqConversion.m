%% test transform
% angles = pi/4;
% antennasPositions = 0:0.5:511.5;
% a1 = sum(steeringVector(angles, antennasPositions),2);
% 
% 
% a2 = sum(steeringVector(angles, 2*antennasPositions),2);
% 
% a2Test = a1.^(2);

%% test spectrum
% a1 = steeringVector(angles, antennasPositions);
% spectrumAngle = -90:180/length(antennasPositions):90;
% plot(spectrumAngle(1:end-1), abs(fftshift(fft(a1))));
% hold on

% a2 = steeringVector(angles, 2*antennasPositions);
% plot(spectrumAngle(1:end-1), abs(fftshift(fft(a2))), 'r');

%% test resampling

nAntennas = 16;
ulFreq = 2.6;
dlFreq = 2.5;

lambdaUl = 0.3/ulFreq;
lambdaDl = 0.3/dlFreq;
angles = pi/6;
antennaPositionsUl = 0:0.5:127.5;
antennaPositionsDl = (lambdaDl/lambdaUl)*antennaPositionsUl;

aUl = steeringVector(angles, antennaPositionsUl);

aDl = steeringVector(angles, antennaPositionsDl);

aDlResampled = resample(aUl, 25, 26);

errorVector = (aDl(3:length(aDlResampled))-aDlResampled(3:end));
% errorVector = aDl - aUl;
evm = norm(errorVector)/norm(aDl)


