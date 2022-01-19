% here we're cleaning the noise out of a video of a lymph node
% this file was created to take the raw image, binarize each frame, and return a video that preserves only the pixels that exist in an adjustable neighborhood in time
% ex: if radius=1, then a pixel in 'noNoise.mov' exists only if there is a value there one frame before AND one frame after


clear all
close all
clc
%%

video = VideoReader('dcLN_movie_1 (5).mov');
k=1;
while hasFrame(video)
    slice = readFrame(video);
    slice(:,:,3) = 0;
    grey=im2gray(slice);
    greyFrames(:,:,k)=grey;
    k=k+1;
end

SZ = size(greyFrames);
%%

windowSZ = [5 5 9];
greyFilt = medfilt3(greyFrames,windowSZ);
filtFrames = zeros(SZ);
for frame=1:SZ(3)
    gSlice=greyFilt(:,:,frame);
    BWslice= imbinarize(gSlice);
    BWslice= bwareaopen(BWslice,10);
    SE = strel('disk', 10);
    BWslice = imclose(BWslice,SE);
    gSlice = imoverlay(greyFrames(:,:,frame),~BWslice,'k');
    gSlice = im2gray(gSlice);
    gSlice = im2double(gSlice);
    filtFrames(:,:,frame)=gSlice;
end

%%
save('CLEANED.mat','filtFrames');
v= VideoWriter("noNoise.mov", "Grayscale AVI")
v.FrameRate=4
open(v)
v.writeVideo(filtFrames);
close(v)
