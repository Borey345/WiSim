function powers = channelPowerForDemappedSignal( H, modulationType, size )

out( 1:6, : ) = H( 7:12, : );
out( 7:12, : ) = H( 14:19, : );
out( 13:18, : ) = H( 20:25, : );
out( 19:24, : ) = H( 27:32, : );
out( 25:30, : ) = H( 33:38, : );
out( 31:36, : ) = H( 40:45, : );
out( 37:42, : ) = H( 46:51, : );
out( 43:48, : ) = H( 53:58, : );

out = abs(out).^2;

switch modulationType
    case 1;
    case 2
        out = [out, out];
    case 4
        out = [out, out, out, out];
    case 6
        out = [out, out, out, out, out, out];
end

powers1 = reshape( out', 1, [] );

powers = [];

for i=1:size/(48)
    powers = [powers, powers1];
end