function [ values ] = randr( arrSize )
%RANDR Returns random complex numbers with Reyleigh distribution
%   
values = randn(arrSize) + 1i*randn(arrSize);


end

