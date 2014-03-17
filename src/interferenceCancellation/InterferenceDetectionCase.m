classdef InterferenceDetectionCase < Case

    properties(Constant)
        INTERFERENCE_TO_NOISE_RATIO_ARRAY = -10:2.5:20;
        LOOP_ARRAY = [length(InterferenceDetectionCase.INTERFERENCE_TO_NOISE_RATIO_ARRAY) 3000];
    end
    
    properties
        signalSource
        interferenceSource
    end
    
    methods
        function obj = InterferenceDetectionCase
            obj@Case('InterferenceDetectionCase', InterferenceDetectionCase.LOOP_ARRAY);
            obj.signalSource = SignalSource(1, SignalSource.TYPE_QPSK);
            obj.interferenceSource = SignalSource(1, SignalSource.TYPE_GAUSS);
        end
        
        function out = evaluate(obj, indices)
            noisePower = evaluateNoisePower(InterferenceDetectionCase.INTERFERENCE_TO_NOISE_RATIO_ARRAY(indices(1)));
            noiseSource = SignalSource(noisePower, SignalSource.TYPE_GAUSS);
            
        end
        
        function processResults(obj, out)
        end
    end
    
    methods(Static)
        function start()
            case1 = InterferenceDetectionCase();
            case1.go();
        end
    end
end