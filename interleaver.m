function out = interleaver( in, modulation, nSubcarriers )

%nSubcarriers = 48;
nCodedBitsPerSimbol = nSubcarriers*modulation;

in = reshape( in, nCodedBitsPerSimbol, [] );
out = zeros( nCodedBitsPerSimbol, size( in, 2 ) );

for k=0:nCodedBitsPerSimbol-1
    out( ( (nCodedBitsPerSimbol/16)*mod( k, 16 )+ floor( k/ 16 ) ) + 1, : ) = in( k + 1, : );
end

s = max( modulation/2, 1 );

if modulation > 2

    for i=0:nCodedBitsPerSimbol-1
        in( ( s*floor( i/s ) + mod( ( i + nCodedBitsPerSimbol - ...
            floor( 16*i/nCodedBitsPerSimbol ) ), s ) ) + 1, : ) = out( i+1, : );
    end
else
    in = out;
    
end

out = reshape( in, 1, [] );
