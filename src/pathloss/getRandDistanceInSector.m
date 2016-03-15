function distance = getRandDistanceInSector( nUsers, maxDistance, sectorAngleDeg )

x = [];
y = [];
goodPoints = [];

while length(find(goodPoints)) < nUsers
    
    x = [x, maxDistance*rand(2.5*nUsers, 1)];
    y = [y, 2*pi*maxDistance*rand(2.5*nUsers, 1)];

    goodPoints = y < 2*pi*x;
    
end

distance = x(1:nUsers);
