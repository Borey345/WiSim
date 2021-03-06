classdef SignalSource
    %SIGNALSOURCE Summary of this class goes here
    %   Detailed explanation goes here
    properties(Constant)
        TYPE_GAUSS = 1;
        TYPE_QPSK = 2;
        TYPE_BIT = 3;
        
        SQRT2 = sqrt(2);
    end
    properties
        %gauss or qpsk
        type
        power
        magnitude
    end
    
    methods
        function obj = SignalSource(power, type)
            obj.type = type;
            obj.power = power;
            obj.magnitude = sqrt(power/2);
        end
        function signal = getSignal(obj, sigSize)
            switch obj.type
                case SignalSource.TYPE_GAUSS
                    signal = (randn(sigSize) + 1i*randn(sigSize));
                case SignalSource.TYPE_QPSK
                    sSignal = randi([0 1], sigSize);
                    qSignal = randi([0 1], sigSize);
                    sSignal(sSignal == 0) = -1;
                    qSignal(qSignal == 0) = -1;
                    signal = sSignal + 1i*qSignal;
                case SignalSource.TYPE_BIT
                    signal = logical(randi([0 1], sigSize));
                    return;
            end
            signal = signal*obj.magnitude;
        end
    end
    
end

