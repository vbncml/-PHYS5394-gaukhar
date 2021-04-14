%% How to normalize a signal for a given SNR
% We will normalize a signal such that the Likelihood ratio (LR) test for it has
% a given signal-to-noise ratio (SNR) in noise with a given Power Spectral 
% Density (PSD). [We often shorten this statement to say: "Normalize the
% signal to have a given SNR." ]

%%
% Path to folder containing signal and noise generation codes
addpath ../lab_l6
addpath ../lab_l8
addpath ../lab_l8_p2

%%
% This is the target SNR for the LR
snr = 10;

%%
% Generate the signal that is to be normalized
% Signal parameters
f0 = 100;
f1 = 0.5;
f2 = 1;
A = 10;
b = 5;
% Data generation parameters 
% maxFreq = f0+b*f1;
% sampFreq = maxFreq;
%SDM **************************
sampFreq = 2048; %Hz
%******************************
nSamples = 2048;
timeVec = (0:(nSamples-1))/sampFreq;

% Generate the signal
sigVec = genafsinsig(timeVec,A,b,[f0,f1,f2]);

%%
% Use LIGO Sensitivity PSD
% Read data and interpolate PSD values
psdVals = load('iLIGOSensitivity.txt','-ascii');
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
interpPsdVals = interp1(psdVals(:,1),psdVals(:,2),posFreq);
len = length(posFreq);
freqVec = posFreq;
psdVec = reshape(interpPsdVals,1,length(posFreq));

% apply f <= 50 => s(f) = s(50) and f >= 700 => s(f) = s(700)
% idx_low = find(round(freqVec)==50);
% idx_high = find(round(freqVec)==718);
%SDM *******************************
idx_low = find(freqVec<=50, 1, 'last' );
idx_high = find(freqVec >= 700, 1 );
psdVec(1:idx_low) = psdVec(idx_low);
%***********************************
%psdVec(1:idx_low) = psdVec(idx_low(3));
psdVec(idx_high:end) = psdVec(idx_high);
%SDM *******************************
psdPosFreq = psdVec.^2;
figure;
loglog(posFreq,psdPosFreq);
hold on;
[pxx,f]=pwelch(statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq),...
               128,[],[],sampFreq);
loglog(f,pxx)
%************************************
%plot(posFreq,psdPosFreq);
axis([0,posFreq(end),0,max(psdPosFreq)]);
xlabel('Frequency (Hz)');
ylabel('PSD ((data unit)^2/Hz)');

%% Calculation of the norm
% Norm of signal squared is inner product of signal with itself
normSigSqrd = innerprodpsd(sigVec,sigVec,sampFreq,psdPosFreq);
% Normalize signal to specified SNR
sigVec = snr*sigVec/sqrt(normSigSqrd);

%% Test
%Obtain LLR values for multiple noise realizations
nH0Data = 1000;
llrH0 = zeros(1,nH0Data);
for lp = 1:nH0Data
    noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
    llrH0(lp) = innerprodpsd(noiseVec,sigVec,sampFreq,psdPosFreq);
end
%Obtain LLR for multiple data (=signal+noise) realizations
nH1Data = 1000;
llrH1 = zeros(1,nH1Data);
for lp = 1:nH0Data
    noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
    % Add normalized signal
    dataVec = noiseVec + sigVec;
    llrH1(lp) = innerprodpsd(dataVec,sigVec,sampFreq,psdPosFreq);
end
%%
% Signal to noise ratio estimate
estSNR = (mean(llrH1)-mean(llrH0))/std(llrH0);

figure;
histogram(llrH0);
hold on;
histogram(llrH1);
xlabel('LLR');
ylabel('Counts');
legend('H_0','H_1');
title(['Estimated SNR = ',num2str(estSNR)]);

%%
% A noise realization
figure;
plot(timeVec,noiseVec);
xlabel('Time (sec)');
ylabel('Noise');
%%
% A data realization
figure;
plot(timeVec,dataVec);
hold on;
plot(timeVec,sigVec);
xlabel('Time (sec)');
ylabel('Data');


