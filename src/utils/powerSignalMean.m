function meanPower = powerSignalMean( signal )

meanPower = mean(signal.*conj(signal));

end

