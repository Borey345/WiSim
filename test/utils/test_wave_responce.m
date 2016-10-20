function test_wave_responce()

freq_limit = 200;
freq_step = 3e3;
lambda = 1e4;

frequency_column = (  2e9 + ((-freq_limit*freq_step):freq_step:(freq_limit*freq_step) ) ).';
delays_row = [0, 0.5e-6 1e-6 3e-6];
tap_coefficients_row = exp(-lambda*delays_row);
responce = wave_responce( frequency_column, delays_row, tap_coefficients_row );

figure
plot(frequency_column, abs(responce))


frequency_column = 2e9;
delays_row = [0, 0.5e-6, 1e-6];

time_array = 1:20000;

responce = zeros(1, length(time_array));
for t=time_array
    
    tap_coefficients_row = [ exp(2i*pi*t/1000) exp(2i*pi*t/2000) exp(2i*pi*t/5000)];
    responce(t) = wave_responce( frequency_column, delays_row, tap_coefficients_row );
end

figure
plot(time_array, abs(responce).^2)


end

