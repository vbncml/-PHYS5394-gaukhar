function sigVec = genafsinsig_new(dataX,snr,P)
% Generate an AM-FM sinusoid signal
% S = CRCBGENQSIG(X,SNR,P)
% Generates an AM-FM sinusoid signal S. X is the vector of
% time stamps at which the samples of the signal are to be computed. SNR is
% the matched filtering signal-to-noise ratio of S, P is a struct containing values for:
% B, the coefficient and 3 frequencies [fo, f1, f2] of the signal 
% S = A*cos(2*pi*f2*t)*sin(2*pi*f0*t+ b*cos(2*pi*f1*t)), 
% where f0>>f1,f2 and f1>f2.
% The fields of P are:
%   'freq0': 
%   ...

%Gaukhar Nurbek, Jan 2021
b = P.b;
f0 = P.freq0;
f1 = P.freq1;
f2 = P.freq2;
sigVec = cos(2*pi*f2*dataX).*sin(2*pi*f0*dataX + b*cos(2*pi*f1*dataX));
sigVec = snr*sigVec/norm(sigVec);


