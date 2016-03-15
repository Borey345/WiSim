function realization = uniform( minVal, maxVal, size )

realization = (maxVal-minVal)*rand(size) + minVal;

end

