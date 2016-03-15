function A = steeringVector(anglesRadString, antennasPositionsString)

A = exp(1i*2*pi*bsxfun(@times, sin(anglesRadString), antennasPositionsString'));

end