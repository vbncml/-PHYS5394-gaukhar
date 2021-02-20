% Plot the AM-FM sinusoid signal
% Signal parameters
f0 = 70;
f1 = 60;
f2 = 30;
A = 10;
b = 2;
% Instantaneous frequency after 1 sec is 
maxFreq = f0-b*f1*sin(2*pi*f1);
% 5 times the Nyquist sampling frequency
samplFreq = 5*maxFreq;
samplIntrvl = 1/samplFreq;
% ½ of the Nyquist sampling frequency
samplFreq_1 = 1/2*maxFreq;
samplIntrvl_1 = 1/samplFreq_1;

% Time samples
timeVec = 0:samplIntrvl:1.0;
timeVec_1 = 0:samplIntrvl_1:1.0;
% Number of samples
nSamples = length(timeVec);
nSamples_1 = length(timeVec_1)
% Generate the signal
sigVec = genafsinsig(timeVec,A,b,[f0,f1,f2]);
sigVec_1 = genafsinsig(timeVec_1,A,b,[f0,f1,f2]);

%Plot the periodogram
%--------------
%Length of data 
dataLen = timeVec(end)-timeVec(1);
dataLen_1 = timeVec_1(end)-timeVec_1(1);
%DFT sample corresponding to Nyquist frequency
kNyq = floor(nSamples/2)+1;
kNyq_1 = floor(nSamples_1/2)+1;
% Positive Fourier frequencies
posFreq = (0:(kNyq-1))*(1/dataLen);
posFreq_1 = (0:(kNyq_1-1))*(1/dataLen_1);
% FFT of signal
fftSig = fft(sigVec);
fftSig_1 = fft(sigVec_1);
% Discard negative frequencies
fftSig = fftSig(1:kNyq);
fftSig_1 = fftSig_1(1:kNyq_1);
%Plot periodogram
figure;
plot(posFreq,abs(fftSig));
title("Periodogram of AM-FM sinusoid with 5 times the Nyquist sampling frequenc")
xlabel("Frequency (Hz)")
ylabel("FFT")

figure;
plot(posFreq_1,abs(fftSig_1));
title("Periodogram of AM-FM sinusoid with 1/2 times the Nyquist sampling frequenc")
xlabel("Frequency (Hz)")
ylabel("FFT")
