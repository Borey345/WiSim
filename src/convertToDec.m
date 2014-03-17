function out = convertToDec( in )

nSamples = size( in, 2 )/8;
nSubcarriers = size( in, 1 );
out = zeros( nSubcarriers, nSamples );

for sample=1:nSamples
    out(:, sample) = bin2dec( num2str( in( :, (1:8)+(8*(sample-1)) ) ) );
end