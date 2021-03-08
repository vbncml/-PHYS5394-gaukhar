% Demo of the white noise filter

% Read data
data = load('testData.txt');
% assign 1st column to timeVec and 2nd coulmn to the signalVec variables
timeVec = data(:,1);
signalVec = data(:,2);

% find number of samples and sample frequency of the dataset
nSamples = length(timeVec);
sampFreq = (nSamples-1)/max(timeVec);

% estimate the noise PSD for the first 5 s of the data
t = 0:1/sampFreq:5;
[pxx,f]=pwelch(signalVec(1:length(t)), 512,[],[],sampFreq);

% Design whitening filter 
fltrOrdr = 500;
freqVec = f;
b = fir2(fltrOrdr,freqVec/(sampFreq/2),pxx/6);

% pass data through the designed filter
outData = sqrt(sampFreq)*fftfilt(b,signalVec);

% Plot time series of Original and Whitened data
figure;
subplot(2,1,1);
plot(timeVec,signalVec);
title("Original signal")
xlabel('Time (s)');
ylabel('Signal');

subplot(2,1,2);
plot(timeVec,outData);
title("Whitened signal")
xlabel('Time (s)');
ylabel('Signal');

%Plot the spectrogram of Original and Whitened data
winLen = 0.8;%sec
ovrlp = 0.5;%sec
winLenSmpls = floor(winLen*sampFreq);
ovrlpSmpls = floor(ovrlp*sampFreq);
[S,F,T]=spectrogram(signalVec,winLenSmpls,ovrlpSmpls,[],sampFreq);
figure;
imagesc(T,F,abs(S)); axis xy;
title('Spectrogram of the signal')
xlabel('Time (sec)');
ylabel('Frequency (Hz)');

[S,F,T]=spectrogram(outData,winLenSmpls,ovrlpSmpls,[],sampFreq);
figure;
imagesc(T,F,abs(S)); axis xy;
title('Spectrogram of whitened signal')
xlabel('Time (sec)');
ylabel('Frequency (Hz)');