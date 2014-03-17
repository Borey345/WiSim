function out = qam64SoftDemod1( in )

if in > 6
    out = 4*( in -3 );
    return;
end
if in > 4
    out = 3*( in - 2 );
    return;
end
if in > 2
    out = 2*( in - 1 );
    return;
end
if in >= -2
    out = in;
    return;
end
if in >= -4
    out = 2*( in + 1 );
    return;
end
if in >= -6
    out = 3*( in + 2 );
    return;
end
out = 4*( in + 3 );