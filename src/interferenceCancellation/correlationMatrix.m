function R = correlationMatrix( randomProcesses )
%CORRELATIONMATRIX Evaluates a correlation matrix between input correlation
%processes
%  randomProcesses is a matrix of processes first dimension is a process
%  second is a sample

nSamples = size(randomProcesses,2);
R = (randomProcesses*randomProcesses')/nSamples;

end

