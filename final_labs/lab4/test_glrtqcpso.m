%% Minimize the fitness function glrtqcsig4pso using PSO
% Path to folder containing signal and noise generation codes.
addpath ../../SIGNALS
addpath ../../NOISE
addpath ../lab3
addpath('/Users/gokha/Desktop/spring2021/stat_meth/SDMBIGDAT19/CODES')
addpath('/Users/gokha/Desktop/spring2021/stat_meth/DATASCIENCE_COURSE/DETEST')
%% Parameters for data realization
% Number of samples and sampling frequency.
nSamples = 512;
sampFreq = 512;
timeVec = (0:(nSamples-1))/sampFreq;
%% Create search ranges
rmin = [1 1 1];
rmax = [180 10 10];

nRuns = 8;
%% Supply PSD values
% This is the noise psd we will use.
noisePSD = @(f) (f>=50 & f<=100).*(f-50).*(100-f)/625 + 1;
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
psdPosFreq = noisePSD(posFreq);

%% Generate  data realization
% Noise + SNR=10 signal. 
a1=10;
a2=3;
a3=3;
snr=10;
rng('default');
noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
sig4data = crcbgenqcsig(timeVec,snr,[a1,a2,a3]);
% Signal normalized to SNR=10
[sig4data,~]=normsig4psd(sig4data,sampFreq,psdPosFreq,10);
dataVec = noiseVec+sig4data;


%% Apply fitness function glrtqc4pso
% The fitness function called is glrtqc4pso. 
ffparams = struct('rmin',rmin,...
                     'rmax',rmax, ...
                     'dataX',timeVec, ...
                     'dataXSq',timeVec.^2, ...
                     'dataXCb',timeVec.^3, ...
                     'dataY',dataVec,...
                     'psdPosFreq',psdPosFreq, ...
                     'sampFreq',sampFreq ...
                  );
% GLRTQCHRPPSO runs PSO on the glrtqcsig4pso fitness function. 
outStruct = glrtqcpso(ffparams,struct('maxSteps',1000),nRuns);

%%
% Plots
figure;
hold on;
plot(timeVec,dataVec,'.');
plot(timeVec,sig4data);
for lpruns = 1:nRuns
    plot(timeVec,outStruct.allRunsOutput(lpruns).estSig,'Color',[51,255,153]/255,'LineWidth',4.0);
end
plot(timeVec,outStruct.bestSig,'Color',[76,153,0]/255,'LineWidth',2.0);
legend('Data','Signal',...
       ['Estimated signal: ',num2str(nRuns),' runs'],...
       'Estimated signal: Best run');
disp(['Estimated parameters: a1=',num2str(outStruct.bestQcCoefs(1)),...
                             '; a2=',num2str(outStruct.bestQcCoefs(2)),...
                             '; a3=',num2str(outStruct.bestQcCoefs(3))]);
xlabel('Time (s)')
ylabel('Signal')