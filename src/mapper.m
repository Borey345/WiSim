function out = mapper( in, nSubcarriers )

out = reshape( in, nSubcarriers, [] );

nSymbols = size( out, 2 );

pilot = ones( 1, nSymbols );

tmpOut( 1:6, : ) = zeros( 6, nSymbols );    %6 protected
tmpOut( 7:12, : ) = out( 1:6, : );          %6 data
tmpOut( 13, : ) = pilot;                    %1 pilot
tmpOut( 14:25, : ) = out( 7:18, : );        %12 data
tmpOut( 26, : ) = pilot;                    %1 pilot
tmpOut( 27:38, : ) = out( 19:30, : );       %12 data
tmpOut( 39, : ) = pilot;                    %1 pilot
tmpOut( 40:51, : ) = out( 31:42, : );       %12 data
tmpOut( 52, : ) = pilot;                    %1 pilot
tmpOut( 53:58, : ) = out( 43:48, : );          %6 data
tmpOut( 59:64, : ) = zeros( 6, nSymbols );    %6 protected

out = tmpOut;