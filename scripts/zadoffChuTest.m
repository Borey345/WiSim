%% zadoff chu test

M = 29;
N_zc = 63;
sequence = zadoffChu(M, N_zc);
isPunctured = 1;

autocorrelation = zeros(1, N_zc);

if isPunctured
    sequence(31) = 0;
end

lag = (1:N_zc) - ceil(N_zc/2);
for i = 1:N_zc
    autocorrelation(i) = circshift(sequence, [0, lag(i)])*sequence';
end
colors = ['b', 'r'];
plot(lag, abs(autocorrelation), colors(isPunctured+1) );
hold on

%%
M = 34;