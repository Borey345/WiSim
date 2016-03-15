classdef RayleighChannel
    %CHANNEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nAntennas
        covarianceMatrixSqrt
    end
    
    methods  
        function obj = RayleighChannel(nAntennas, covarianceMatrix)
            obj.nAntennas = nAntennas;
            if nargin > 1
                obj.covarianceMatrixSqrt = covarianceMatrix^(1/2);
            else
                obj.covarianceMatrixSqrt = eye(nAntennas);
            end
        end
        
        function out = process(obj, in)
            nChannels = size(in, 3);
            channelCoefficients = obj.getChannel([1, nChannels]);
            out = bsxfun(@times, channelCoefficients, in);
        end
        
        function H = getChannel(obj, sizeOfSamples)
            H = obj.covarianceMatrixSqrt*complexRandn([obj.nAntennas, sizeOfSamples]);
        end
    end
    
end

