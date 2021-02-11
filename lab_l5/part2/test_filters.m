% Generate sum of three sinusoids signal and create filters

sampFreq = 1024;
nSamples = 2048;
timeVec = (0:(nSamples-1))/sampFreq;

% Signal parameters
A1=10;
A2=5;
A3=2.5;
f1_init = 100;
f2_init = 200;
f3_init = 300;
phi1 = 0;
phi2 = pi/6;
phi3 = pi/4;

% Generate the signal
s1 = gensinsig(timeVec,A1,f1_init,phi1);
s2 = gensinsig(timeVec,A2,f2_init,phi2);
s3 = gensinsig(timeVec,A3,f3_init,phi3);

sigVec = s1+s2+s3;

% Signal length
sigLen = (nSamples-1)/sampFreq;
%Maximum frequency
maxFreq = f1_init + f2_init + f3_init;

disp(['The maximum frequency of the sum of sinusoids is ', num2str(maxFreq)]);

% Allow s1 to pass through filter
% Design filter 1
filtOrdr = 30;
a = fir1(filtOrdr,(maxFreq - (f2_init + f3_init))/(maxFreq/2));

% Allow s2 to pass through filter
% Design filter 2
b = fir1(filtOrdr,(f2_init)/(maxFreq),'high');
b1 = fir1(filtOrdr,(f3_init)/(maxFreq),'stop');
% Allow s3 to pass through filter
% Design filter 3
c = fir1(filtOrdr,(maxFreq - (f1_init + f2_init))/(maxFreq),'high');

%FFT for input signal
%Length of data 
dataLen = timeVec(end)-timeVec(1);
%DFT sample corresponding to Nyquist frequency
kNyq = floor(nSamples/2)+1;
% Positive Fourier frequencies
posFreq = (0:(kNyq-1))*(1/dataLen);
% FFT of input signal
fftSig = fft(sigVec);
% Discard negative frequencies
fftSig = fftSig(1:kNyq);

%Apply filter and plot the periodogram for each filtered signal

for i = 1:3
    if (i == 1)
        % Apply filter 1
        filtSig = fftfilt(a,sigVec);
    end
    if (i == 2)
        % Apply filter 2
        filtSig = fftfilt(b,sigVec);
        filtSig = fftfilt(b1,filtSig);
    end
    if (i == 3)
        % Apply filter 3
        filtSig = fftfilt(c,sigVec);
    end
    
    % FFT of filtered signal
    filt_fftSig = fft(filtSig);
    % Discard negative frequencies
    filt_fftSig = filt_fftSig(1:kNyq);
    figure;
    % Plot FFT for input signal
    subplot(2,1,1)
    plot(posFreq,abs(fftSig));
    title("Input signal")
    xlabel("Frequency (Hz)")
    ylabel("FFT")
    % Plot FFT for input signal
    subplot(2,1,2)
    plot(posFreq,abs(filt_fftSig));
    title(['Output signal for filter #',num2str(i)])
    xlabel("Frequency (Hz)")
    ylabel("FFT")   

end
    
