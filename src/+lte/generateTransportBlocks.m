function transportBlocks = generateTransportBlocks( mcs, nRb, nTransportBlocks)

tbTables = load('src/+lte/transportBlockTables');

tbsIndex = tbTables.modulationOrderIndex(mcs+1, 2) + 1;

tbSize = tbTables.transportBlockSizeTable(tbsIndex, nRb);

if tbSize > 6144
    error('This transport block size require code block segmentation which is not supported yet');
end

generator = SignalSource(1, SignalSource.TYPE_BIT);

transportBlocks = generator.getSignal([nTransportBlocks, tbSize]);

end

