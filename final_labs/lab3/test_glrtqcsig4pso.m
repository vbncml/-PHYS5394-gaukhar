% Path to folder containing signal and noise generation codes.
addpath ../../SIGNALS
addpath ../../NOISE
addpath('/Users/gokha/Desktop/spring2021/stat_meth/SDMBIGDAT19/CODES')
addpath('/Users/gokha/Desktop/spring2021/stat_meth/DATASCIENCE_COURSE/DETEST')
%% Parameters for data realization
% Number of samples and sampling frequency.
nSamples = 2048;
sampFreq = 1024;
timeVec = (0:(nSamples-1))/sampFreq;

%% Supply PSD values
% This is the noise psd we will use.
noisePSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000 + 1;
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
psdPosFreq = noisePSD(posFreq);

%% Generate  data realization
% Noise + SNR=10 signal. 
a1=9.5;
a2=2.8;
a3=3.2;
A=10;
noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
sig4data = crcbgenqcsig(timeVec,A,[a1,a2,a3]);
% Signal normalized to SNR=10
[sig4data,~]=normsig4psd(sig4data,sampFreq,psdPosFreq,10);
dataVec = noiseVec+sig4data;

%% Create an array of arrays A for a1 between 1 and 19
a1_min = 1;
a1_max = 19;
A = linspace(a1_min,a1_max,nSamples);
a2_min = 1;
a2_max = 6;
a3_min = 1;
a3_max = 7;
rmin = [a1_min a2_min a3_min];
rmax = [a1_max a2_max a3_max];
%% Create matrix X
x = zeros(nSamples,3);
x(:,1) = (A-a1_min)./(a1_max-a1_min);
x(:,2) = (a2 - a2_min)/(a2_max-a2_min);
x(:,3) = (a3 - a3_min)/(a3_max-a3_min);


%% Apply fitness function glrtqc4pso
% The fitness function called is glrtqc4pso. 
ffparams = struct('rmin',rmin,...
                     'rmax',rmax, ...
                     'dataX',timeVec, ...
                     'dataXSq',timeVec.^2, ...
                     'dataXCb',timeVec.^3, ...
                     'dataY',dataVec,...
                     'psdPosFreq',psdPosFreq, ...
                     'sampFreq',sampFreq ...
                  );
%% Plot A against Fitness values

figure
plot(A,glrtqcsig4pso(x,ffparams));
ylabel('Fitness value')
xlabel('A')
title('A vs Fintess value, a1 = 9.5')



