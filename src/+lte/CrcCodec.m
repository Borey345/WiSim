classdef CrcCodec
    
    properties(Constant)
        GCRC24A = 1;
        GCRC24B = 2;
        GCRC16 = 3;
        
        POLYNOMIAL_GCRC24A = [24, 23, 18, 17, 14, 11, 10, 7, 6, 5, 4, 3, 1, 0];
        POLYNOMIAL_GCRC24B = [24, 23, 6, 5, 1, 0];
        POLYNOMIAL_GCRC16 = [16, 12, 5, 0];
    end
    
    properties(Access=private)
        encoder
        decoder
    end
    
    methods
        function obj = CrcCodec(crcType)
            switch crcType
                case lte.CrcCodec.GCRC24A
                    polynomial = zeros(1, 25);
                    polynomialPowers = lte.CrcCodec.POLYNOMIAL_GCRC24A;
                case lte.CrcCodec.GCRC24B
                    polynomial = zeros(1, 25);
                    polynomialPowers = lte.CrcCodec.POLYNOMIAL_GCRC24B;
                case lte.CrcCodec.GCRC16;
                    polynomial = zeros(1, 17);
                    polynomialPowers = lte.CrcCodec.POLYNOMIAL_GCRC16;
                otherwise
                    error('Unknown CRC type');
            end
            
            polynomial(polynomialPowers + 1) = 1;
            
            obj.encoder = crc.generator(polynomial);
            obj.decoder = crc.detector(obj.encoder);
        end
        
        function codeBlock = encode(obj, transportBlock)
            transportBlock = transportBlock';
            codeBlock = obj.encoder.generate(transportBlock);
            codeBlock = codeBlock';
        end
        
        function [transportBlock isError] = decode(obj, codeBlock)
            codeBlock = codeBlock';
            [transportBlock isError] = obj.decoder.detect(codeBlock);
            transportBlock = transportBlock';
            isError = isError';
        end
    end
    
end

