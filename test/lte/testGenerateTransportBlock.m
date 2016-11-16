function test_suite = testGenerateTransportBlock()
initTestSuite;
end

function testGeneration()

    tb = lte.generateTransportBlocks(0, 1, 2);
    assertEqual([2, 16], size(tb));
    
    tb = lte.generateTransportBlocks(10, 5, 3);
    assertEqual([3, 776], size(tb));
    
    tb = lte.generateTransportBlocks(17, 25, 4);
    assertEqual([4, 7736], size(tb));
    
    tb = lte.generateTransportBlocks(28, 110, 5);
    assertEqual([5, 73712], size(tb));

end
