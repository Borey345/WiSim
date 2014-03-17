classdef RayleighChannel
    %CHANNEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nAntennas
    end
    
    methods  
        function obj = RayleighChannel(nAntennas)
            obj.nAntennas = nAntennas;
        end
        
        function out = process(obj, in)
            nChannels = size(in, 3);
            channelCoefficients = (randn(obj.nAntennas, 1, nChannels) + 1i*randn(obj.nAntennas, 1, nChannels));
            channelCoefficients = channelCoefficients./(abs(channelCoefficients));
            out = bsxfun(@times, channelCoefficients, in);
        end
    end
    
end

