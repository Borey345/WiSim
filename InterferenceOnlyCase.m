classdef InterferenceOnlyCase
    properties
        INTERFERENCE
        N
        nEstimationSamplesValues = 2:2:10;
    end
    
    methods
        function obj = InterferenceOnlyCase()
            obj.INTERFERENCE = interferenceSrc.getSignal([1 nSamples]);
        end
        
        function out = evaluate(obj, loopIndices)
            iValue = loopIndices(1);
            
            Z = channel.process(obj.INTERFERENCE);

            N = noiseSrc.getSignal(size(Z));
            X = Z+N;

            nEstimationSamples = obj.nEstimationSamplesValues(iValue);
            R = correlationMatrix(X(:,1:nEstimationSamples));
            [V, D] = eig(R);
            [~, index] = min(abs(diag(D)));
            W = V(:, index);
            YZ = W'*Z;
            YN = W'*N;

            noisePower = signalPower(YN);
            out = 10*log10(signalPower(YZ)/noisePower+1);
        end
    end
end