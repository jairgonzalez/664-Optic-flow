%% tracks points using Lucas-Kanade method

vid_reader = vision.VideoFileReader('ZebraFishSHORTCROPPED.mp4');
vid_player = vision.VideoPlayer('Position',[100,100,680,520]);
frame = vid_reader();
figure; imshow(frame); 
title('Select region of interest');
RegioOfInterest=round(getPosition(imrect))% use mouse to select region

points = detectMinEigenFeatures(rgb2gray(frame),'ROI',RegioOfInterest);

pointImage = insertMarker(frame,points.Location,'+','Color','blue');
figure;
imshow(pointImage);
title('Detected interest points');

point_tracker = vision.PointTracker('MaxBidirectionalError',1);
initialize(point_tracker,points.Location,frame);

while ~isDone(vid_reader)
      frame = vid_reader();
      [points,validity] = point_tracker(frame);
      output_vid = insertMarker(frame,points(validity, :),'+');
      vid_player(output_vid);
      setPoints(point_tracker,points);
end

release(vid_player);
release(vid_reader);