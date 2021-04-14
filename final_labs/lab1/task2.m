%% Plot the AM-FM sinusoid signal
% Signal parameters
f0 = 70;
f1 = 10;
f2 = 5;
A = 10;
b = 2;
snr1 = 10;
snr2 = 12;
snr3 = 15;
% Instantaneous frequency after 1 sec is 
maxFreq = f0+b*f1;
% 5 times the Nyquist sampling frequency
samplFreq = 5*maxFreq;
samplIntrvl = 1/samplFreq;

% Time samples
timeVec = 0:samplIntrvl:1.0;
% Number of samples
nSamples = length(timeVec);
% Create a function handle
H = @(x) genafsinsig_new(timeVec,x,P);
% Define struct P
P = struct('b',b,'freq0',f0,'freq1',f1,'freq2',f2);
% Generate the signal
sigVec1 = H(snr1);
sigVec2 = H(snr2);
sigVec3 = H(snr3);
%Plot the signal 
figure;
plot(timeVec,sigVec1,'Marker','.','MarkerSize',14);
title("Time series of AM-FM sinusoid for snr = ",snr1)
xlabel("Time (s)")
ylabel("Signal")
figure;
plot(timeVec,sigVec2,'Marker','.','MarkerSize',14);
title("Time series of AM-FM sinusoid for snr = ",snr2)
xlabel("Time (s)")
ylabel("Signal")
figure;
plot(timeVec,sigVec3,'Marker','.','MarkerSize',14);
title("Time series of AM-FM sinusoid for snr = ",snr3)
xlabel("Time (s)")
ylabel("Signal")
