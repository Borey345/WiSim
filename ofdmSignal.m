function out = ofdmSignal( in )
nSamples = size( in, 2 );
nSubcarriers = size( in, 1 );

out = zeros( nSamples*nSubcarriers, 1 );

for sample=1:nSamples
    for n = 1:nSubcarriers
        accumulator = 0;
        for k = 1:nSubcarriers
            accumulator = accumulator + in(k, sample)*...
                exp( (-1i*2*pi*n*k)/(nSubcarriers) );
        end
        out( nSubcarriers*(sample-1) + n ) = accumulator;
    end
end
out = (1/nSubcarriers)*out;
