classdef SignalSource
    %SIGNALSOURCE Summary of this class goes here
    %   Detailed explanation goes here
    properties(Constant)
        TYPE_GAUSS = 'gauss';
        TYPE_QPSK = 'qpsk';
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
            obj.magnitude = sqrt(power);
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
            end
            signal = signal*(obj.magnitude/SignalSource.SQRT2);
        end
    end
    
end

