function pathloss = getRandPathlossInSector( nUsers, maxDistance, sectorAngleDeg )

if nargin < 3
    sectorAngleDeg = 60;
end

distance = getRandDistanceInSector(nUsers, maxDistance, sectorAngleDeg);
pathloss = getPathlossMicro(distance);

end

