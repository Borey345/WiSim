function out = limits( in )

out = floor( (7/2)*( real( in ) + 1 ) + 0.5 );
for i=1:size( in, 2 )
    if out(i) > 7
        out(i) = 7;
    else if out(i) < 0
            out(i) = 0;
        end
    end
end