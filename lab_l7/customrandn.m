function r = customrandn(N,sigma,mu)
% Generate normally distributed pseudorandom numbers.
% r = customrand(N,sigma,mu)
% return N by N matrix with pseudorandom values normaly distirvuted with a
% given sigma and mu values

%Gaukhar Nurbek, Feb 2021       
r = sigma.*randn(N,1)+mu;
end

