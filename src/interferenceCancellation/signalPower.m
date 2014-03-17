function p = signalPower(signal)
p = mean((abs(signal)).^2);
end