function generate_motion(p, filename)

nDots = round(p.dotsPerSquareDegree*(p.circleRadius_inDegrees^2*pi));
circleRadius_inPixels = degrees2pixels(p.circleRadius_inDegrees);

% for plot
margin = 5 ;
x_lim = [p.width/2-circleRadius_inPixels-margin, p.width/2+circleRadius_inPixels+margin];
y_lim = [p.height/2-circleRadius_inPixels-margin, p.height/2+circleRadius_inPixels+margin];

% Speed variables
dotSpeed_inPixelsPerSec = degrees2pixels(p.dotSpeed_inDegPerSec);
dotSpeed_inPixelsPerFrame = dotSpeed_inPixelsPerSec / p.framerate;

% Define dots' initial positions and lifetimes
DotPositions = zeros(2,nDots);
DotLifetimes = ceil(3*rand(1,nDots))+2; %lifetime from 3 to 5 frames

% Create dot position randomly such that it's in the circle
% NB! we are not checking if the position is unique since dots
% will overlap later in each trial anyway
angles = 2*pi*rand(1,nDots);
distances = circleRadius_inPixels*sqrt(rand(1,nDots));
DotPositions(1,:) = distances.*sin(angles);
DotPositions(2,:) = distances.*cos(angles);

v = VideoWriter(filename);
open(v);

%Start the actual sequence
for frame=1:p.num_motion_frames
    
    pause(0.1)
    plot(DotPositions(1,:), DotPositions(2,:), 'wo', 'MarkerFaceColor', 'w')
    xlim(x_lim)
    ylim(y_lim)
    set(gca,'Color','k', 'xtick', [], 'ytick', [])
    
    video_frame = getframe(gca);
    writeVideo(v, video_frame);
    
    % Update the dots - get a random permutation of the dots, and
    %choose an appropriate number of dots that have continued lifetime to
    %carry the coherent motion to the next frame
    randPermOfDots = randperm(nDots);
    dotsMovingCoherent = zeros(1,nDots);
    count_coherent_dots = 0;
    for j=1:nDots
        if DotLifetimes(randPermOfDots(j)) >= 1
            count_coherent_dots = count_coherent_dots + 1;
            dotsMovingCoherent(randPermOfDots(j)) = 1;
            if count_coherent_dots >= p.coherence*nDots
                break;
            end
        end
    end
    
    % Set the direction of motion
    directionOfMotion = 2*pi*rand(1,nDots); %incoherent dots
    directionOfMotion(dotsMovingCoherent==1) = p.motion_direction; %coherent dots
    
    % Compute the new position of the dots
    DotPositions(1,:) = DotPositions(1,:) + sin(directionOfMotion).*dotSpeed_inPixelsPerFrame;
    DotPositions(2,:) = DotPositions(2,:) + cos(directionOfMotion).*dotSpeed_inPixelsPerFrame;
    
    % Identify which dots have expired lifetime
    expired = zeros(1,nDots);
    expired(DotLifetimes==0) = 1;
    DotLifetimes(expired==1) = ceil(3*rand(1,sum(expired))) + 3; %update lifetime
    
    % Identify the dots that ended up outside the circle
    outside = (DotPositions(1,:) - p.width/2).^2 + ...
        (DotPositions(2,:) - p.height/2).^2 >= circleRadius_inPixels^2;
    
    % Dots that have expired lifetime or are outside the circle should get
    % randomly placed back inside the circle
    toMove = (expired == 1) | (outside == 1);
    angles = 2*pi*rand(1,sum(toMove));
    distances = circleRadius_inPixels*sqrt(rand(1,sum(toMove)));
    DotPositions(1,toMove) = (p.width/2)+ distances.*sin(angles);
    DotPositions(2,toMove) = p.height/2 + distances.*cos(angles);
    
    % Decrease dot lifetime by one frame
    DotLifetimes = DotLifetimes - 1; 
end

close(v);

