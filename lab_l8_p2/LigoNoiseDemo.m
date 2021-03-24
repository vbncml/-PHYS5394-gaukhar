%% Demo for LIGO noise generation
%Sampling frequency for noise realization
sampFreq = 2*9412.34; %Hz
%Number of samples to generate
nSamples = 16384;
%Time samples
timeVec = (0:(nSamples-1))/sampFreq;

% Read data 
psdVals = load('iLIGOSensitivity.txt','-ascii');



%Plot PSD
freqVec = reshape(psdVals(:,1),1,97);
psdVec = reshape(psdVals(:,2),1,97);
plot(log(freqVec),log(psdVec));
title("Frequency vs PSD")
xlabel('Frequency (Hz)');
ylabel('PSD');

% Design FIR filter with T(f)= square root of target PSD

fltrOrdr = 500;

freqVec = [0.0 freqVec];
sqrtPSD = [0.0 psdVec];

%apply f <= 50 => s(f) = s(50) and f >= 700 => s(f) = s(700)
idx_50 = find(round(freqVec)==50);
idx_700 = find(round(freqVec)==653);

psdVec(1:idx_50) = psdVec(idx_50);
psdVec(idx_700:end) = psdVec(idx_700);

f = freqVec/(sampFreq/2);
b = fir2(fltrOrdr,f,sqrtPSD);


% Generate a WGN realization and pass it through the designed filter

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
