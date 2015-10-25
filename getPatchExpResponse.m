function [poolRsp, perturbedParam] = getPatchExpResponse(decayParam, timeLength, noiseStd, nNeurons)

% DESCRIPTION ------------------------

% This function is to compute exponentiated response (normalization pool
% response) given a vector of decay parameters


% DEPENDENCIES -----------------------

% /

% INPUT(S) ---------------------------

% decayParam  : the rate of decay.
% timeLength  : the length of time period in unit of milliseconds.
% noiseStd    : noise added to decayParam.
% nNeurons    : number of exponentiating computations.


% OUTPUT(S) --------------------------

% poolRsp     : size nNeurons x length(1 : timeLength).


% HISTORY ---------------------------

% created in 10/25/2015


% EXAMPLE -----------------------------

exampleOn = 0;


%% Examine inputs and set up the examples

if exampleOn
    decayParam = 0.4;
    timeLength = 6000;
    noiseStd   = 0.04;
    nNeurons   = 100;
end


%% compute exponentiated response

time    = 1 : timeLength;
time    = time./1000;
poolRsp = zeros(nNeurons, length(time));
noise   = randn(1, nNeurons).* noiseStd;


for k = 1 : nNeurons,
    poolRsp(k, :)     = exp(-time./(decayParam + noise(k)));
    poolRsp(k, :)     = poolRsp(k, :)./sum(poolRsp(k, :));
    perturbedParam(k) = decayParam + noise(k);
end


%% plotting. show example

if exampleOn
    figure (100), clf
    
    plot(time/1000, poolRsp)
    xlabel('time (s)')
    ylabel('Amplitude')
    title('Example Decay')
    grid on
end



end