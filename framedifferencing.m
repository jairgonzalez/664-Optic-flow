filename = 'ZebraFishSHORTCROPPED.mp4';
mov = VideoReader(filename);
numFrames = mov.NumberOfFrames;
numFramesWritten = 0;

frames = read(mov);
frameInfo = size(frames);
height = frameInfo(2);
width = frameInfo(1);
pixels = width .* height;
disp(pixels);

for l = 1:(500)
    temp = frames(:,:,:,l);
    temp = double(im2gray(temp));
    temp2 = frames(:,:,:,l + 1);
    temp2 = double(im2gray(temp2));
    temp3 = frames(:,:,:,l); % rgb frame
    for w = 1:width
        for h = 1:height
            if(abs(temp2(w, h) - temp(w, h)) > 30) 
                temp3(w, h,:) = [255, 0, 0];

            else 
                %temp(w, h) = 255; 
                %temp(w, h) = temp2(w, h);
            end
        end 
    end
    %imshow(temp);

    imshow(temp3);
end 
