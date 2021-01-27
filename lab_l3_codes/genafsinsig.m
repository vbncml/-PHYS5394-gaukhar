function sigVec = genafsinsig(dataX,snr,b,freqs)
% Generate an AM-FM sinusoid signal
% S = CRCBGENQSIG(X,SNR,B,F)
% Generates an AM-FM sinusoid signal S. X is the vector of
% time stamps at which the samples of the signal are to be computed. SNR is
% the matched filtering signal-to-noise ratio of S, B is the coefficient and F is the vector of
% 2 frequencies [fo, f1] of the singnal 

%Gaukhar Nurbek, Jan 2021

sigVec = cos(2*pi*freqs(2)*dataX).*sin(2*pi*freqs(1)*dataX + b*cos(2*pi*freqs(2)*dataX));
sigVec = snr*sigVec/norm(sigVec);


