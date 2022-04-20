clear
clc

% Basic parameters
p.width = 100 ;
p.height = 100 ;
p.num_motion_frames = 5 ;
p.motion_direction = pi/2 ;
p.coherence = 0.25 ;
p.dotsPerSquareDegree = 3.4;
dotsPerSquareDegreeArr = [1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5 5, 5.5];

p.dotSpeed_inDegPerSec = 2;
p.circleRadius_inDegrees = 2;
p.framerate = 50;


% % Loop to create dataset
% for i = 1:3
%     p.dotsPerSquareDegree = dotsPerSquareDegreeArr(i) ;
%     filename = '/Volumes/Lexar/test' + string(i+10) ;
%     generate_motion(p, filename) ;
% end


% %loop 2 to create dataset of 2000
% for z = 1:2
%     if z == 1
%         p.motion_direction = pi/2; %right
%     else
%         p.motion_direction = (3*pi)/2; %left
%     end
% 
%     for i = 1:7
%         p.dotsPerSquareDegree = 2+(.2 * i);
%         for j = 1:7
%             p.circleRadius_inDegrees = 1+(.2 * j);
%             for k = 1:7
%                 p.framerate = 40 + k;
%                 filename = '/Volumes/Lexar/NoiseData/test' + string(z) +...
%                     string(i) + string(j) + string(k);
%                 
%                 generate_motion(p,filename);
%       
%             end
%         end
%     end
% end


filename = './test_01.avi';
generate_motion(p, filename)