% quickMotionStimulusExamples:

function stimulus = quickMotionStimulusExample(whichStimulus)

% this function by defaults gives a second of motion stimulus


% PRE-DEFINED VARIABLES ---------------------------------

deltaX          = 1/ 60;
stimArray       = -2 : deltaX : 2;
deltaT          = 1;
stimDuration    = 500; % unit : ms
stimTime        = deltaT/2 : deltaT : stimDuration;
stimContrast    = 1;

% DERIVED VARIABLES ---------------------------------------

stimulus        = zeros(length(stimArray), length(stimArray), stimDuration);
[X,Y]           = meshgrid(stimArray);

% EXAMPLE -----------------------------------------------

exampleOn = 0;
figureOn  = 0;

if exampleOn
    whichStimulus = 'movingbar';
end


% TO DO --------------------------------------------------

% In the Fuze case, I might want to use his dance videos.


%%

switch lower(whichStimulus)
    case 'sinusoiddriftup'
        for t  = 1: stimDuration
            stimulus(:, :, t) = stimContrast * sin(25 * (Y + 0.24 * t));
        end
        
    case 'sinusoiddriftdown'
        for t  = 1: stimDuration
            stimulus(:, :, t) = stimContrast * sin(25 * (Y - 0.24 * t));
        end
        
    case 'sinusoiddriftleft'
        for t  = 1: stimDuration
            stimulus(:, :, t) = stimContrast * sin(25 * (X - 0.24 * t));
        end
        
    case 'sinusoiddriftright'
        for t  = 1: stimDuration
            stimulus(:, :, t) = stimContrast * sin(25 * (X + 0.24 * t));
        end
        
    case 'movingdoty'
        for t = 1 : stimDuration
           stimulus( min(t, size(stimulus, 1)), min(round((abs(sin(t/60)) + 1).*120), size(stimulus, 2)) , t)  = 1;  
        end
        
    case 'movingdotx'
        for t = 1 : stimDuration
            stimulus( min(round((abs(sin(t/60)) + 1).*120), size(stimulus, 2)), min(t, size(stimulus, 1)), t)  = 1;
        end
        
    case 'movingbar'
        for t = 1 : stimDuration
           stimulus(:, min(round(t/2), size(stimulus, 2)), t) = stimContrast; 
        end
        
    case 'oneframe'
        for t = 1 : stimDuration
            stimulus(:, :, 100) = 1;
        end
    case 'fuze'
        a = imread('FuzeImage.jpg');
        a = imresize(a, [size(stimulus, 1), size(stimulus, 2)]);
        a = rgb2gray(a);
        a = a./max(a(:)) - min(a(:));
        for t = 1 : stimDuration
            stimulus(:, :, t) = double(a) + 0.25 * sin(25 * (X - randn * t));
            stimulus(:, :, t) = stimulus(:, :, t) + 0.25 * sin(25 * (Y + randn * t));
        end
    otherwise
        error('Unknown stimulus type.')
end

%%

if figureOn
    figure (100), clf, colormap gray
    
    for k = 1 : size(stimulus, 3)
        imagesc(stimulus(:, :, k))
        caxis([min(stimulus(:)), max(stimulus(:))])
        drawnow
        title(whichStimulus)
        xlabel('x')
        ylabel('y')
        
    end
   
end



end