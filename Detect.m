% Project Title: Pomegranate Leaf Disease Detection

clc
close all 
clear all

[filename, pathname] = uigetfile({'*.*';'*.bmp';'*.jpg';'*.gif'}, 'Pick a Leaf Image File');
I = imread([pathname,filename]);
I = imresize(I,[256,256]);
figure, imshow(I); title('Query Leaf Image');

% Enhance Contrast
I = imadjust(I,stretchlim(I));
figure, subplot(221);
imshow(I);title('Contrast Enhanced');

% Otsu Segmentation
I_Otsu = im2bw(I,graythresh(I));
% Conversion to HIS
I_HIS = rgb2hsi(I);

%% Extract Features

% Function call to evaluate features
%[feat_disease seg_img] =  EvaluateFeatures(I)

% Color Image Segmentation
% Use of K Means clustering for segmentation
% Convert Image from RGB Color Space to L*a*b* Color Space 
% The L*a*b* space consists of a luminosity layer 'L*', chromaticity-layer 'a*' and 'b*'.
% All of the color information is in the 'a*' and 'b*' layers.
cform = makecform('srgb2lab');
% Apply the colorform
lab_he = applycform(I,cform);

% Classify the colors in a*b* colorspace using K means clustering.
% Since the image has 3 colors create 3 clusters.
% Measure the distance using Euclidean Distance Metric.
ab = double(lab_he(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
nColors = 3;
[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);
%[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',3);
% Label every pixel in tha image using results from K means
pixel_labels = reshape(cluster_idx,nrows,ncols);
%figure,imshow(pixel_labels,[]), title('Image Labeled by Cluster Index');

% Create a blank cell array to store the results of clustering
segmented_images = cell(1,3);
% Create RGB label using pixel_labels
rgb_label = repmat(pixel_labels,[1,1,3]);

for k = 1:nColors
    colors = I;
    colors(rgb_label ~= k) = 0;
    segmented_images{k} = colors;
end



subplot(222);imshow(segmented_images{1});title('Future extraction'); 
subplot(223);imshow(segmented_images{2});title('Segmentation');
subplot(224);imshow(segmented_images{3});title('Classification');
set(gcf, 'Position', get(0,'Screensize'));
 