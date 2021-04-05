function glrt = glrtqcsig(dataVec,psdPosFreq,a1,a2,a3)
% Compute GLRT
%Generate the unit norm signal (i.e., template). Here, the value used for
%'A' does not matter because we are going to normalize the signal anyway.
%Note: the GLRT here is for the unknown amplitude case, that is all other
%signal parameters are known
A = 1;
nSamples = length(dataVec);
sampFreq = 1024;
timeVec = (0:(nSamples-1))/sampFreq;
sigVec = crcbgenqcsig(timeVec,A,[a1,a2,a3]);
%We do not need the normalization factor, just the  template vector
[templateVec,~] = normsig4psd(sigVec,sampFreq,psdPosFreq,1);
% Calculate inner product of data with template
llr = innerprodpsd(dataVec,templateVec,sampFreq,psdPosFreq);
%GLRT is its square
glrt = llr^2;