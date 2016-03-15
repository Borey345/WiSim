function R = channelCovarianceMatrix( angularSpread_deg, antennasPositions, meanAoA_deg_optional)
x = angularSpread_deg*4;
x = -x:(x/1000):x;
power = pdf('norm', x, 0, angularSpread_deg);

A = bsxfun(@times, sqrt(power), steeringVector(x*pi/180, antennasPositions));
R = A*A';
R = R/R(1,1);
if nargin > 2
    meanSteeringVector = diag(steeringVector(meanAoA_deg_optional*pi/180, antennasPositions));
    R = meanSteeringVector*R*meanSteeringVector';
end

end

