function test_suite = testOfdmModulation()
initTestSuite;
end

function testOfdmModulationBase()

freqDomainSignal = fft( [1 4; 2 3 ; 3 2; 4 1]);

modulation = OfdmModulation(2);
outSignal = modulation.modulate(freqDomainSignal);

assertEqual([3 4   1 2 3 4       2 1    4 3 2 1], outSignal/2);

assertEqual(freqDomainSignal, modulation.demodulate(outSignal));

end

function testMeanPowerPreserved()

qamSource = SignalSource(1, SignalSource.TYPE_QPSK);
qamSignal = qamSource.getSignal([1, 1000]);
assertTrue(powerSignalMean(qamSignal) < 1.1 && powerSignalMean(qamSignal) > 0.9);

ofdmModulation = OfdmModulation(4);

ofdmTimeDomainSignal = ofdmModulation.modulate(reshape(qamSignal, 8, []));

meanPower = powerSignalMean(ofdmTimeDomainSignal);
assertTrue(meanPower < 1.1 && meanPower > 0.9);

ofdmRestoredSignal = ofdmModulation.demodulate(ofdmTimeDomainSignal);

meanPower = powerSignalMean(reshape(ofdmRestoredSignal, 1, []));
assertTrue(meanPower < 1.1 && meanPower > 0.9);


end

