function noisePower = evaluateNoisePower(snrDb)
    noisePower = 1/(10^(snrDb/10));
end