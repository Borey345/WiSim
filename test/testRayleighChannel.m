function test_suite = testRayleighChannel()
initTestSuite;
end

function testNonRegression()
s = RandStream('mt19937ar','Seed',1);
RandStream.setGlobalStream(s);

channel = RayleighChannel(2);
signal = rand(1, 100);
out = channel.process(signal);
fileName = 'test/files/testRayleighChannelTestNonRegression';
% save( fileName, 'out');
outExpected = load( fileName );
assertEqual(outExpected.out, out);
end

function testMultipleChannelsPerAntenna()
s = RandStream('mt19937ar','Seed',1);
RandStream.setGlobalStream(s);

channel = RayleighChannel(2);
signal = rand(1, 100, 3);
out = channel.process(signal);
fileName = 'test/files/testRayleighChannelTestMultipleChannelsPerAntenna';
% save( fileName, 'out');
assertEqual([2 100 3], size(out));
outExpected = load( fileName );
assertEqual(outExpected.out, out);
end