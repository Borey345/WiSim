classdef FecCodec < handle
    %FECCODEC Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        TRELLIS = uint8(...
            [0,4;
            4,0;
            5,1;
            1,5;
            2,6;
            6,2;
            7,3;
            3,7] + 1);

        OUT_TABLE = logical(...
            [0,1;...
            0,1;
            1,0;
            1,0;
            1,0;
            1,0;
            0,1;
            0,1]);

        OUT_TERMINATION = logical(...
            cat(3, [0 0; 0 0; 0 0], [1 0; 1 0; 0 0], [1 1; 0 0; 1 0], [0 1; 1 0; 1 0], ...
            [0 0; 1 1; 1 1], [1 0; 0 1; 1 1], [1 1; 0 1 ;0 1], [0 1; 0 1; 0 1]));
        
        INTERLEAVER_TABLE = lte.FecCodec.getInterleaverTable();
        
    end
    
    methods(Static)
        function outStream = encode(bitStream, redundancyVersion)
            [codedBits, trellisTermination] = lte.FecCodec.constituentEncoder(bitStream);
            interleavedBits = lte.FecCodec.interleave(bitStream);
            [codedInterleavedBits, interleavedTrellisTermination] = lte.FecCodec.constituentEncoder(interleavedBits);
            
            outStream = [bitStream; codedBits; codedInterleavedBits];
            outStream = [outStream, trellisTermination, interleavedTrellisTermination];
            
            % 5.1.4.1.1
            stream0 = lte.FecCodec.interleaveSubBlock(outStream(1,:));
            stream1and2 = [lte.FecCodec.interleaveSubBlock(outStream(2,:));
                           lte.FecCodec.interleaveSubBlock(outStream(3,:), 1)];
                
            % 5.1.4.1.2
            outStream = [ stream0, reshape(stream1and2, 1, [])];
        end
        
        function [outStream, termination] = constituentEncoder( bitStream )
            
            trellis = lte.FecCodec.TRELLIS;
            outTable = lte.FecCodec.OUT_TABLE;
            

            state = uint8(1);
            outStream = false(size(bitStream));
            column = uint8(bitStream)+uint8(1);

            for i=1:size(bitStream,2)
                outStream(i) = outTable(state, column(i));
                state = trellis(state, column(i));
            end

            termination = lte.FecCodec.OUT_TERMINATION(:,:, state);
        end
        
        function interleavedBits = interleave(bitStream)
            interleaverTable = lte.FecCodec.INTERLEAVER_TABLE;
           
            codeBlockSize = size(bitStream, 2);
            bitIndices = 0:codeBlockSize-1;
            
            idx = find(interleaverTable(:,1) == codeBlockSize, 1);
            
            if isempty(idx)
                error('Not supported code block size. Refer to 36.212 (8.10) - Table 5.1.3-3')
            end
            
            f1 = interleaverTable(idx,2);
            f2 = interleaverTable(idx, 3);
            
            interleavedIndices = mod(f1*bitIndices + f2*(bitIndices.^2), codeBlockSize);
            
            interleavedBits = bitStream(interleavedIndices + 1);
            
        end
        
        function interleaverTable = getInterleaverTable()
            interleaverTable = load('src/+lte/interleaverParameters');
            interleaverTable = interleaverTable.interleaverParameters;
        end
        
        function interleavedSequence = interleaveSubBlock(codedSequence, isStream2)
            D = uint32(size(codedSequence, 2));
            C_subblock = uint32(32);
            R_subblock = uint32(D/C_subblock)+1;
            
            N_D = R_subblock*C_subblock - D;
            
            y = [uint8(-1*ones(1, N_D)), uint8(codedSequence)];
            
            
            permutationPattern = uint32([0, 16, 8, 24, 4, 20, 12, 28, 2, 18, 10,...
                26, 6, 22, 14, 30, 1, 17, 9, 25, 5, 21, 13, 29, 3, 19, 11, ...
                27, 7, 23, 15, 31 ]) + 1;
            
            if nargin > 1 && isStream2
                
                K_n = uint32(size(y,2));
                indices = uint32(0:K_n-1);
                indices = mod( ( permutationPattern( idivide(indices, R_subblock, 'floor') + 1) + C_subblock*mod(indices, R_subblock)+1 ), K_n);
                interleavedSequence = y(indices+1);
            else
                y = reshape(y, R_subblock, C_subblock);
                y = y(:, permutationPattern);
                interleavedSequence = reshape(y, 1, []);
            end
        end

    end
    
end

