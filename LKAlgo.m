%% This code uses Lucas-Kanade method on two images 
% and calculate the optical flow vector for moving objects in the image. 

%% Load images
clear all;
// test
I1 = imread('frames_grey/0004.png');
I2 = imread('frames_grey/0005.png');
figure();
subplot 221
imshow(I1);
title('previous frame')
subplot 222
imshow(I2);
title('next frame')

im1 = I1;
im2 = I2;
if size(I1,3) == 3
    im1 = im2double(rgb2gray(I1));
end
if size(I2,3) == 3
    im2 = im2double(rgb2gray(I2));
end

%% Find corners
% Define the window size for Lucas-Kanade method
ww = 16;
w = round(ww/2);

C1 = corner(im2);

% Discard coners near the margin of the image
k = 1;
for i = 1:size(C1,1)
    x_i = C1(i, 2);
    y_i = C1(i, 1);
    if x_i-w>=1 && y_i-w>=1 && x_i+w<=size(im1,1)-1 && y_i+w<=size(im1,2)-1
      C(k,:) = C1(i,:);
      k = k+1;
    end
end

% Plot corners on the image
subplot 223
imshow(I2);
title('Points on next frame')
hold on
plot(C(:,1), C(:,2), 'r.', 'MarkerSize',20); 

%% Implementing Lucas Kanade Method
% for each point, calculate I_x, I_y, I_t

Ix_m = conv2(im1,[-1 1; -1 1], 'valid'); % partial on x
Iy_m = conv2(im1, [-1 -1; 1 1], 'valid'); % partial on y
It_m = conv2(im1, ones(2), 'valid') + conv2(im2, -ones(2), 'valid'); % partial on t
u = zeros(length(C),1);
v = zeros(length(C),1);
 
% within window ww * ww
for k = 1:length(C(:,2))
    i = C(k,2);
    j = C(k,1);
      Ix = Ix_m(i-w:i+w, j-w:j+w);
      Iy = Iy_m(i-w:i+w, j-w:j+w);
      It = It_m(i-w:i+w, j-w:j+w);
      
      Ix = Ix(:);
      Iy = Iy(:);
      b = -It(:); % get b here
      
      A = [Ix Iy]; % get A here
      nu = pinv(A)*b;
      
      u(k)=nu(1);
      v(k)=nu(2);
end

%% Draw the optical flow vectors
subplot 224
imshow(I2);
title('flow vectors')
hold on;
quiver(C(:,1), C(:,2), u,v, 1,'r','LineWidth',2)

