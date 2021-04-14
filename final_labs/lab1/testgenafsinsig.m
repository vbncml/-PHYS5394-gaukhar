%% Plot the AM-FM sinusoid signal
% Signal parameters
f0 = 70;
f1 = 10;
f2 = 5;
A = 10;
b = 2;
% Instantaneous frequency after 1 sec is 
maxFreq = f0+b*f1;
% 5 times the Nyquist sampling frequency
samplFreq = 5*maxFreq;
samplIntrvl = 1/samplFreq;

% Time samples
timeVec = 0:samplIntrvl:1.0;
% Number of samples
nSamples = length(timeVec);
P = struct('b',b,'freq0',f0,'freq1',f1,'freq2',f2);
% Generate the signal
sigVec = genafsinsig(timeVec,A,b,[f0,f1,f2]);
sigVec1 = genafsinsig_new(timeVec,A,P);
%Plot the signal 
figure;
plot(timeVec,sigVec,'Marker','.','MarkerSize',14);
figure;
plot(timeVec,sigVec1,'Marker','.','MarkerSize',14);
%Plot the periodogram
%--------------
%Length of data 
dataLen = timeVec(end)-timeVec(1);
%DFT sample corresponding to Nyquist frequency
kNyq = floor(nSamples/2)+1;
% Positive Fourier frequencies
posFreq = (0:(kNyq-1))*(1/dataLen);
% FFT of signal
fftSig = fft(sigVec);
% Discard negative frequencies
fftSig = fftSig(1:kNyq);

%Plot periodogram
figure;
plot(posFreq,abs(fftSig));
title("Periodogram of AM-FM sinusoid")
xlabel("Frequency (Hz)")
ylabel("FFT")
