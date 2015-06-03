antennas = 0:0.5:3.7;
R = correlationMatrix(8, antennas);
rank(R)
plot(antennas, real(R(:,1)))
hold on
R = correlationMatrix(0.1, antennas);
rank(R)
plot(antennas, real(R(:,1)), 'r')
R = correlationMatrix(188, antennas);
rank(R)
plot(antennas, real(R(:,1)), 'g')