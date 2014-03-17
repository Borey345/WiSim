function out = qam64SoftDemod3( in )

in = abs( in );
if in > 4
    out = -in + 6;
    return
end
out = in - 2;