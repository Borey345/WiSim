classdef RayleighChannel
    %CHANNEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nChannels
    end
    
    methods  
        function obj = RayleighChannel(nChannels)
            obj.nChannels = nChannels;
        end
        
        function out = process(obj, in)
            channelCoefficients = (randn(obj.nChannels, 1) + 1i*randn(obj.nChannels, 1));
            channelCoefficients = channelCoefficients./(abs(channelCoefficients));
            out = bsxfun(@times, channelCoefficients, in);
        end
    end
    
end

