function out = deinterleaver( in, modulation, nSubcarriers )

nCodedBitsPerSimbol = nSubcarriers*modulation;

in = reshape( in, nCodedBitsPerSimbol, [] );
out = zeros( nCodedBitsPerSimbol, size( in, 2 ) );

%if modulation > 2
    s = max( modulation/2, 1 );
    for j=0:nCodedBitsPerSimbol-1
        out( ( s*floor( j/s ) + mod( ( j + ...
            floor( 16*j/nCodedBitsPerSimbol ) ), s ) ) + 1, : ) = in( j+1, : );
    end
% else
%     in = out;
% end

for i=0:nCodedBitsPerSimbol-1
    in( (16*i - (nCodedBitsPerSimbol-1)*...
        floor(16*i/nCodedBitsPerSimbol ) ) + 1, : ) = out( i + 1, : );
end

out = reshape( in, 1, [] );