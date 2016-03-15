function [ pathloss ] = getPathlossMicro( distance )

pathloss = 34.53 + 38*log10(distance);

end

