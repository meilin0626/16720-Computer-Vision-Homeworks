% load a training example image
Itrain = im2double(rgb2gray(imread('../custom/test111.jpg')));

%have the user click on some training examples.  
% If there is more than 1 example in the training image (e.g. faces), you could set nclicks higher here and average together
nclick = 2;
figure(1); clf;
imshow(Itrain);
[x,y] = ginput(nclick); %get nclicks from the user

%compute 8x8 block in which the user clicked
blockx = round(x/8);
blocky = round(y/8); 

%visualize image patches that the user clicked on
figure(2); clf;
for i = 1:nclick
  patch = Itrain(8*blocky(i)+(-63:64),8*blockx(i)+(-63:64));
  figure(2); subplot(3,2,i); imshow(patch);
end

% compute the hog features
f = hog(Itrain);

% compute the average template for the user clicks
template = zeros(16,16,9);
for i = 1:nclick
  template = template + f(blocky(i)+(-7:8),blockx(i)+(-7:8),:); 
end
template = template/nclick;


%% Perform detection on a test image

%
% load a test image
%
Itest= im2double(rgb2gray(imread('../custom/test112.jpg')));

% find top detections in Itest
ndet = 2;
% [x,y,score] = detect(Itest,template,ndet);
clear heatmap; 
[x,y,score, heatmap] = detectwh(Itest,template,ndet);

%display top ndet detections
figure; clf;
imshow(Itest);
colors = {'red', 'blue'};
for i = 1:ndet
  % draw a rectangle.  use color to encode confidence of detection
  %  top scoring are green, fading to red
  hold on; 
  h = rectangle('Position',[x(i)-64 y(i)-64 128 128],'EdgeColor',colors{i},'LineWidth',3,'Curvature',[0.3 0.3]); 
  hold off;
end

% Show heatmap if it is defined
if exist('heatmap', 'var') == 1
    % Display the heatmap
    figure; clf;
    imagesc(heatmap);
    axis image
    axis off
end