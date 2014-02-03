classdef InterferenceOnlyCase < Case
    properties(Constant)
        LOOP_ARRAY = [5 1000];
        N_SAMPLES = 1000;
        ESTIMATION_SAMPLES = [2 4 6 8 10];
        INTERFERENCE_TO_NOISE_RATIO_DB = 20;
        N_ANTENNAS = 2;
        INTERFERENCE_TYPE = SignalSource.TYPE_GAUSS;
            
        INTERFERENCE_TO_NOISE_RATIO = 10^(InterferenceOnlyCase.INTERFERENCE_TO_NOISE_RATIO_DB/10);
            
    end
    
    properties
        interferenceSrc
        noiseSrc
        channel
    end
        
    methods
        function obj = InterferenceOnlyCase()
            obj@Case('Interference Only', InterferenceOnlyCase.LOOP_ARRAY);
            obj.interferenceSrc = SignalSource(1, InterferenceOnlyCase.INTERFERENCE_TYPE);
            noisePower = 1/(sqrt(InterferenceOnlyCase.INTERFERENCE_TO_NOISE_RATIO));
            obj.noiseSrc = SignalSource(noisePower, SignalSource.TYPE_GAUSS);
            obj.channel = RayleighChannel(InterferenceOnlyCase.N_ANTENNAS);
        end
                
        function out = evaluate(obj, indices)
            INTERFERENCE = obj.interferenceSrc.getSignal([1 InterferenceOnlyCase.N_SAMPLES]);

            Z = obj.channel.process(INTERFERENCE);

            N = obj.noiseSrc.getSignal(size(Z));
            X = Z+N;

            nEstimationSamples = InterferenceOnlyCase.ESTIMATION_SAMPLES;
            R = correlationMatrix(X(:,1:nEstimationSamples(indices(1))));
            [V, D] = eig(R);
            [~, index] = min(abs(diag(D)));
            W = V(:, index);
            YZ = W'*Z;
            YN = W'*N;

            noisePower = signalPower(YN);
            out = 10*log10(signalPower(YZ)/noisePower+1);
        end
        
        function processResults(obj, out)
            result = mean(out, 2);
            plot(InterferenceOnlyCase.ESTIMATION_SAMPLES, result);
            grid on
        end
    end
    methods(Static)        
        function start()
            case1 = InterferenceOnlyCase();
            case1.go();
        end
    end
end