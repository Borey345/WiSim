classdef OfdmModulation < handle
    %OFDMMODULATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        cpLength
        nFftPoints
    end
    
    methods
        function obj = OfdmModulation(cpLength)
            obj.cpLength = cpLength;
        end
        
        function signalTimeDomain = modulate(obj, signalFreqTime)
            obj.nFftPoints = size(signalFreqTime, 1);
            signalFreqTime = ifft(signalFreqTime).*sqrt(obj.nFftPoints);
            signalFreqTime = [signalFreqTime( (end-obj.cpLength+1):end, :); signalFreqTime];
            signalTimeDomain = reshape(signalFreqTime, 1, []);
        end
        
        function signalFreqTime = demodulate(obj, signalTimeDomain)
            signalFreqTime = reshape(signalTimeDomain, obj.cpLength + obj.nFftPoints, []);
            signalFreqTime = fft(signalFreqTime( (end-obj.nFftPoints+1):end, :))./sqrt(obj.nFftPoints);
        end
    end
    
end

