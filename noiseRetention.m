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
    BWFrames(:,:,k)=imbinarize(grey); %adaptive for dim areas?
    k=k+1;
end

windowRadius = 2;
f=2;
i=1;
j=1;
count=1;
noNoise = false(448,448,35);
for f = 1+windowRadius:37-windowRadius;
    for i =1:448
        for j=1:448
            window = BWFrames(i,j,f-windowRadius:f+windowRadius);
            
            if mean(window)==1
                noNoise(i,j,f) = true;
            else
                noNoise(i,j,f) = false;
            end
            
        end
        
    end
    
end
%%
video = VideoReader('dcLN_movie_1 (5).mov')
%SE = strel('disk', 100);
k=1;
SE = strel('disk',10);
while hasFrame(video) & k<37
    slice = readFrame(video);
    if 3<k<35
        slice(:,:,3) = 0;
        grey=rgb2gray(slice);
        tempMask = noNoise(:,:,k);
        tempMask = bwareaopen(tempMask,10);
        tempMask = imclose(tempMask,SE);
        
        nodeOL = imoverlay(grey, ~tempMask, 'k');
        OLFrames(:,:,k)=im2gray(nodeOL);
    end
    k=k+1;
end
%%
v= VideoWriter("noNoise.mov", "Grayscale AVI")
v.FrameRate=4
open(v)
v.writeVideo(OLFrames);
close(v)