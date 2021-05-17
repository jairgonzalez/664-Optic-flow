%% 
close all
clear 
clc
%% Set up video reader
cameraFeed = vision.VideoFileReader('ZebraFishSHORTCROPPED.mp4','ImageColorSpace','Intensity');
h = figure(1);

%% Set up optical flow method (LK)
oFlow = opticalFlowLK();
oFlow.NoiseThreshold = 0.01;

%% Loop algorithm
while(~isDone(cameraFeed))
   
    frame = step(cameraFeed);
    flowField = estimateFlow(oFlow,frame);
    
    subplot(1,2,1);
    imshow(frame)   
    title('Original video')
    
    subplot(1,2,2);
    plot(flowField,'DecimationFactor',[10 10],'ScaleFactor',50);    
    title('Optical Flow Vectors')
   
    drawnow;
    
    % press any key to exit loop
    isKeyPressed = ~isempty(get(h,'CurrentCharacter'));
     if isKeyPressed
         break
     end
end
release(cameraFeed);