function R = correlationMatrix( angularSpread, antennasPositions )
x = angularSpread*4;
x = -x:(x/1000):x;
power = pdf('norm', x, 0, angularSpread);

A = bsxfun(@times, sqrt(power)', steeringVector(x*pi/180, antennasPositions));
R = A'*A;
R = R/R(1,1);

end

