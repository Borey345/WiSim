classdef KnownSignalCase < Case
    %KNOWNSIGNALCASE Summary of this class goes here
    %   Detailed explanation goes here
    properties(Constant)
        LOOP_ARRAY = [5 3000];
        SNR = 10;
        INR = 20;
        N_ANTENNAS = 2;
        N_SAMPLES = 1000;
        N_ESTIMATION_SAMPLES = [2 4 6 8 10];
    end
    
    properties
        interferenceSignal
        knownSignal
        noiseSignal
        channel
    end
    
    methods
        function obj = KnownSignalCase
            obj@Case('Known Signal', KnownSignalCase.LOOP_ARRAY);
            obj.interferenceSignal = SignalSource((1/evaluateNoisePower(KnownSignalCase.INR - KnownSignalCase.SNR)), SignalSource.TYPE_GAUSS);
            obj.knownSignal = SignalSource(1, SignalSource.TYPE_QPSK);
            obj.noiseSignal = SignalSource(evaluateNoisePower(10), SignalSource.TYPE_GAUSS);
            obj.channel = RayleighChannel(KnownSignalCase.N_ANTENNAS);
        end
        
        
        function out = evaluate(obj, indices)
            knownSignal = obj.knownSignal.getSignal([1 KnownSignalCase.N_SAMPLES]);
            interference = obj.interferenceSignal.getSignal([1 KnownSignalCase.N_SAMPLES]);
            
            signal = obj.channel.process(knownSignal);
            interference = obj.channel.process(interference);
            
            n = obj.noiseSignal.getSignal([KnownSignalCase.N_ANTENNAS, KnownSignalCase.N_SAMPLES]);
            
            X = signal + interference + n;
            
            
            nEstimationSamples = KnownSignalCase.N_ESTIMATION_SAMPLES;
            inputSignalForEstimation = X(:,1:nEstimationSamples(indices(1)));
            R = correlationMatrix(inputSignalForEstimation);
            
            G = (inputSignalForEstimation*repmat(knownSignal(:,1:nEstimationSamples(indices(1)))', [1 2]))/KnownSignalCase.N_SAMPLES;
            W = (R^-1)*G(:,1);
            
            signal = W'*signal;
            interference = W'*interference;
            noise = W'*n;
            
            out = evaluateSnir(signal,interference, noise);
        end
        
        function processResults(obj, out)
            out = 10*log10(mean(out, 2));
            plot(KnownSignalCase.N_ESTIMATION_SAMPLES, out);
            grid on;
            axis([0 10 6 11]);
        end
    end
    
    methods(Static)
        function start()
            case1 = KnownSignalCase();
            case1.go();
        end
    end
end

