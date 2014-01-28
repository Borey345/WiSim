function out = qam64SoftDemod2( in )

in = abs( in );
if in > 6
    out = 2*( -in + 5 );
    return;
end
if in > 2
    out = 4 - in;
    return
end
out = 2*( -in + 3 );