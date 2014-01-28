%Gaussian interference
nAntennas = 2;
nSamples = 1000;
interferenceToNoiseRatioDb = 20;
nSimulations = 10000;
interferenceToNoiseRatio = 10^(interferenceToNoiseRatioDb/10);
nEstimationSamplesValues = [2 4 6 8 10];
tic
out = zeros(nSimulations, 5);


noiseCoefficient = 1/(sqrt(2*interferenceToNoiseRatio));
sqrt2 = sqrt(2);

for iValue=1:size(nEstimationSamplesValues,2)
    nEstimationSamples = nEstimationSamplesValues(iValue);
    for iSimulation = 1:nSimulations
         try
            INTERFERENCE = getSignal(nSamples);
            
            channelCoefficients = (randn(nAntennas, 1) + 1i*randn(nAntennas, 1));
            channelCoefficients = channelCoefficients./(abs(channelCoefficients));
            Z = bsxfun(@times, channelCoefficients, INTERFERENCE);
            
            N = noiseCoefficient*(randn(nAntennas, nSamples) + 1i*randn(nAntennas, nSamples));
            X = Z+N;
            
            R = correlationMatrix(X(:,1:nEstimationSamples));
            [V, D] = eig(R);
            [~, index] = min(abs(diag(D)));
            W = V(:, index);
            YZ = W'*Z;
            YN = W'*N;
            
            noisePower = signalPower(YN);
            out(iSimulation, iValue) = 10*log10(signalPower(YZ)/noisePower+1);
        catch err
            iValue
            iSimulation
            err.rethrow
        end
    end 
end
toc
result = mean(out, 1);
plot(nEstimationSamplesValues, result);
grid on