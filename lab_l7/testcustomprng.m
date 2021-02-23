
% parameters to generate custom uniform distirbution between a and b
M = 10000;
a = -2;
b = 1;
% generate the pseudorandom numbers with uniform distribution using
% customrand function
r = customrand(M,a,b);
% intialize x  range for density function
x = linspace(a-2,b+2,M);
% create density function for uniform distribution between a and b
y = pdf('unif',x,a,b);
% plot pdf
figure
subplot(2,1,1)
plot(x,y)
title("PDF for uniform distribution between -2 and 1")
xlabel("X")
ylabel("PDF(X)")
% plot pseudorandom numbers uniformly distributed between a and b
subplot(2,1,2)
histogram(r,'normalization','pdf')
title("Histogram for uniform distribution between -2 and 1")
xlabel("X")
ylabel("PDF(X)")


% parameters to generate custom normal distirbution with sigma and mu given
M = 10000;
sigma = 1.5;
mu = 2;
% generate the pseudorandom numbers with normal distribution using
% custonrand function
r = customrandn(M,sigma,mu);
% intialize x  range for density function
x = linspace(sigma-5.5,mu+5,M);
% create density function for normal distribution with mu and sigma given
y = pdf('norm',x,sigma,mu);
% plot pdf
figure
subplot(2,1,1)
plot(x,y)
title("PDF for normal distribution with sigma = 1.5 and mu = 2")
xlabel("X")
ylabel("PDF(X)")
% plot pseudorandom numbers normaly distibuted with mu and sigma given
subplot(2,1,2)
histogram(r,'normalization','pdf')
title("Histogram for normal distribution with sigma = 1.5 and mu = 2")
xlabel("X")
ylabel("PDF(X)")
