function stimulus = getStimulus(stimulusDuration, stimulusType, numberInput)

%%

% DESCRIPTION ---------------------------------------------------

% In this file, I included some most commonly used stimulus types, stimulus
% types include :

% (1) one pulse contrast stimulus of dirrent length of durations
% (2) two pulses contrast stimuli of pre-specified duration and isi
% (3) square wave of prespecified duty cycles
% (4) sinusoid of prespecified cycle length


% INPUT(s) ---------------------------------------------------------

% stimulusDuration  : length of the stimulus in the unit of millisecond.
                      % stimulus timing ranges from 1 : stimulusDuration.

% stimulusType      : one of the following text strings : 'onepulse',
                      % 'twopulses', 'square' and 'sin'.
                    
% numberInput       : if stimulusType is 'onepulse," numberInput = pulse
                      % length in unit of millisecond; if stimulusType is
                      % 'twopulses', numberInput is a vector of 3 entries: 
                      % [length of first pulse, length of isi, length of
                      % second pulse]; if stimulusType is "square"

% OUTPUT(s) -------------------------------------------------------

% stimulus          : stimulus output of size([1, stimulusDuration]). 


% EXAMPLE ------------------------------------------------------

showExampleOn = 0;
showExample = 'twopulses';


%% show example

if showExampleOn == 1
    stimulusType     = showExample;
    stimulusDuration = 1000;
    stimulus         = zeros(1, stimulusDuration);
    switch showExample
        case 'onepulse'
            numberInput = 200;
        case 'twopulses'
            numberInput = [100, 200, 100];
        case 'square'
            numberInput = 10;
        case 'sin'
            numberInput = 3;
    end
end


%% checking if all inputs are of the right types

assert(isstr(stimulusType), 'stimulus type needs to be a string');

if stimulusDuration < 100 | numberInput < 1
    warning ('Stimulus duration needs to be in unit of millisecond, check stimulus duration unit.')
end

stimulus = zeros(1, stimulusDuration);


%% generate stimulus

stimulusType = lower(stimulusType);

switch stimulusType
    case 'onepulse'
        
        stimulus(1 : round(numberInput)) = 1;
        
    case 'twopulses'
        
        assert(length(numberInput) == 3, 'Need three numbers for two pulses condition');
        
        stimulus(1: numberInput(1)) = 1;
        stimulus(numberInput(1) + numberInput(2) + 1 : sum(numberInput)) = 1;
        
    case 'square'
        
        stimulus = square(1: stimulusDuration, numberInput);
        stimulus = (stimulus + 1)./2;
        
    case 'sin'
        
        stimulus = sin(linspace(0, 2 * pi * numberInput, length(stimulus)));
        stimulus = (stimulus + 1)./2;
end


%% visualize stimulus (for debugging)

if showExampleOn == 1
    figure (100), clf
    plot(stimulus, 'lineWidth', 3)
    title('Example Stimulus')
    xlabel('time (ms)')
    ylabel('contrast amplitude'), 
    grid on
    ylim([-0.5, 1.5])
end