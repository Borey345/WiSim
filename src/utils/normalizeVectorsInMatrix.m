function M = normalizeVectorsInMatrix( M, dimension )
if nargin < 2
    dimension = 1;
end
M = bsxfun(@rdivide, M, sqrt(sum(M.*conj(M), dimension)));

end

