function sigVec = gensinsig(dataX,snr,f0,phi0)
% Generate a sinusoid singal
% S = GENSINSIG(X,SNR,F0,Phi0)
% Generates a sinusoidal signal S. X is the vector of
% time stamps at which the samples of the signal are to be computed. SNR is
% the matched filtering signal-to-noise ratio of S, F0 is the intial frequency 
% and Phi0 is the phase of the signal : A*sin(2*pi*f0*t + phi0) 

sigVec = sin(2*pi*f0*dataX + phi0);
sigVec = snr*sigVec/norm(sigVec);
end


