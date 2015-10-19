function linearRsp = getPatchLinearResponse(stimulus, impulseType, impulseParam, noiseStd, nNeurons)

% DESCRIPTION ------------------------------------------

% The purpose of this function is to compute neuron's linear response to
% arbitrary stimulus.

% DEPENDENCIES ----------------------------------------

% getStimulus.m
% conv_cut.m
% gammaPDF.m (I think this is an adaptation from Kendrick's tool)

% INPUT(S) -----------------------------------------------

% stimulus     : a vector represents event time series. In unit of
%                millisecond. (e.g. size being (1, 5000))
% impulseType  : 'oneGamma' or 'twoGammas'.
% impulseParam : if impulseType is 'oneGamma', impulseParam is a number
%                indicating the length og time before the impulse
%                response reaches a peak.
%                If impulseType is 'twoGammas', impulseParam is a vector
%                of 3 numbers: the peak of the first gamma, the peak of
%                the second gamma, the weight of the second gamma. Notice
%                that the number here indicates the mean impulse response
%                of the patch of neurons
% noiseStd     : indicates the difference in the impulse repsonse functions
%                in the patch.
% nNeurons     : number of neurons in the patch. If nNeurons = 100, output
%                would be of size [100, length(stimulus)]

% OUTPUT(S) --------------------------------------------

% linearRsp    : size(nNeurons, length(stimulus))

% EXAMPLE ----------------------------------------------

exampleOn = 1;

if exampleOn
    stimulus     = getStimulus(1000, 'onepulse', 300);
    %impulseType  = 'oneGamma';
    %impulseParam = 0.05;
    impulseType  = 'twogammas';
    impulseParam = [0.05, 0.2, 0.4];
    noiseStd     = 0.01;
    nNeurons     = 100;
end


%% check if input arguments are of the right type

impulseType = lower(impulseType);

if strcmp(impulseType, 'onegamma'),
    assert(length(impulseParam) == 1, 'impulseParam should be one number');
    if impulseParam > 1
        warning('Check : Unit of time is millisecond, impulseParam might be too long.')
    end
elseif strcmp(impulseType, 'twogammas')
    assert(length(impulseParam) == 3, 'impulseParam should be one number');
end


%% Compute linear response for the neuron patch

linearRsp = zeros(nNeurons, length(stimulus));
impulse   = zeros(size(linearRsp));


% generate noise :

noise = randn(1, nNeurons).* noiseStd;
peak  = max(0.0008, impulseParam(1) + noise);

switch impulseType
    case 'onegamma'
        
        for k = 1 : nNeurons
            impulse(k, :) = gammaPDF((1 : length(stimulus))./1000, peak(k), 2);
        end
        
    case 'twogammas'
        
        secondPeak = max(0.05, impulseParam(2) + randn(1, nNeurons).* noiseStd);
        for k = 1 : nNeurons
            impulse(k, :) = gammaPDF((1 : length(stimulus))./1000, peak(k), 2) - ...
                impulseParam(3) * gammaPDF((1 : length(stimulus))./1000, secondPeak(k), 2);
        end
end

% compute linear response:

for k1 = 1 : nNeurons,
    linearRsp(k1, :) = convCut(impulse(k, :), stimulus, length(stimulus));
end


%%  Visualize the repsonse

if exampleOn
    figure (100), clf
    subplot(3, 2, 1)
    plot(stimulus),
    xlabel('time (ms)'),
    ylabel('contrast'),
    title('stimulus'), grid on
    
    subplot(3, 2, 3)
    plot(impulse(1,:))
    ylabel('amp.')
    title('impulse response'), grid on
    
    subplot(3, 2, 5)
    plot(linearRsp(1,:))
    xlabel('time (ms)'),
    ylabel('amp.'),
    title('neural repsonse'), grid on
    
    subplot(3, 2, 2)
    hist(peak)
    title('distribution of Peak'), grid on
    
    if length(impulseParam) > 1
        subplot(3, 2, 4)
        hist(secondPeak),
        title('distribition of the second peak'),
        grid on
    end
end


end