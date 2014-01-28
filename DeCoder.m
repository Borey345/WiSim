function out = decoder( in )
trellis = poly2trellis( 7, [133, 171] );
out = vitdec( in, trellis, 35, 'trunc', 'soft', 3 );


