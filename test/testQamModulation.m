function test_suite = testQamModulation()
initTestSuite;
end

function testNonRegressionBpsk()
commonQam(QamModulation.MODULATION_BPSK, 1, [0.29 0.91 1.91]);
end

function testNonRegressionQpsk()
commonQam(QamModulation.MODULATION_QPSK, 2, [0.29 0.91 1.91]);
end

function testNonRegression16Qam()
commonQam(QamModulation.MODULATION_16QAM, 4, [0.29 0.91 1.91]);
end

function testNonRegression64Qam()
commonQam(QamModulation.MODULATION_64QAM, 6, [0.29 0.91 1.91]);
end

function test16QamPerformance()
tic;
source = SignalSource(0, SignalSource.TYPE_BIT);
setRandomSeed(20);

signal = source.getSignal([1, 12000000]);

modulatorNew = QamModulation(QamModulation.MODULATION_16QAM);
modulatedSignalNew = modulatorNew.modulate(signal);
modulatorNew.demodulate(modulatedSignalNew, 0.5);
elapsedTime = toc;
assertTrue(elapsedTime < 4);
end

function test64QamPerformance()
tic;
source = SignalSource(0, SignalSource.TYPE_BIT);
setRandomSeed(20);

signal = source.getSignal([1, 1200000]);

modulatorNew = QamModulation(QamModulation.MODULATION_64QAM);
modulatedSignalNew = modulatorNew.modulate(signal);
modulatorNew.demodulate(modulatedSignalNew, 0.5);
elapsedTime = toc;
assertTrue(elapsedTime < 1);
end


function commonQam(modulationType, bitsPerSymbol, channelEstimation, nBits)

    if nargin < 4
        nBits = (2^10)*bitsPerSymbol;
    end
    
    source = SignalSource(0, SignalSource.TYPE_BIT);
    setRandomSeed(20);

    signal = source.getSignal([1, nBits]);
    
    modulatorNew = QamModulation(modulationType);
    modulatedSignalNew = modulatorNew.modulate(signal);
    
    load(sprintf('test/files/testQamModulation/nonRegressionModulation_%d', modulationType));
    assertEqual(modulatedSignalBase, modulatedSignalNew);

    noiseSource = SignalSource(1, SignalSource.TYPE_GAUSS);
    noise = noiseSource.getSignal(size(modulatedSignalNew));
    
    
    modulatedSignalPlusNoiseNew = modulatedSignalNew + noise;

    for iChannel = 1:length(channelEstimation)

        demodulatedSignalNew = modulatorNew.demodulate(modulatedSignalNew, channelEstimation(iChannel));
        demodulatedSignalPlusNoiseNew = modulatorNew.demodulate(modulatedSignalPlusNoiseNew, channelEstimation(iChannel));
        
        load(sprintf('test/files/testQamModulation/nonRegression_%d_%d', modulationType, iChannel));
        load(sprintf('test/files/testQamModulation/nonRegressionNoise_%d_%d', modulationType, iChannel));


        assertEqual(demodulatedSignalBase, demodulatedSignalNew);
        assertEqual(demodulatedSignalPlusNoiseBase, demodulatedSignalPlusNoiseNew);
    end
end
