function out = convertToBin( in )

nSubcarriers = size( in, 1 );
nSamples = size( in, 2 );

out = zeros( nSubcarriers, 8*nSamples );

for carrier = 1:nSubcarriers
    tmp = dec2bin( in( carrier, : ), 8 );
    out( carrier, : ) = reshape( tmp', 1, 8*nSamples );
end
out = out - 48;
