function s = fitNormAnyStimulus(x, stimulus, data, trialOrder, numRepeat, figureOn)

% DESCRIPTION ------------------------------

% This file is for fitting normalizaiton model given any type of stimulus.
% Still under construction.


% DEPENDENCIES ----------------------------

% getStimulus.m
% getPatchLinearResponse.m
% getPatchExpResponse.m
% normalize.m
% fMRIsimulator.m


% INPUT(S) -------------------------------

% x          : input parameters (IRF length, normalization pool length and scaling factor)
% stimulus   : number of Condition x time series
% data       : beta weights for each condition
% trialOrder : order of the stimulus when put into a fMRI experiment


% OUTPUT(S) -----------------------------

% s          : sum of squared errors between data(simulated data) and
%              fitted model response.


% HISTORY -----------------------------

% Created in 10/ 26/ 2015.


% EXAMPLE ---------------------------------

exampleOn = 0;


% BUILT-IN PARAMETERS ----------------------

sigma     = 0.1;
n         = 1;


%% validate input and set up example

if exampleOn
    x          = [0.05, 0.4, 0.1];
    stimulus   = getStimulus(1000, 'onepulse', 100);
    data       = 230;
    trialOrder = ones(1, 10);
    numRepeat = 9;
end

assert(length(trialOrder) == size(stimulus, 1) * (numRepeat + 1) , ...
    'length(trialOrder) = num.Stimulus * (numRepeat + 1)');


%% compute the difference between data and model prediction

target = x(3).* normalization (x, stimulus);

if size(target) ~= size(data),
    target = target';
end

assert(isequal(size(data), size(target)), 'size of data and target need to be equal');

s = sum((data - target).^2);


%% compute normalization model

    function normalizedOutput = normalization(x, stimulus)
        nConditions = size(stimulus, 1);
        timeLength  = size(stimulus, 2);
        
        
        linRsp  = zeros(nConditions, timeLength);
        poolRsp = zeros(size(linRsp));
        normRsp = zeros(size(linRsp));
        
        % compute linear response:
        for cStim = 1 : nConditions
            linRsp(cStim, :) = getPatchLinearResponse(stimulus(cStim, :), 'oneGamma', x(1), 0, 1);
        end
        
        % compute normalization pool response and normalization response
        for cStim1 = 1 : nConditions
            poolRsp(cStim1, :) = getPatchExpResponse(x(2), timeLength, 0, 1);
            normRsp(cStim1, :) = normalize(linRsp(cStim1, :), poolRsp(cStim1, :), sigma, n);
        end
        
        neuralRsp (1, :, :) = normRsp;
        
        normalizedOutput = fMRIsimulator(neuralRsp, numRepeat, 0, trialOrder, 0);
    end

%% plotting the example

if exampleOn | figureOn
    figure (102), clf
    subplot(2, 1, 1)
    imagesc(stimulus)
    
    subplot(2, 1, 2)
    imagesc(normRsp)    
end

% 
% figure (103)
% plot(data), hold on
% plot(target),
% legend('data', 'target')
% drawnow
end