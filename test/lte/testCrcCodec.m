function test_suite = testCrcCodec()
    initTestSuite;
end

function testGcrc24A()
generalCheck(lte.CrcCodec.GCRC24A, 24);
end

function testGcrc24B()
generalCheck(lte.CrcCodec.GCRC24B, 24);
end

function testGcrc16()
generalCheck(lte.CrcCodec.GCRC16, 16);
end

function testSeveralTransportBlocks()
generalCheck(lte.CrcCodec.GCRC24A, 24, 8);
end

function generalCheck(crcType, crcLength, nTb)

    if nargin < 3
        nTb = 1;
    end
    
    codec = lte.CrcCodec(crcType);
    generator = SignalSource(1, SignalSource.TYPE_BIT);
    bitStream = generator.getSignal([nTb, 256]);
    
    encodedMsg = codec.encode(bitStream);
    
    assertEqual([nTb, 256+crcLength], size(encodedMsg));
    
    [decodedMsg isError] = codec.decode(encodedMsg);
    
    assertEqual(bitStream, decodedMsg);
    assertEqual(false([nTb, 1]), isError);
    
    encodedMsg(:,25) = ~encodedMsg(:,25);
    
    [~, isError] = codec.decode(encodedMsg);

    assertEqual(true([nTb, 1]),isError);
    
end

