function A = steeringVector(anglesRadString, antennasPositionsString)

A = exp(1i*2*pi*sin(anglesRadString')*antennasPositionsString);

end