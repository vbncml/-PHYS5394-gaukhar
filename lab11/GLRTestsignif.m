%% Calculate GLRT for Quadratic chirp signal 
% Generalized Likelihood ratio test (GLRT) for a quadratic chirp when only
% the amplitude is unknown.

%%
% We will reuse codes that have already been written.
% Path to folder containing signal and noise generation codes.
addpath ../../DATASCIENCE_COURSE/SIGNALS
addpath ../../DATASCIENCE_COURSE/NOISE


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

%% Read each of 3 data realzations

dataVec1 = load('data1.txt');
dataVec1 = reshape(dataVec1,1,length(dataVec1));
dataVec2 = load('data2.txt');
dataVec2 = reshape(dataVec2,1,length(dataVec2));
dataVec3 = load('data3.txt');
dataVec3 = reshape(dataVec3,1,length(dataVec3));

%% Calculate GRLT for 3 data realizations
%  
a1=10;
a2=3;
a3=3;

glrt1 = glrtqcsig(dataVec1,psdPosFreq,a1,a2,a3);
glrt2 = glrtqcsig(dataVec2,psdPosFreq,a1,a2,a3);
glrt3 = glrtqcsig(dataVec3,psdPosFreq,a1,a2,a3);

%% Estimate significance of each of 3 GLRTs
%Obtain GLRT values for multiple noise realizations and count number of
%times glrt n >= obtained GLRT for n = 1,2,3
nH0Data = 10000;
nGlrts = zeros(1,3);
for n = 1:nH0Data
    noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
    GLRT = glrtqcsig(noiseVec,psdPosFreq,a1,a2,a3);
    if glrt1 <= GLRT
        nGlrts(1) = nGlrts(1) +1;
    end
    if glrt2 <= GLRT
        nGlrts(2) = nGlrts(2) +1;
    end
    if glrt3 <= GLRT
        nGlrts(3) = nGlrts(3) +1;
    end
end

% calculate significance
glrt_signif_1 = nGlrts(1)/nH0Data; 
glrt_signif_2 = nGlrts(2)/nH0Data; 
glrt_signif_3 = nGlrts(3)/nH0Data; 
