function r = customrand(N,a,b)
% Generate uniformly distributed pseudorandom numbers.
% r = customrand(N,A,B)
% return N by N matrix with pseudorandom values uniformly distirbuted 
% between given A and B.

%Gaukhar Nurbek, Feb 2021    
r = a + (b-a).*rand(N,1);
end

