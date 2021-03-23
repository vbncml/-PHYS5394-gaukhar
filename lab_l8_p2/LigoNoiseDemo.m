%% Demo for LIGO noise generation
%Sampling frequency for noise realization
sampFreq = 2*9412.3; %Hz
%Number of samples to generate
nSamples = 16384;
%Time samples
timeVec = (0:(nSamples-1))/sampFreq;

% Read data 
psdVals = load('iLIGOSensitivity.txt','-ascii');

%Target PSD given by the inline function handle
%targetPSD = @(f) (f>=50 & f<=700).*(f-50).*(700-f)/10000;


%Plot PSD
freqVec = reshape(psdVals(:,1),1,97);
psdVec = reshape(psdVals(:,2),1,97);
plot(log(freqVec),log(psdVec));
title("Frequency vs PSD")
xlabel('Frequency (Hz)');
ylabel('PSD');

%%
% Design FIR filter with T(f)= square root of target PSD
% sqrtPSD = sqrt(psdVec);
fltrOrdr = 500;

freqVec = [0.0 freqVec];
sqrtPSD = [0.0 psdVec];
f = freqVec/(sampFreq/2);
b = fir2(fltrOrdr,f,sqrtPSD);

%%
% Generate a WGN realization and pass it through the designed filter
% (Comment out the line below if new realizations of WGN are needed in each run of this script)
% rng('default'); 
inNoise = randn(1,nSamples);
outNoise = fftfilt(b,inNoise);

[pxx,f]=pwelch(outNoise, 256,[],[],sampFreq);
figure;
plot(f,pxx);
title("Frequency vs PSD")
xlabel('Frequency (Hz)');
ylabel('PSD');
% Plot the LIGO noise realization
figure;
plot(timeVec,outNoise);
title("LIGO noise realization")
xlabel('Time (s)');
ylabel('Signal');

%Plot the histogram
figure;
histogram(outNoise,'Normalization','pdf')
title('Histogram of the nosie realization')