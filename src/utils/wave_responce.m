function responce = wave_responce( frequency_column, delays_row, tap_coefficients_row )

tap_phase = exp( 1i*2*pi*bsxfun( @times, delays_row, frequency_column ) );
responce = sum( bsxfun(@times, tap_coefficients_row, tap_phase),2);

end

