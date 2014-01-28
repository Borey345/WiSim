%%
clear

N_SUBCARRIERS = 64;
N_SAMPLES = 100;
in_ofdm = randi( [ 0, 255 ], [N_SUBCARRIERS, N_SAMPLES] );
inOfdmBin = convertToBin( in_ofdm );
ofdm = ofdmSignal( inOfdmBin );

ofdmPowers = abs( ofdm ).^2;
PAPR_OFDM = max( ofdmPowers )/mean( ofdmPowers );

out_ofdm = ofdmReciever( ofdm, N_SUBCARRIERS );
out_ofdm = round( real( out_ofdm ) );
out_ofdm = convertToDec( out_ofdm );

test = in_ofdm - out_ofdm;
max( max( test ) )
min( min( test ) )

%%

Q = 8;

in_scfdma = randi( [0, 255], [1, N_SUBCARRIERS*N_SAMPLES] );
inScBin = convertToBin( in_scfdma );

subcarriers = ofdmReciever( inScBin', N_SUBCARRIERS );
distributedMapping = zeros( Q*N_SUBCARRIERS, 8*N_SAMPLES );

for i = 1:N_SUBCARRIERS
    distributedMapping( (i-1)*Q + 1, : ) = subcarriers( i, : );
end

scSignalDistributed = ofdmSignal( distributedMapping );
distributedPowers = abs( scSignalDistributed ).^2;

PAPR_DISTRIBUTED = max( distributedPowers )/mean( distributedPowers );

localisedMapping = [subcarriers;zeros( (Q-1)*N_SUBCARRIERS, 8*N_SAMPLES )];


scSignalLocalised = ofdmSignal( localisedMapping );
localisedPowers = abs( scSignalLocalised ).^2;

PAPR_LOCALISED = max( localisedPowers )/mean( localisedPowers );
%_______________________________________________________________________
recievedDistributed = ofdmReciever( scSignalDistributed, Q*N_SUBCARRIERS );
subcarriersDistributed = zeros( N_SUBCARRIERS, 8*N_SAMPLES );
for i = 1:N_SUBCARRIERS
    subcarriersDistributed( i, : ) = recievedDistributed( (i-1)*Q + 1, : );
end 

recievedBin = ofdmSignal( subcarriersDistributed );

recievedBin = round( real( recievedBin ) );
recievedDec = convertToDec( recievedBin' );

test = in_scfdma - recievedDec;
max( max( test ) )
min( min( test ) )