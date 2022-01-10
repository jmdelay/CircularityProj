%% Vid 2 Lib
% Here I want to take the cleaned lymph node video and make a folder library of
% distinct shapes from which I can batch process scores and run
% correlations among circularity metrics.
clear all;close all;
%%

load CLEANED.mat

%%
rect =[30.5100   17.5100  389.9800  403.9800];
SZ = size(OLFrames);
SE = strel('disk',10);

for frame=1:SZ(3)

    tempFrame = OLFrames(:,:,32);
    tempFrame = imcrop(tempFrame,rect);
    BW = imbinarize(tempFrame,"adaptive"); % no lost detail
    BW = imclose(BW,SE);
    BW= imfill(BW, 'holes');
    BW = bwareafilt(BW,10); %10 largest from each frame
    label = bwlabel(BW);
    props = regionprops('table',label,'BoundingBox');

    % use BB to crop each object and save obj into library folder
    for obj = 1:10
        BB = props.BoundingBox(obj,:)
        idx1 = floor(BB(2));
        idx2 = floor(BB(1));
        cropped = tempFrame( idx1:idx1+BB(4) , idx2:idx2+BB(3) );
        imwrite(cropped,sprintf('objec%dx%d.png',frame,obj));
    end

end
