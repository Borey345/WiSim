function out = demapper( in )

out( 1:6, : ) = in( 7:12, : );
out( 7:12, : ) = in( 14:19, : );
out( 13:18, : ) = in( 20:25, : );
out( 19:24, : ) = in( 27:32, : );
out( 25:30, : ) = in( 33:38, : );
out( 31:36, : ) = in( 40:45, : );
out( 37:42, : ) = in( 46:51, : );
out( 43:48, : ) = in( 53:58, : );

out = reshape( out, 1, [] );