function snir = evaluateSnir(signal, interference,  noise)
snir = signalPower(signal)/(signalPower(noise) + signalPower(interference));
end