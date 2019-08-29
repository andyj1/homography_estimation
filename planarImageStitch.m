%% RANSAC in GeometricTransformEstimator
% Random Sample Consensus
% - Iterative estimation of parameters to a mathematical model from a set
% of observed data that contains outliers

% this assumes camera moving in planar transition (linearly)
close all; clear all; clc; 
%% Read the reference image (first)
% load reference image, and compute surf features
ref_img = imread('1.png');
ref_img_gray = rgb2gray(ref_img);
ref_pts = detectSURFFeatures(ref_img_gray);
[ref_features, ref_validPts] = extractFeatures(ref_img_gray, ref_pts);
% figure; imshow(ref_img);
% hold on; plot(ref_pts.selectStrongest(50));
%% Compare with the second image 
% detect similar features with SURF
image = imread('2.png');
I = rgb2gray(image);
I_pts = detectSURFFeatures(I);
[I_features, I_validPts] = extractFeatures(I, I_pts);
%% Find matching features
index_pairs = matchFeatures(ref_features, I_features);
ref_matched_pts = ref_validPts(index_pairs(:,1)).Location;
I_matched_pts = I_validPts(index_pairs(:,2)).Location;
% figure, showMatchedFeatures(image, ref_img, I_matched_pts, ref_matched_pts, 'montage');
% title('Matched features');
%% Define Geometric Transformation Objects
% 'projective': Random sampling consensus (RANSAC)
[tform_matrix, inlierpoints1, inlierpoints2] = estimateGeometricTransform(ref_matched_pts, I_matched_pts,'projective'); 
% Draw the lines to matched points
% figure;showMatchedFeatures(image, ref_img, inlierpoints2, inlierpoints1, 'montage');
% title('Showing match only with Inliers');
%% Transform the corner points 
% This will show where the object is located in the image
tform = maketform('projective',double(tform_matrix.T));
[width, height,~] = size(ref_img);
corners = [0,0; height,0; height,width; 0,width];
new_corners = tformfwd(tform, corners(:,1),corners(:,2));
figure;imshow(image); hold on;
patch(new_corners(:,1),new_corners(:,2),[0 1 1],'FaceAlpha',0.4); hold on;

Icrop = imcrop(image, [new_corners(2,1), new_corners(2,2), size(image,1), size(image,2)]);

%%
[tform_matrix2, inlierpoints1, inlierpoints2] = estimateGeometricTransform(I_matched_pts,ref_matched_pts,'projective'); 
tform = maketform('projective',double(tform_matrix2.T));
[width, height,~] = size(image);
corners2 = [0,0; height,0; height,width; 0,width];
new_corners2 = tformfwd(tform, corners2(:,1),corners2(:,2));
figure;imshow(ref_img);
patch(new_corners2(:,1),new_corners2(:,2),[0 1 1],'FaceAlpha',0.4);
%%
[hImage, wImage, dImage] = size(Icrop);
[hRef, wRef, dRef] = size(ref_img);
canvas = ref_img; % (1:wRef, 1:hRef, 1:end)
canvasHeight = max(hImage,hRef);
canvasWidth = wImage+wRef;
canvasDepth = max(dImage,dRef);
canvas(1:canvasHeight,wRef+1:canvasWidth,1:canvasDepth) = Icrop; % zeros(hImage, wImage, dImage);
figure; imshow(canvas);
