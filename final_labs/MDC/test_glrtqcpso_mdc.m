% Estimate GLRT and MLE for a given Noise and Signal data
% Path to folder containing signal and noise generation codes, pso fpr glrt, glrt.
addpath ../../SIGNALS
addpath ../../NOISE
addpath /Users/gokha/Desktop/spring2021/stat_meth/PHYS5394-gaukhar/final_labs/lab3
addpath /Users/gokha/Desktop/spring2021/stat_meth/PHYS5394-gaukhar/final_labs/lab4
addpath /Users/gokha/Desktop/spring2021/stat_meth/PHYS5394-gaukhar/lab_l3_codes
addpath /Users/gokha/Desktop/spring2021/stat_meth/PHYS5394-gaukhar/lab11
addpath('/Users/gokha/Desktop/spring2021/stat_meth/SDMBIGDAT19/CODES')
addpath('/Users/gokha/Desktop/spring2021/stat_meth/DATASCIENCE_COURSE/DETEST')
addpath('/Users/gokha/Desktop/spring2021/stat_meth/DATASCIENCE_COURSE/MDC')

%% Create search ranges
rmin = [40 1 1];
rmax = [100 50 15];
nRuns = 8;

%% Load data for analysis
data = load('/Users/gokha/Desktop/spring2021/stat_meth/DATASCIENCE_COURSE/MDC/analysisData.mat');
dataVec = data.dataVec;
nSamples = length(dataVec);
sampFreq = data.sampFreq;
timeVec = (0:(nSamples-1))/sampFreq;
dataVec = data.dataVec;

%% Supply PSD values
% Use given noise to find PSD    
noise = load('TrainingData.mat');
noiseVec = noise.trainData;
noiseVec = reshape(noiseVec,1,length(noiseVec));
[pxx,f]=pwelch(noiseVec,sampFreq,[],[],sampFreq);
psdVals = sqrt(pxx);
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
psdVec = interp1(psdVals,posFreq);
idx_low = find(posFreq<=50, 1, 'last');
idx_high = find(posFreq >= 500, 1 );
psdVec(1:idx_low) = psdVec(idx_low);
psdVec(idx_high:end) = psdVec(idx_high);
psdPosFreq = psdVec;

%% Set parameters for GLRTQCPSO
ffparams = struct('rmin',rmin,...
                     'rmax',rmax, ...
                     'dataX',timeVec, ...
                     'dataXSq',timeVec.^2, ...
                     'dataXCb',timeVec.^3, ...
                     'dataY',dataVec,...
                     'psdPosFreq',psdPosFreq, ...
                     'sampFreq',sampFreq ...
                  );

% Obtain GLRT value for dataVec and calculate MLE 
outStruct = glrtqcpso(ffparams,struct('maxSteps',2000),nRuns);

%% Estimate significance of GLRT
%Obtain GLRT values for multiple noise realizations and count number of
%times glrt>= obtained GLRT for
glrt = outStruct.bestFitness;
a1 = outStruct.bestQcCoefs(1);
a2 = outStruct.bestQcCoefs(2);
a3 = outStruct.bestQcCoefs(3);
nH0Data = 2000;
nGlrts = 0;
for n = 1:nH0Data
    noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
    GLRT = -glrtqcsig(noiseVec,psdPosFreq,a1,a2,a3);
    if glrt <= GLRT
        nGlrts = nGlrts+1;
    end
end
% calculate significance. Answer: there is a signal, since glrt_signif < 0.5
glrt_signif = nGlrts/nH0Data;

%% Plots
figure;
hold on;
plot(timeVec,dataVec,'.');
plot(timeVec,outStruct.bestSig,'Color',[76,153,0]/255,'LineWidth',2.0);
legend('Data','Estimated signal');
xlabel('Time (s)');
ylabel('Signal');

disp(['Estimated parameters: a1=',num2str(outStruct.bestQcCoefs(1)),...
                             '; a2=',num2str(outStruct.bestQcCoefs(2)),...
                             '; a3=',num2str(outStruct.bestQcCoefs(3)),...
                             '; Estimated significance: ',num2str(glrt_signif)]);