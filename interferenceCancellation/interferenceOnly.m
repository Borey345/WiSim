function interferenceOnly()
    nAntennas = 2;
    nSamples = 1000;
    interferenceToNoiseRatioDb = 20;
    nSimulations = 1000;
    interferenceToNoiseRatio = 10^(interferenceToNoiseRatioDb/10);
    nEstimationSamplesValues = [2 4 6 8 10];
    tic
    out = zeros(nSimulations, 5);

    noisePower = 1/(sqrt(interferenceToNoiseRatio));

    channel = RayleighChannel(nAntennas);
    interferenceSrc = SignalSource(1, SignalSource.TYPE_QPSK);
    noiseSrc = SignalSource(noisePower, SignalSource.TYPE_GAUSS);

    for iValue=1:size(nEstimationSamplesValues,2)
        nEstimationSamples = nEstimationSamplesValues(iValue);
        for iSimulation = 1:nSimulations
             try
                INTERFERENCE = interferenceSrc.getSignal([1 nSamples]);

                Z = channel.process(INTERFERENCE);

                N = noiseSrc.getSignal(size(Z));
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
end