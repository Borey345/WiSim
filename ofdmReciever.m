function out = ofdmReciever( in, nSubcarriers )
nSamples = size( in, 1 )/nSubcarriers;
out = zeros( nSubcarriers, nSamples );

for sample=1:nSamples
    for m = 1:nSubcarriers
        accumulator = 0;
        for n = 1:nSubcarriers
            accumulator = accumulator + in(nSubcarriers*(sample-1) + n)*...
                exp( (1i*2*pi*n*m)/(nSubcarriers) );
        end
        out( m, sample ) = accumulator;
    end
end
%out = (1/nSubcarriers)*out;