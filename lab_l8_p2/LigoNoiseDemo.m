%% Demo for LIGO noise generation
%Sampling frequency for noise realization
sampFreq = 4096; %Hz
%Number of samples to generate
nSamples = 4096*60;
%Time samples
timeVec = (0:(nSamples-1))/sampFreq;

% Read data 
psdVals = load('iLIGOSensitivity.txt','-ascii');

%Plot log(sqrtPSD) of data
freqVec = reshape(psdVals(:,1),1,97);
psdVec = reshape(psdVals(:,2),1,97);
%SDM: log(x) in Matlab means log to the base e, not log to the base 10
figure;
loglog(freqVec,psdVec);
hold on;
title("sqrtPSD vs Frequency")
xlabel('Frequency (Hz)');
ylabel('sqrtPSD)');

% add f= 0 and psd(f=0) to the data
freqVec = [0.0 freqVec];
sqrtPSD = [0.0 psdVec];

% apply f <= 50 => s(f) = s(50) and f >= 700 => s(f) = s(700)
%SDM: Avoid hard coding in variable names
idx_low = find(round(freqVec)<=40, 1, 'last' );
idx_high = find(round(freqVec)<=700, 1, 'last');

sqrtPSD(1:idx_low) = sqrtPSD(idx_low);
sqrtPSD(idx_high:end) = sqrtPSD(idx_high);
loglog(freqVec,sqrtPSD);

%SDM: Truncate to Nyquist frequency given by the sampling frequency
idx_fs = find(freqVec >= sampFreq/2);
freqVec(idx_fs)=[];
sqrtPSD(idx_fs)=[];
%Add sampling frequency to the frequency vector if it is not present
if freqVec(end) ~= sampFreq/2
    freqVec = [freqVec,sampFreq/2];
    sqrtPSD = [sqrtPSD, sqrtPSD(end)];
end
loglog(freqVec,sqrtPSD,'o');
legend('Supplied sensitivity', 'Modified sensitivity','Truncated sensitivity');


% design filter 
fltrOrdr = 8192;
f_norm = freqVec/(sampFreq/2);
b = fir2(fltrOrdr,f_norm,sqrtPSD);


% Generate a WGN realization and pass it through the designed filter

inNoise = randn(1,nSamples);
outNoise = fftfilt(b,inNoise);

% Plot the LIGO noise PSD vs frequency
%SDM: frequency resolution for plotting PSD of LIGO noise should typically be 1 Hz or better 
[pxx,f]=pwelch(outNoise(fltrOrdr:end), sampFreq,[],[],sampFreq);
figure;
loglog(f,sqrt(pxx));
title("PSD vs Frequency of LIGO noise")
xlabel('Frequency (Hz)');
ylabel('PSD');
% Plot the LIGO noise realization
figure;
plot(timeVec,outNoise);
title("LIGO noise realization")
xlabel('Time (s)');
ylabel('Signal');
