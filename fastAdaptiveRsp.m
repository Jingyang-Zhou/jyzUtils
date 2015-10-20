function normalizedRsp = fastAdaptiveRsp(time, linearRsp)



% DESCRIPTION -----------------------------------------------------

% Put in linear response, this function computes feedforward normalization
% response using pre-specified parameters

% DEPENDENCIES ---------------------------------------------------

% conv_cut.m
% normalize.m

% INPUTS ---------------------------------------------------------

% time          : time vector, in unit of millisecond
% linearRsp     : linear response of the neuron to some stimulus of length
%                 length(time)

% OUTPUTS --------------------------------------------------------

% normalizedRsp : computed normalized repsonse that has the same length as
%                 linearRsp.


% Check input type : 

assert(length(time) == length(linearRsp), ...
    'Error: linear response and time dimension disagree.')


%% compute normalization pool repsonse

sigma              = 0.01;
n                  = 1;
normPoolFilterBase = 1.1;
filterRange        = 0.4; % second


timeLength         = time(end);
filterLength       = round((filterRange / timeLength) * length(time));
poolFilter         = normPoolFilterBase.^(time(1:filterLength));
poolFilter         = poolFilter./sum(poolFilter);

normPoolRsp        = conv_cut(linearRsp, fliplr(poolFilter), length(time));

%% compute feedforward normalization repsonse


normalizedRsp = normalize(linearRsp, normPoolRsp, sigma, n);


end