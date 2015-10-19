
function output = convCut (stimulus, impulse, nTerms)


% DESCRIPTION ------------------------------------------------

% This function is useful for temporal analysis, it convolves the stimulus
% with an impulse response and cut the terms of the convolution result after
% "nTerms."

% DEPENDENCIES ----------------------------------------------

% / 


% INPUTS -----------------------------------------------------

% input       : usually is a stimulus time series
                % impulse_response: usually is a hemodynamic response
% num_term    : number of terms in convolution output between "input" and
                % "impulse_response" starting from 1

% OUTPUT(S) --------------------------------------------------

% conv_output : full length output cut between 1 and num_term


%% compute convolution:        

output = conv(stimulus, impulse, 'full');

output = output(1:nTerms);


end